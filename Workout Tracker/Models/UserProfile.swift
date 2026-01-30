import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var age: Int
    var height: Double // in centimeters
    var weight: Double // in kilograms
    var hasCompletedOnboarding: Bool

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSession.user)
    var workouts: [WorkoutSession]?

    init(name: String = "", age: Int = 0, height: Double = 0, weight: Double = 0, hasCompletedOnboarding: Bool = false) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.workouts = []
    }
}
