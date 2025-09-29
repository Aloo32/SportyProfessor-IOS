import Foundation

struct QuizResult: Identifiable, Codable {
    let id: String
    let lessonId: String
    let score: Int
    let totalQuestions: Int
    let completedAt: Date
    let timeSpent: TimeInterval

    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(score) / Double(totalQuestions) * 100
    }

    var isPassing: Bool {
        percentage >= 70.0
    }

    init(
        id: String = UUID().uuidString,
        lessonId: String,
        score: Int,
        totalQuestions: Int,
        completedAt: Date = Date(),
        timeSpent: TimeInterval = 0
    ) {
        self.id = id
        self.lessonId = lessonId
        self.score = score
        self.totalQuestions = totalQuestions
        self.completedAt = completedAt
        self.timeSpent = timeSpent
    }
}

struct Progress: Identifiable, Codable {
    let id: String
    let userId: String
    let sportId: String
    var completedLessons: [String]
    var currentModule: Int
    var totalXP: Int
    var level: Int
    var streak: Int
    var lastActivityDate: Date
    var quizScores: [QuizResult]

    var currentLevel: Int {
        // XP to level formula: level = floor(totalXP / 100) + 1
        return (totalXP / 100) + 1
    }

    var xpForNextLevel: Int {
        let nextLevel = currentLevel + 1
        return (nextLevel - 1) * 100
    }

    var xpProgressInCurrentLevel: Int {
        return totalXP % 100
    }

    var progressPercentageInLevel: Double {
        return Double(xpProgressInCurrentLevel) / 100.0
    }

    var averageQuizScore: Double {
        guard !quizScores.isEmpty else { return 0 }
        let totalPercentage = quizScores.reduce(0) { $0 + $1.percentage }
        return totalPercentage / Double(quizScores.count)
    }

    init(
        id: String = UUID().uuidString,
        userId: String,
        sportId: String,
        completedLessons: [String] = [],
        currentModule: Int = 0,
        totalXP: Int = 0,
        level: Int = 1,
        streak: Int = 0,
        lastActivityDate: Date = Date(),
        quizScores: [QuizResult] = []
    ) {
        self.id = id
        self.userId = userId
        self.sportId = sportId
        self.completedLessons = completedLessons
        self.currentModule = currentModule
        self.totalXP = totalXP
        self.level = level
        self.streak = streak
        self.lastActivityDate = lastActivityDate
        self.quizScores = quizScores
    }

    mutating func completeLesson(_ lessonId: String, xp: Int) {
        if !completedLessons.contains(lessonId) {
            completedLessons.append(lessonId)
            totalXP += xp
            level = currentLevel
            updateStreak()
        }
    }

    mutating func addQuizResult(_ result: QuizResult) {
        quizScores.append(result)
    }

    private mutating func updateStreak() {
        let calendar = Calendar.current
        let today = Date()

        if calendar.isDateInToday(lastActivityDate) {
            // Same day, don't change streak
            return
        } else if calendar.isDateInYesterday(lastActivityDate) {
            // Yesterday, increment streak
            streak += 1
        } else {
            // More than one day gap, reset streak
            streak = 1
        }

        lastActivityDate = today
    }
}