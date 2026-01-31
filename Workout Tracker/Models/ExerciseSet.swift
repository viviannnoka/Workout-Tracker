import Foundation
import SwiftData

enum SetType: String, Codable {
    case weightReps = "weightReps"
    case levelDuration = "levelDuration"
}

@Model
final class ExerciseSet {
    var setNumber: Int
    var setType: String // SetType enum stored as string

    // For weight/reps sets
    var weight: Double?
    var reps: Int?

    // For level/duration sets
    var level: Int?
    var duration: Double? // in seconds

    var exercise: ExerciseEntry?

    init(setNumber: Int, setType: SetType, weight: Double? = nil, reps: Int? = nil, level: Int? = nil, duration: Double? = nil) {
        self.setNumber = setNumber
        self.setType = setType.rawValue
        self.weight = weight
        self.reps = reps
        self.level = level
        self.duration = duration
    }

    var setTypeEnum: SetType {
        SetType(rawValue: setType) ?? .weightReps
    }
}
