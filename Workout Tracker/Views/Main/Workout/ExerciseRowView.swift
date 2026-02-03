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
                        .foregroundColor(AppColors.danger)
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
            NavigationStack {
                EditExerciseView(exercise: $exercise)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingEditExercise = false
                            }
                            .foregroundColor(.white)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingEditExercise = false
                            }
                            .foregroundColor(.white)
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private var addSetSheet: some View {
        NavigationStack {
            AddSetView(
                onAdd: { setType, weight, reps, level, duration, count in
                    for _ in 0..<count {
                        let newSet = SetData(
                            setType: setType,
                            weight: weight,
                            reps: reps,
                            level: level,
                            duration: duration
                        )
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
    let onAdd: (SetType, Double?, Int?, Int?, Double?, Int) -> Void

    @State private var setType: SetType = .weightReps
    @State private var weight: String = ""
    @State private var reps: String = ""
    @State private var level: String = ""
    @State private var duration: String = ""
    @State private var numberOfSets: String = "1"
    @State private var useBulkEntry = false

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Picker("Set Type *", selection: $setType) {
                Text("Weight & Reps").tag(SetType.weightReps)
                Text("Level & Duration").tag(SetType.levelDuration)
            }
            .pickerStyle(.segmented)

            if setType == .weightReps {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    CustomTextField(
                        title: "Weight (kg) *",
                        placeholder: "Enter weight",
                        text: $weight,
                        keyboardType: .decimalPad
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(weight.isEmpty ? AppColors.danger.opacity(0.3) : Color.clear, lineWidth: 1)
                    )

                    CustomTextField(
                        title: "Reps *",
                        placeholder: "Enter reps",
                        text: $reps,
                        keyboardType: .numberPad
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(reps.isEmpty ? AppColors.danger.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                }
            } else {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    CustomTextField(
                        title: "Level *",
                        placeholder: "Enter level",
                        text: $level,
                        keyboardType: .numberPad
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(level.isEmpty ? AppColors.danger.opacity(0.3) : Color.clear, lineWidth: 1)
                    )

                    CustomTextField(
                        title: "Duration (seconds) *",
                        placeholder: "Enter duration",
                        text: $duration,
                        keyboardType: .decimalPad
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(duration.isEmpty ? AppColors.danger.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                }
            }

            Toggle("Apply to multiple sets", isOn: $useBulkEntry)
                .font(AppFonts.body)

            if useBulkEntry {
                CustomTextField(
                    title: "Number of Sets *",
                    placeholder: "How many sets?",
                    text: $numberOfSets,
                    keyboardType: .numberPad
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(numberOfSets.isEmpty ? AppColors.danger.opacity(0.3) : Color.clear, lineWidth: 1)
                )
            }

            Spacer()

            PrimaryButton(
                title: useBulkEntry ? "Add \(numberOfSets) Sets" : "Add Set",
                action: addSet,
                isEnabled: isValid
            )
        }
        .padding()
        .navigationTitle("Add Set")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addSet() {
        let setsCount = useBulkEntry ? (Int(numberOfSets) ?? 1) : 1

        if setType == .weightReps {
            if let weightValue = Double(weight), let repsValue = Int(reps) {
                onAdd(setType, weightValue, repsValue, nil, nil, setsCount)
            }
        } else {
            if let levelValue = Int(level), let durationValue = Double(duration) {
                onAdd(setType, nil, nil, levelValue, durationValue, setsCount)
            }
        }
    }

    private var isValid: Bool {
        if setType == .weightReps {
            guard let weightValue = Double(weight), weightValue > 0,
                  let repsValue = Int(reps), repsValue > 0 else {
                return false
            }
        } else {
            guard let levelValue = Int(level), levelValue > 0,
                  let durationValue = Double(duration), durationValue > 0 else {
                return false
            }
        }

        if useBulkEntry {
            guard let setsCount = Int(numberOfSets), setsCount > 0 && setsCount <= 20 else {
                return false
            }
        }

        return true
    }
}

struct EditExerciseView: View {
    @Binding var exercise: ExerciseData

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Exercise Name Section
            VStack(alignment: .leading, spacing: 8) {
                Text("EXERCISE NAME")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)

                TextField("e.g., Bench Press", text: $exercise.name)
                    .textFieldStyle(.roundedBorder)
                    .colorScheme(.dark)
            }

            // Exercise Notes Section
            VStack(alignment: .leading, spacing: 8) {
                Text("EXERCISE NOTES")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)

                TextEditor(text: $exercise.notes)
                    .frame(height: 120)
                    .colorScheme(.dark)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("Edit Exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
}
