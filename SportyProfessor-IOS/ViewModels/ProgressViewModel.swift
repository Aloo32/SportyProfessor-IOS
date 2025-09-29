import Foundation
import Combine

@MainActor
class ProgressViewModel: ObservableObject {
    @Published var userProgress: [String: Progress] = [:]
    @Published var currentProgress: Progress?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Will load progress when user authenticates
    }

    func loadProgress(for userId: String) {
        isLoading = true
        errorMessage = nil

        // TODO: Load progress from Firebase
        self.isLoading = false
    }

    func getProgress(for sportId: String, userId: String) -> Progress? {
        let key = "\(userId)_\(sportId)"
        return userProgress[key]
    }

    func updateProgress(_ progress: Progress) {
        let key = "\(progress.userId)_\(progress.sportId)"
        userProgress[key] = progress

        // TODO: Save to Firebase
    }

    func completeLesson(
        lessonId: String,
        sportId: String,
        userId: String,
        xpReward: Int
    ) {
        let key = "\(userId)_\(sportId)"

        if var progress = userProgress[key] {
            progress.completeLesson(lessonId, xp: xpReward)
            userProgress[key] = progress

            // TODO: Save to Firebase
        } else {
            // Create new progress
            var newProgress = Progress(userId: userId, sportId: sportId)
            newProgress.completeLesson(lessonId, xp: xpReward)
            userProgress[key] = newProgress

            // TODO: Save to Firebase
        }
    }

    func addQuizResult(
        _ result: QuizResult,
        sportId: String,
        userId: String
    ) {
        let key = "\(userId)_\(sportId)"

        if var progress = userProgress[key] {
            progress.addQuizResult(result)
            userProgress[key] = progress

            // TODO: Save to Firebase
        }
    }

}