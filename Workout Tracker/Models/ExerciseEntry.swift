import Foundation
import SwiftData

@Model
final class ExerciseEntry {
    var exerciseName: String
    var createdAt: Date

    var workoutSession: WorkoutSession?

    @Relationship(deleteRule: .cascade, inverse: \ExerciseSet.exercise)
    var sets: [ExerciseSet]?

    init(exerciseName: String, createdAt: Date = Date()) {
        self.exerciseName = exerciseName
        self.createdAt = createdAt
        self.sets = []
    }
}
