import Foundation
import SwiftData

@Model
final class ExerciseSet {
    var weight: Double // in kilograms
    var reps: Int
    var setNumber: Int

    var exercise: ExerciseEntry?

    init(weight: Double, reps: Int, setNumber: Int) {
        self.weight = weight
        self.reps = reps
        self.setNumber = setNumber
    }
}
