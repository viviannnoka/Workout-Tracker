import SwiftUI

struct ExerciseRowView: View {
    @Binding var exercise: ExerciseData
    let onDelete: () -> Void

    @State private var showingAddSet = false
    @State private var showingEditExercise = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                Text(exercise.name)
                    .font(AppFonts.title)

                Spacer()

                Button(action: { showingEditExercise = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(AppColors.primary)
                }

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text("Exercise Notes")
                    .font(AppFonts.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                TextEditor(text: $exercise.notes)
                    .frame(height: 60)
                    .padding(AppSpacing.extraSmall)
                    .background(AppColors.background)
                    .cornerRadius(8)
            }

            if exercise.sets.isEmpty {
                Text("No sets added yet")
                    .font(AppFonts.body)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: AppSpacing.small) {
                    ForEach(exercise.sets.indices, id: \.self) { index in
                        SetRowView(
                            setNumber: index + 1,
                            set: $exercise.sets[index],
                            onDelete: { deleteSet(at: index) }
                        )
                    }
                }
            }

            Button(action: { showingAddSet = true }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Set")
                }
                .font(AppFonts.body)
                .foregroundColor(AppColors.primary)
            }
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
        .sheet(isPresented: $showingAddSet) {
            addSetSheet
        }
        .sheet(isPresented: $showingEditExercise) {
            editExerciseSheet
        }
    }

    private var editExerciseSheet: some View {
        NavigationStack {
            EditExerciseView(exercise: $exercise)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingEditExercise = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showingEditExercise = false
                        }
                    }
                }
        }
    }

    private var addSetSheet: some View {
        NavigationStack {
            AddSetView(
                onAdd: { weight, reps, count in
                    for _ in 0..<count {
                        let newSet = SetData(weight: weight, reps: reps)
                        exercise.sets.append(newSet)
                    }
                    showingAddSet = false
                }
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAddSet = false
                    }
                }
            }
        }
    }

    private func deleteSet(at index: Int) {
        exercise.sets.remove(at: index)
    }
}

struct AddSetView: View {
    let onAdd: (Double, Int, Int) -> Void

    @State private var weight: String = ""
    @State private var reps: String = ""
    @State private var numberOfSets: String = "1"
    @State private var useBulkEntry = false

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            CustomTextField(
                title: "Weight (kg)",
                placeholder: "Enter weight",
                text: $weight,
                keyboardType: .decimalPad
            )

            CustomTextField(
                title: "Reps",
                placeholder: "Enter reps",
                text: $reps,
                keyboardType: .numberPad
            )

            Toggle("Apply to multiple sets", isOn: $useBulkEntry)
                .font(AppFonts.body)

            if useBulkEntry {
                CustomTextField(
                    title: "Number of Sets",
                    placeholder: "How many sets?",
                    text: $numberOfSets,
                    keyboardType: .numberPad
                )
            }

            Spacer()

            PrimaryButton(
                title: useBulkEntry ? "Add \(numberOfSets) Sets" : "Add Set",
                action: {
                    if let weightValue = Double(weight),
                       let repsValue = Int(reps),
                       let setsCount = Int(numberOfSets) {
                        onAdd(weightValue, repsValue, useBulkEntry ? setsCount : 1)
                    }
                },
                isEnabled: isValid
            )
        }
        .padding()
        .navigationTitle("Add Set")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isValid: Bool {
        guard let weightValue = Double(weight),
              let repsValue = Int(reps) else {
            return false
        }

        if useBulkEntry {
            guard let setsCount = Int(numberOfSets), setsCount > 0 && setsCount <= 20 else {
                return false
            }
        }

        return weightValue > 0 && repsValue > 0
    }
}

struct EditExerciseView: View {
    @Binding var exercise: ExerciseData

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                CustomTextField(
                    title: "Exercise Name",
                    placeholder: "e.g., Bench Press",
                    text: $exercise.name
                )

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text("Exercise Notes")
                        .font(AppFonts.headline)

                    TextEditor(text: $exercise.notes)
                        .frame(height: 100)
                        .padding(AppSpacing.small)
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Edit Exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
}
