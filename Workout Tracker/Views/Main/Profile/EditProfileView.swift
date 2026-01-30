import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let user: UserProfile

    @State private var name: String
    @State private var age: String
    @State private var height: String
    @State private var weight: String

    init(user: UserProfile) {
        self.user = user
        _name = State(initialValue: user.name)
        _age = State(initialValue: String(user.age))
        _height = State(initialValue: String(format: "%.1f", user.height))
        _weight = State(initialValue: String(format: "%.1f", user.weight))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    CustomTextField(
                        title: "Name",
                        placeholder: "Enter your name",
                        text: $name
                    )

                    CustomTextField(
                        title: "Age",
                        placeholder: "Enter your age",
                        text: $age,
                        keyboardType: .numberPad
                    )

                    CustomTextField(
                        title: "Height (cm)",
                        placeholder: "Enter your height",
                        text: $height,
                        keyboardType: .decimalPad
                    )

                    CustomTextField(
                        title: "Weight (kg)",
                        placeholder: "Enter your weight",
                        text: $weight,
                        keyboardType: .decimalPad
                    )

                    Spacer()

                    PrimaryButton(
                        title: "Save Changes",
                        action: saveChanges,
                        isEnabled: isValid
                    )
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var isValid: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              let ageValue = Int(age), ageValue > 0 && ageValue < 150,
              let heightValue = Double(height), heightValue > 0 && heightValue < 300,
              let weightValue = Double(weight), weightValue > 0 && weightValue < 500 else {
            return false
        }
        return true
    }

    private func saveChanges() {
        user.name = name
        user.age = Int(age) ?? user.age
        user.height = Double(height) ?? user.height
        user.weight = Double(weight) ?? user.weight

        try? modelContext.save()
        dismiss()
    }
}
