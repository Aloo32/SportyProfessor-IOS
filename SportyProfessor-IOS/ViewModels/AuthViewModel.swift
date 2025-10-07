import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthenticationState()
    }

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
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.errorMessage = "Failed to get user information"
                self?.isLoading = false
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                    return
                }

                if let firebaseUser = authResult?.user {
                    self?.currentUser = User(
                        id: firebaseUser.uid,
                        email: firebaseUser.email ?? "",
                        displayName: firebaseUser.displayName ?? "User"
                    )
                    self?.isAuthenticated = true
                }
                self?.isLoading = false
            }
        }
    }

    func signInWithApple() {
        isLoading = true
        errorMessage = nil

        // TODO: Implement Apple Sign-In
        // This will be implemented when we add Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            // Placeholder for successful sign-in
        }
    }

    func signInWithEmail(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
                return
            }

            if let firebaseUser = authResult?.user {
                self?.currentUser = User(
                    id: firebaseUser.uid,
                    email: firebaseUser.email ?? "",
                    displayName: firebaseUser.displayName ?? "User"
                )
                self?.isAuthenticated = true
            }
            self?.isLoading = false
        }
    }

    func signUpWithEmail(email: String, password: String, displayName: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
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

                self?.currentUser = User(
                    id: firebaseUser.uid,
                    email: firebaseUser.email ?? "",
                    displayName: displayName
                )
                self?.isAuthenticated = true
            }
            self?.isLoading = false
        }
    }

    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }

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

    private func createUser(from authResult: Any) -> User {
        // TODO: Create user from Firebase auth result
        // Placeholder implementation
        return User(
            id: UUID().uuidString,
            email: "user@example.com",
            displayName: "Test User"
        )
    }
}