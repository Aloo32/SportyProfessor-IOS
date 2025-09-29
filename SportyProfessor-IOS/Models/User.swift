import Foundation

enum SubscriptionTier: String, CaseIterable, Codable {
    case free = "free"
    case premium = "premium"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .premium: return "Premium"
        }
    }
}

struct UserPreferences: Codable {
    var dailyGoalMinutes: Int = 15
    var notificationsEnabled: Bool = true
    var reminderTime: String = "19:00"
    var preferredSports: [String] = []

    init() {}
}

struct User: Identifiable, Codable {
    let id: String
    var email: String
    var displayName: String
    var photoURL: String?
    let createdAt: Date
    var lastActive: Date
    var subscription: SubscriptionTier
    var preferences: UserPreferences

    init(id: String, email: String, displayName: String, photoURL: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.createdAt = Date()
        self.lastActive = Date()
        self.subscription = .free
        self.preferences = UserPreferences()
    }
}