import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var showEmailSignIn = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Constants.Colors.primaryBlue, Constants.Colors.primaryBlue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: Constants.Spacing.xl) {
                Spacer()

                // App Logo and Title
                VStack(spacing: Constants.Spacing.md) {


                    Text("SportyProfessor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Learn Sports, Level Up")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                // Sign In Buttons
                VStack(spacing: Constants.Spacing.md) {
                    // Google Sign In
                    Button(action: {
                        appState.authViewModel.signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.title2)
                            Text("Sign in with Google")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(Constants.CornerRadius.medium)
                    }

                    // Apple Sign In
                    Button(action: {
                        appState.authViewModel.signInWithApple()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.title2)
                            Text("Sign in with Apple")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.CornerRadius.medium)
                    }

                    // Email Sign In
                    Button(action: {
                        showEmailSignIn = true
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .font(.title2)
                            Text("Sign in with Email")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .cornerRadius(Constants.CornerRadius.medium)
                    }
                }
                .padding(.horizontal, Constants.Spacing.xl)

                Spacer()
            }
        }
        .sheet(isPresented: $showEmailSignIn) {
            EmailAuthView()
                .environmentObject(appState)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
