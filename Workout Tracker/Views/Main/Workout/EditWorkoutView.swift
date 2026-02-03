import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let workout: WorkoutSession

    @State private var workoutDate: Date
    @State private var workoutNotes: String
    @State private var exercises: [ExerciseData] = []

    init(workout: WorkoutSession) {
        self.workout = workout
        _workoutDate = State(initialValue: workout.date)
        _workoutNotes = State(initialValue: workout.notes)

        // Convert SwiftData exercises to ExerciseData
        var exercisesData: [ExerciseData] = []
        if let workoutExercises = workout.exercises {
            for exercise in workoutExercises {
                var sets: [SetData] = []
                if let exerciseSets = exercise.sets {
                    sets = exerciseSets.sorted { $0.setNumber < $1.setNumber }.map { set in
                        SetData(
                            setType: set.setTypeEnum,
                            weight: set.weight,
                            reps: set.reps,
                            level: set.level,
                            duration: set.duration
                        )
                    }
                }
                exercisesData.append(ExerciseData(name: exercise.exerciseName, notes: exercise.notes, sets: sets))
            }
        }
        _exercises = State(initialValue: exercisesData)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

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
                        title: "Save Changes",
                        action: saveWorkout,
                        isEnabled: !exercises.isEmpty && exercises.allSatisfy { !$0.sets.isEmpty }
                    )
                    .padding(.top, AppSpacing.medium)
                }
                    .padding()
                }
            }
            .navigationTitle("Edit Workout")
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

    private func deleteExercise(at index: Int) {
        exercises.remove(at: index)
    }

    private func saveWorkout() {
        // Update workout date and notes
        workout.date = workoutDate
        workout.notes = workoutNotes

        // Delete all existing exercises and sets
        if let existingExercises = workout.exercises {
            for exercise in existingExercises {
                if let sets = exercise.sets {
                    for set in sets {
                        modelContext.delete(set)
                    }
                }
                modelContext.delete(exercise)
            }
        }

        // Add updated exercises
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

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving workout: \(error)")
        }
    }
}
