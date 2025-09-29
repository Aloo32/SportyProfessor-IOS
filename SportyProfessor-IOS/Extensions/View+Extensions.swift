import SwiftUI

extension View {
    // MARK: - Styling
    func cardStyle() -> some View {
        self
            .background(Constants.Colors.backgroundSecondary)
            .cornerRadius(Constants.CornerRadius.medium)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .padding(.horizontal, Constants.Spacing.lg)
            .padding(.vertical, Constants.Spacing.md)
            .background(Constants.Colors.primaryBlue)
            .cornerRadius(Constants.CornerRadius.medium)
    }

    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(Constants.Colors.primaryBlue)
            .padding(.horizontal, Constants.Spacing.lg)
            .padding(.vertical, Constants.Spacing.md)
            .background(Constants.Colors.backgroundSecondary)
            .cornerRadius(Constants.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                    .stroke(Constants.Colors.primaryBlue, lineWidth: 1)
            )
    }

    // MARK: - Conditional Modifiers
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    // MARK: - Loading State
    func loading(_ isLoading: Bool) -> some View {
        self
            .disabled(isLoading)
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            )
    }

    // MARK: - Navigation
    func hideNavigationBar() -> some View {
        self.navigationBarHidden(true)
    }

    // MARK: - Haptic Feedback
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impact = UIImpactFeedbackGenerator(style: style)
            impact.impactOccurred()
        }
    }
}

// MARK: - Color Extensions
extension Color {
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}