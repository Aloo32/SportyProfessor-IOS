import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
}

enum SportCategory: String, CaseIterable, Codable {
    case teamSport = "team_sport"
    case individualSport = "individual_sport"
    case racketSport = "racket_sport"
    case motorsport = "motorsport"

    var displayName: String {
        switch self {
        case .teamSport: return "Team Sport"
        case .individualSport: return "Individual Sport"
        case .racketSport: return "Racket Sport"
        case .motorsport: return "Motorsport"
        }
    }
}

struct Sport: Identifiable, Codable {
    let id: String
    let name: String
    let emoji: String
    let description: String
    let totalModules: Int
    let totalLessons: Int
    let difficulty: Difficulty
    let category: SportCategory
    let isPremium: Bool
    let isAvailable: Bool

    init(
        id: String,
        name: String,
        emoji: String,
        description: String,
        totalModules: Int,
        totalLessons: Int,
        difficulty: Difficulty = .beginner,
        category: SportCategory = .teamSport,
        isPremium: Bool = false,
        isAvailable: Bool = true
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.description = description
        self.totalModules = totalModules
        self.totalLessons = totalLessons
        self.difficulty = difficulty
        self.category = category
        self.isPremium = isPremium
        self.isAvailable = isAvailable
    }
}