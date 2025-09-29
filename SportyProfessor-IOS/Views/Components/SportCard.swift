import SwiftUI

struct SportCard: View {
    let sport: Sport
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Constants.Spacing.md) {
                // Sport emoji and status
                HStack {
                    Text(sport.emoji)
                        .font(.system(size: 40))

                    Spacer()

                    if sport.isPremium {
                        premiumBadge
                    }

                    if !sport.isAvailable {
                        unavailableBadge
                    }
                }

                // Sport info
                VStack(alignment: .leading, spacing: Constants.Spacing.xs) {
                    Text(sport.name)
                        .font(Constants.Fonts.headline)
                        .foregroundColor(Constants.Colors.textPrimary)
                        .multilineTextAlignment(.leading)

                    Text("\(sport.totalLessons) lessons")
                        .font(Constants.Fonts.caption)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(Constants.Spacing.md)
            .frame(height: 140)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!sport.isAvailable)
    }

    private var premiumBadge: some View {
        Text("PRO")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Constants.Colors.secondaryOrange)
            .cornerRadius(4)
    }

    private var unavailableBadge: some View {
        Text("SOON")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.gray)
            .cornerRadius(4)
    }

}

#Preview {
    HStack {
        SportCard(
            sport: Sport(
                id: "basketball",
                name: "Basketball",
                emoji: "🏀",
                description: "Learn basketball fundamentals",
                totalModules: 4,
                totalLessons: 24,
                difficulty: .beginner,
                category: .teamSport
            )
        ) {}

        SportCard(
            sport: Sport(
                id: "soccer",
                name: "Soccer",
                emoji: "⚽",
                description: "Master the beautiful game",
                totalModules: 5,
                totalLessons: 30,
                difficulty: .intermediate,
                category: .teamSport,
                isPremium: true,
                isAvailable: false
            )
        ) {}
    }
    .padding()
}
