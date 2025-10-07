import SwiftUI

struct EmailAuthView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: Constants.Spacing.lg) {
                // Mode Toggle
                Picker("Mode", selection: $isSignUp) {
                    Text("Sign In").tag(false)
                    Text("Sign Up").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top)

                // Form Fields
                VStack(spacing: Constants.Spacing.md) {
                    // Name field (Sign Up only)
                    if isSignUp {
                        TextField("Full Name", text: $displayName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                    }

                    // Email field
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()

                    // Password field
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Confirm Password (Sign Up only)
                    if isSignUp {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(.horizontal)

                // Submit Button
                Button(action: handleSubmit) {
                    if appState.authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(isSignUp ? "Create Account" : "Sign In")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Constants.Colors.primaryBlue)
                .foregroundColor(.white)
                .cornerRadius(Constants.CornerRadius.medium)
                .disabled(appState.authViewModel.isLoading || !isFormValid)
                .padding(.horizontal)

                if !isSignUp {
                    // Forgot Password
                    Button(action: handleForgotPassword) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(Constants.Colors.primaryBlue)
                    }
                    .padding(.top, Constants.Spacing.sm)
                }

                Spacer()
            }
            .navigationTitle(isSignUp ? "Create Account" : "Sign In")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: appState.authViewModel.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated {
                    dismiss()
                }
            }
            .onChange(of: appState.authViewModel.errorMessage) { _, errorMessage in
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    alertMessage = errorMessage
                    showingAlert = true
                    appState.authViewModel.errorMessage = nil
                }
            }
        }
    }

    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty &&
                   !password.isEmpty &&
                   !confirmPassword.isEmpty &&
                   !displayName.isEmpty &&
                   password == confirmPassword &&
                   password.count >= 6 &&
                   email.isValidEmail
        } else {
            return !email.isEmpty && !password.isEmpty && email.isValidEmail
        }
    }

    private func handleSubmit() {
        guard isFormValid else { return }

        if isSignUp {
            appState.authViewModel.signUpWithEmail(
                email: email,
                password: password,
                displayName: displayName
            )
        } else {
            appState.authViewModel.signInWithEmail(
                email: email,
                password: password
            )
        }
    }

    private func handleForgotPassword() {
        guard email.isValidEmail else {
            alertMessage = "Please enter a valid email address"
            showingAlert = true
            return
        }

        appState.authViewModel.resetPassword(email: email)
        alertMessage = "Password reset email sent to \(email)"
        showingAlert = true
    }
}

#Preview {
    EmailAuthView()
        .environmentObject(AppState())
}