import Foundation
import SwiftData

enum WeightUnit: String, Codable {
    case kg = "kg"
    case lbs = "lbs"
}

enum HeightUnit: String, Codable {
    case cm = "cm"
    case inches = "in"
}

@Model
final class UserProfile {
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var weightUnit: String
    var heightUnit: String
    var hasCompletedOnboarding: Bool

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSession.user)
    var workouts: [WorkoutSession]?

    init(name: String = "", age: Int = 0, height: Double = 0, weight: Double = 0, weightUnit: String = WeightUnit.kg.rawValue, heightUnit: String = HeightUnit.cm.rawValue, hasCompletedOnboarding: Bool = false) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.weightUnit = weightUnit
        self.heightUnit = heightUnit
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.workouts = []
    }

    var weightUnitEnum: WeightUnit {
        WeightUnit(rawValue: weightUnit) ?? .kg
    }

    var heightUnitEnum: HeightUnit {
        HeightUnit(rawValue: heightUnit) ?? .cm
    }
}
