import Foundation
import Combine

@MainActor
class AppState: ObservableObject {
    // MARK: - Published Properties
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var selectedSport: Sport?
    @Published var userProgress: [String: Progress] = [:]

    // MARK: - ViewModels
    @Published var authViewModel = AuthViewModel()
    @Published var sportViewModel = SportViewModel()
    @Published var progressViewModel = ProgressViewModel()

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        // Bind auth state
        authViewModel.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)

        authViewModel.$isAuthenticated
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)

        // Bind sport selection
        sportViewModel.$selectedSport
            .assign(to: \.selectedSport, on: self)
            .store(in: &cancellables)

        // Bind progress updates
        progressViewModel.$userProgress
            .assign(to: \.userProgress, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Convenience Methods
    func getCurrentProgress(for sportId: String) -> Progress? {
        guard let userId = currentUser?.id else { return nil }
        return progressViewModel.getProgress(for: sportId, userId: userId)
    }

    func updateProgress(for sportId: String, lessonId: String, xp: Int) {
        guard let userId = currentUser?.id else { return }
        progressViewModel.completeLesson(
            lessonId: lessonId,
            sportId: sportId,
            userId: userId,
            xpReward: xp
        )
    }

    func addQuizResult(_ result: QuizResult, for sportId: String) {
        guard let userId = currentUser?.id else { return }
        progressViewModel.addQuizResult(result, sportId: sportId, userId: userId)
    }
}
