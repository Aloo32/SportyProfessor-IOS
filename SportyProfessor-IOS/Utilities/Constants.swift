import Foundation
import SwiftUI

struct Constants {
    // MARK: - Design System
    struct Colors {
        static let primaryBlue = Color(red: 0, green: 0.48, blue: 1) // #007AFF
        static let secondaryOrange = Color(red: 1, green: 0.42, blue: 0.21) // #FF6B35
        static let successGreen = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
        static let errorRed = Color(red: 1, green: 0.23, blue: 0.19) // #FF3B30

        // Background colors
        static let backgroundPrimary = Color(.systemBackground)
        static let backgroundSecondary = Color(.secondarySystemBackground)
        static let backgroundTertiary = Color(.tertiarySystemBackground)

        // Text colors
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
    }

    struct Fonts {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let headline = Font.headline.weight(.medium)
        static let body = Font.body
        static let caption = Font.caption
    }

    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    // MARK: - App Configuration
    struct App {
        static let name = "SportyProfessor"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }

    // MARK: - XP and Gamification
    struct Gamification {
        static let baseXPPerLesson = 10
        static let bonusXPPerQuiz = 5
        static let streakBonusXP = 2
        static let xpPerLevel = 100

        // Level names
        static let levelNames = [
            "Rookie",
            "Amateur",
            "Enthusiast",
            "Competitor",
            "Pro",
            "Expert",
            "Master",
            "Legend"
        ]

        static func levelName(for level: Int) -> String {
            let index = min(level - 1, levelNames.count - 1)
            return levelNames[max(0, index)]
        }
    }

    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(
            response: 0.6,
            dampingFraction: 0.8,
            blendDuration: 0
        )
    }
}