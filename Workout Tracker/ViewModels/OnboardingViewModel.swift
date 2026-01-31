import SwiftUI
import SwiftData

@Observable
class OnboardingViewModel {
    var name: String = ""
    var age: String = ""
    var height: String = ""
    var weight: String = ""
    var weightUnit: WeightUnit = .kg
    var heightUnit: HeightUnit = .cm

    var currentStep: Int = 0

    func nextStep() {
        currentStep += 1
    }

    func previousStep() {
        currentStep -= 1
    }

    func saveUserProfile(modelContext: ModelContext) {
        let ageInt = Int(age) ?? 0
        let heightDouble = Double(height) ?? 0
        let weightDouble = Double(weight) ?? 0

        // Check if user already exists
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let existingUsers = try? modelContext.fetch(fetchDescriptor)

        if let existingUser = existingUsers?.first {
            // Update existing user
            existingUser.name = name
            existingUser.age = ageInt
            existingUser.height = heightDouble
            existingUser.weight = weightDouble
            existingUser.weightUnit = weightUnit.rawValue
            existingUser.heightUnit = heightUnit.rawValue
            existingUser.hasCompletedOnboarding = true
        } else {
            // Create new user
            let userProfile = UserProfile(
                name: name,
                age: ageInt,
                height: heightDouble,
                weight: weightDouble,
                weightUnit: weightUnit.rawValue,
                heightUnit: heightUnit.rawValue,
                hasCompletedOnboarding: true
            )
            modelContext.insert(userProfile)
        }

        do {
            try modelContext.save()
        } catch {
            print("Error saving user profile: \(error)")
        }
    }

    var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isAgeValid: Bool {
        guard let ageValue = Int(age) else { return false }
        return ageValue > 0 && ageValue < 150
    }

    var isHeightValid: Bool {
        guard let heightValue = Double(height) else { return false }
        if heightUnit == .cm {
            return heightValue > 0 && heightValue < 300
        } else {
            return heightValue > 0 && heightValue < 120
        }
    }

    var isWeightValid: Bool {
        guard let weightValue = Double(weight) else { return false }
        if weightUnit == .kg {
            return weightValue > 0 && weightValue < 500
        } else {
            return weightValue > 0 && weightValue < 1100
        }
    }
}
