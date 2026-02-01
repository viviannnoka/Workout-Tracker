import SwiftUI
import SwiftData

struct NewWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [UserProfile]

    @State private var workoutDate = Date()
    @State private var currentExerciseName: String = ""
    @State private var exercises: [ExerciseData] = []
    @State private var workoutNotes: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        DatePicker("Date", selection: $workoutDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)

                        DatePicker("Time", selection: $workoutDate, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)
                    }
                    .padding()
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Exercise Name *")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)

                        HStack {
                            TextField("e.g., Bench Press", text: $currentExerciseName)
                                .foregroundColor(AppColors.textPrimary)
                                .padding()
                                .background(AppColors.secondaryBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.border, lineWidth: 1)
                                )

                            Button(action: addExercise) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(AppColors.primary)
                                    .font(.title2)
                            }
                            .disabled(currentExerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }

                    if !exercises.isEmpty {
                        ForEach(exercises.indices, id: \.self) { index in
                            ExerciseRowView(
                                exercise: $exercises[index],
                                onDelete: { deleteExercise(at: index) }
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Workout Notes")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)

                        TextEditor(text: $workoutNotes)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(height: 100)
                            .padding(AppSpacing.small)
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.border, lineWidth: 1)
                            )
                    }

                    PrimaryButton(
                        title: "Save Workout",
                        action: saveWorkout,
                        isEnabled: !exercises.isEmpty && exercises.allSatisfy { !$0.sets.isEmpty }
                    )
                    .padding(.top, AppSpacing.medium)
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }

    private func addExercise() {
        let exercise = ExerciseData(name: currentExerciseName.trimmingCharacters(in: .whitespaces))
        exercises.append(exercise)
        currentExerciseName = ""
    }

    private func deleteExercise(at index: Int) {
        exercises.remove(at: index)
    }

    private func saveWorkout() {
        guard let user = users.first else { return }

        let workout = WorkoutSession(date: workoutDate, notes: workoutNotes)
        workout.user = user

        for exerciseData in exercises {
            let exercise = ExerciseEntry(exerciseName: exerciseData.name, notes: exerciseData.notes)
            exercise.workoutSession = workout

            for (index, setData) in exerciseData.sets.enumerated() {
                let set = ExerciseSet(
                    setNumber: index + 1,
                    setType: setData.setType,
                    weight: setData.weight,
                    reps: setData.reps,
                    level: setData.level,
                    duration: setData.duration
                )
                set.exercise = exercise
                modelContext.insert(set)
            }

            modelContext.insert(exercise)
        }

        modelContext.insert(workout)
        try? modelContext.save()

        dismiss()
    }
}

struct ExerciseData: Identifiable {
    let id = UUID()
    var name: String
    var notes: String = ""
    var sets: [SetData] = []
}

struct SetData: Identifiable {
    let id = UUID()
    var setType: SetType

    // For weight/reps sets
    var weight: Double?
    var reps: Int?

    // For level/duration sets
    var level: Int?
    var duration: Double? // in seconds

    init(setType: SetType, weight: Double? = nil, reps: Int? = nil, level: Int? = nil, duration: Double? = nil) {
        self.setType = setType
        self.weight = weight
        self.reps = reps
        self.level = level
        self.duration = duration
    }
}
