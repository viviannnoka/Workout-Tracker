import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var date: Date
    var notes: String

    var user: UserProfile?

    @Relationship(deleteRule: .cascade, inverse: \ExerciseEntry.workoutSession)
    var exercises: [ExerciseEntry]?

    init(date: Date = Date(), notes: String = "") {
        self.date = date
        self.notes = notes
        self.exercises = []
    }
}
