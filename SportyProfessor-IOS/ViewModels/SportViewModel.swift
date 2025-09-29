import Foundation
import Combine

@MainActor
class SportViewModel: ObservableObject {
    @Published var sports: [Sport] = []
    @Published var selectedSport: Sport?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadSports()
    }

    func loadSports() {
        isLoading = true
        errorMessage = nil

        // TODO: Load sports from Firebase
        // For now, create sample data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sports = self.createSampleSports()
            self.isLoading = false
        }
    }

    func selectSport(_ sport: Sport) {
        selectedSport = sport
    }

    private func createSampleSports() -> [Sport] {
        return [
            Sport(
                id: "basketball",
                name: "Basketball",
                emoji: "🏀",
                description: "Learn the fundamentals of basketball from court basics to advanced strategies",
                totalModules: 4,
                totalLessons: 24,
                difficulty: .beginner,
                category: .teamSport,
                isPremium: false,
                isAvailable: true
            ),
            Sport(
                id: "soccer",
                name: "Soccer",
                emoji: "⚽",
                description: "Master the beautiful game with comprehensive football education",
                totalModules: 5,
                totalLessons: 30,
                difficulty: .beginner,
                category: .teamSport,
                isPremium: true,
                isAvailable: false
            )
        ]
    }
}
