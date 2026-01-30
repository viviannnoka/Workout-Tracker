import SwiftUI

struct ExerciseRowView: View {
    @Binding var exercise: ExerciseData
    let onDelete: () -> Void

    @State private var showingAddSet = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                Text(exercise.name)
                    .font(AppFonts.title)

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
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
    }

    private var addSetSheet: some View {
        NavigationStack {
            AddSetView(onAdd: { weight, reps in
                let newSet = SetData(weight: weight, reps: reps)
                exercise.sets.append(newSet)
                showingAddSet = false
            })
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
    @State private var weight: String = ""
    @State private var reps: String = ""
    let onAdd: (Double, Int) -> Void

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

            Spacer()

            PrimaryButton(
                title: "Add Set",
                action: {
                    if let weightValue = Double(weight), let repsValue = Int(reps) {
                        onAdd(weightValue, repsValue)
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
        guard let weightValue = Double(weight), let repsValue = Int(reps) else {
            return false
        }
        return weightValue > 0 && repsValue > 0
    }
}
