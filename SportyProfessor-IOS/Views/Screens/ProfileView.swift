import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: Constants.Spacing.lg) {
                // User info section
                if let user = appState.currentUser {
                    VStack(spacing: Constants.Spacing.sm) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(Constants.Colors.primaryBlue)
                            .padding()

                        Text(user.displayName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(user.email)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, Constants.Spacing.xl)
                }

                Spacer()

                // Sign out button
                Button(action: {
                    appState.authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(Constants.CornerRadius.medium)
                }
                .padding(.horizontal, Constants.Spacing.xl)
                .padding(.bottom, Constants.Spacing.xl)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}