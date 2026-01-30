import SwiftUI
import SwiftData

@Observable
class OnboardingViewModel {
    var name: String = ""
    var age: String = ""
    var height: String = ""
    var weight: String = ""

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

        let userProfile = UserProfile(
            name: name,
            age: ageInt,
            height: heightDouble,
            weight: weightDouble,
            hasCompletedOnboarding: true
        )

        modelContext.insert(userProfile)
        try? modelContext.save()
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
        return heightValue > 0 && heightValue < 300
    }

    var isWeightValid: Bool {
        guard let weightValue = Double(weight) else { return false }
        return weightValue > 0 && weightValue < 500
    }
}
