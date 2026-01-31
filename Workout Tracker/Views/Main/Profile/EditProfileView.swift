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
    @State private var heightUnit: HeightUnit
    @State private var weightUnit: WeightUnit

    init(user: UserProfile) {
        self.user = user
        _name = State(initialValue: user.name)
        _age = State(initialValue: String(user.age))
        _height = State(initialValue: String(format: "%.1f", user.height))
        _weight = State(initialValue: String(format: "%.1f", user.weight))
        _heightUnit = State(initialValue: user.heightUnitEnum)
        _weightUnit = State(initialValue: user.weightUnitEnum)
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

                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Height")
                            .font(AppFonts.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: AppSpacing.medium) {
                            TextField("Enter height", text: $height)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: .infinity)

                            Picker("Unit", selection: $heightUnit) {
                                Text("cm").tag(HeightUnit.cm)
                                Text("in").tag(HeightUnit.inches)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                        }
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Weight")
                            .font(AppFonts.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: AppSpacing.medium) {
                            TextField("Enter weight", text: $weight)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: .infinity)

                            Picker("Unit", selection: $weightUnit) {
                                Text("kg").tag(WeightUnit.kg)
                                Text("lbs").tag(WeightUnit.lbs)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                        }
                    }

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
              let heightValue = Double(height), heightValue > 0,
              let weightValue = Double(weight), weightValue > 0 else {
            return false
        }

        if heightUnit == .cm {
            guard heightValue < 300 else { return false }
        } else {
            guard heightValue < 120 else { return false }
        }

        if weightUnit == .kg {
            guard weightValue < 500 else { return false }
        } else {
            guard weightValue < 1100 else { return false }
        }

        return true
    }

    private func saveChanges() {
        user.name = name
        user.age = Int(age) ?? user.age
        user.height = Double(height) ?? user.height
        user.weight = Double(weight) ?? user.weight
        user.heightUnit = heightUnit.rawValue
        user.weightUnit = weightUnit.rawValue

        try? modelContext.save()
        dismiss()
    }
}
