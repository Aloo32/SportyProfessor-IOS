import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices
import CryptoKit

@MainActor
class AuthViewModel: NSObject, ObservableObject {

    // MARK: - Published Properties

    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var currentNonce: String?

    // MARK: - Initialization

    override init() {
        super.init()
        checkAuthenticationState()
    }

    // MARK: - Google Sign-In

    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase configuration error"
            isLoading = false
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "Could not get root view controller"
            isLoading = false
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self.errorMessage = "Failed to get user information"
                    self.isLoading = false
                    return
                }

                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )

                Auth.auth().signIn(with: credential) { authResult, error in
                    Task { @MainActor [weak self] in
                        guard let self else { return }

                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            self.isLoading = false
                            return
                        }

                        if let firebaseUser = authResult?.user {
                            self.currentUser = User(
                                id: firebaseUser.uid,
                                email: firebaseUser.email ?? "",
                                displayName: firebaseUser.displayName ?? "User"
                            )
                            self.isAuthenticated = true
                        }
                        self.isLoading = false
                    }
                }
            }
        }
    }

    // MARK: - Apple Sign-In

    func signInWithApple() {
        isLoading = true
        errorMessage = nil

        let nonce = randomNonceString()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }

    func handleAppleSignInCompletion(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                errorMessage = "Invalid state: A login callback was received, but no login request was sent."
                isLoading = false
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                errorMessage = "Unable to fetch identity token"
                isLoading = false
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                errorMessage = "Unable to serialize token string from data"
                isLoading = false
                return
            }

            let credential = OAuthProvider.credential(
                providerID: AuthProviderID.apple,
                idToken: idTokenString,
                rawNonce: nonce
            )

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    let nsError = error as NSError

                    // Check for account conflict
                    if nsError.code == AuthErrorCode.accountExistsWithDifferentCredential.rawValue {
                        self?.errorMessage = "This email is already linked to another sign-in method (Google or Email). Please use that method."
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                    self?.isLoading = false
                    return
                }

                if let firebaseUser = authResult?.user {
                    // Get display name from Apple ID credential or use email
                    var displayName = firebaseUser.displayName ?? "User"
                    if let fullName = appleIDCredential.fullName {
                        let firstName = fullName.givenName ?? ""
                        let lastName = fullName.familyName ?? ""
                        if !firstName.isEmpty || !lastName.isEmpty {
                            displayName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)

                            // Update Firebase profile with the name
                            let changeRequest = firebaseUser.createProfileChangeRequest()
                            changeRequest.displayName = displayName
                            changeRequest.commitChanges { error in
                                if let error = error {
                                    print("Error updating display name: \(error)")
                                }
                            }
                        }
                    }

                    self?.currentUser = User(
                        id: firebaseUser.uid,
                        email: firebaseUser.email ?? appleIDCredential.email ?? "",
                        displayName: displayName
                    )
                    self?.isAuthenticated = true
                }
                self?.isLoading = false
            }
        }
    }

    func handleAppleSignInError(error: Error) {
        errorMessage = error.localizedDescription
        isLoading = false
    }

    // MARK: - Email/Password Authentication

    func signInWithEmail(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            Task { @MainActor [weak self] in
                guard let self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }

                if let firebaseUser = authResult?.user {
                    self.currentUser = User(
                        id: firebaseUser.uid,
                        email: firebaseUser.email ?? "",
                        displayName: firebaseUser.displayName ?? "User"
                    )
                    self.isAuthenticated = true
                }
                self.isLoading = false
            }
        }
    }

    func signUpWithEmail(email: String, password: String, displayName: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            Task { @MainActor [weak self] in
                guard let self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }

                // Update display name
                if let firebaseUser = authResult?.user {
                    let changeRequest = firebaseUser.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating display name: \(error)")
                        }
                    }

                    self.currentUser = User(
                        id: firebaseUser.uid,
                        email: firebaseUser.email ?? "",
                        displayName: displayName
                    )
                    self.isAuthenticated = true
                }
                self.isLoading = false
            }
        }
    }

    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            Task { @MainActor [weak self] in
                guard let self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Sign Out

    func signOut() {
        isLoading = true

        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.currentUser = nil
            self.isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Private Helper Methods

    private func checkAuthenticationState() {
        if let firebaseUser = Auth.auth().currentUser {
            self.currentUser = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? "",
                displayName: firebaseUser.displayName ?? "User"
            )
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }

    // MARK: - Apple Sign-In Security Helpers

    /// Generates a cryptographically secure random nonce for Apple Sign-In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    /// Hashes the nonce using SHA256 for secure Apple Sign-In
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthViewModel: ASAuthorizationControllerDelegate {
    /// Called when Apple Sign-In completes successfully
    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task { @MainActor in
            handleAppleSignInCompletion(authorization: authorization)
        }
    }

    /// Called when Apple Sign-In fails or user cancels
    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Task { @MainActor in
            handleAppleSignInError(error: error)
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
    /// Provides the window for presenting Apple Sign-In UI
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}
