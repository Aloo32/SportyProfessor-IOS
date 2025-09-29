import Foundation

enum LessonSectionType: String, Codable {
    case text = "text"
    case image = "image"
    case video = "video"
    case diagram = "diagram"
    case quiz = "quiz"
}

struct LessonSection: Identifiable, Codable {
    let id: String
    let type: LessonSectionType
    let title: String?
    let content: String
    let imageURL: String?
    let videoURL: String?
    let order: Int

    init(
        id: String = UUID().uuidString,
        type: LessonSectionType,
        title: String? = nil,
        content: String,
        imageURL: String? = nil,
        videoURL: String? = nil,
        order: Int
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.content = content
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.order = order
    }
}

struct Lesson: Identifiable, Codable {
    let id: String
    let sportId: String
    let moduleId: String
    let order: Int
    let title: String
    let description: String
    let content: [LessonSection]
    let estimatedMinutes: Int
    let xpReward: Int
    let prerequisites: [String]
    let isLocked: Bool

    init(
        id: String,
        sportId: String,
        moduleId: String,
        order: Int,
        title: String,
        description: String,
        content: [LessonSection] = [],
        estimatedMinutes: Int = 5,
        xpReward: Int = 10,
        prerequisites: [String] = [],
        isLocked: Bool = false
    ) {
        self.id = id
        self.sportId = sportId
        self.moduleId = moduleId
        self.order = order
        self.title = title
        self.description = description
        self.content = content
        self.estimatedMinutes = estimatedMinutes
        self.xpReward = xpReward
        self.prerequisites = prerequisites
        self.isLocked = isLocked
    }
}

struct Module: Identifiable, Codable {
    let id: String
    let sportId: String
    let order: Int
    let title: String
    let description: String
    let lessons: [Lesson]
    let totalXP: Int

    var completedLessons: Int {
        lessons.filter { !$0.isLocked }.count
    }

    var progressPercentage: Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(completedLessons) / Double(lessons.count)
    }
}