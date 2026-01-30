import SwiftUI
import SwiftData

struct NewWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserProfile]

    @State private var exercises: [ExerciseData] = []
    @State private var workoutNotes: String = ""
    @State private var showingAddExercise = false
    @State private var newExerciseName: String = ""
    @State private var navigateToHistory = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    if exercises.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(exercises.indices, id: \.self) { index in
                            ExerciseRowView(
                                exercise: $exercises[index],
                                onDelete: { deleteExercise(at: index) }
                            )
                        }
                    }

                    Button(action: { showingAddExercise = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Exercise")
                        }
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Workout Notes")
                            .font(AppFonts.headline)

                        TextEditor(text: $workoutNotes)
                            .frame(height: 100)
                            .padding(AppSpacing.small)
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(exercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                addExerciseSheet
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.secondary)

            Text("No exercises yet")
                .font(AppFonts.headline)
                .foregroundColor(.secondary)

            Text("Tap the button below to add your first exercise")
                .font(AppFonts.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.extraLarge)
    }

    private var addExerciseSheet: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.large) {
                CustomTextField(
                    title: "Exercise Name",
                    placeholder: "e.g., Bench Press",
                    text: $newExerciseName
                )

                Spacer()
            }
            .padding()
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newExerciseName = ""
                        showingAddExercise = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addExercise()
                    }
                    .disabled(newExerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addExercise() {
        let exercise = ExerciseData(name: newExerciseName)
        exercises.append(exercise)
        newExerciseName = ""
        showingAddExercise = false
    }

    private func deleteExercise(at index: Int) {
        exercises.remove(at: index)
    }

    private func saveWorkout() {
        guard let user = users.first else { return }

        let workout = WorkoutSession(date: Date(), notes: workoutNotes)
        workout.user = user

        for exerciseData in exercises {
            let exercise = ExerciseEntry(exerciseName: exerciseData.name)
            exercise.workoutSession = workout

            for (index, setData) in exerciseData.sets.enumerated() {
                let set = ExerciseSet(
                    weight: setData.weight,
                    reps: setData.reps,
                    setNumber: index + 1
                )
                set.exercise = exercise
                modelContext.insert(set)
            }

            modelContext.insert(exercise)
        }

        modelContext.insert(workout)
        try? modelContext.save()

        exercises = []
        workoutNotes = ""
    }
}

struct ExerciseData: Identifiable {
    let id = UUID()
    var name: String
    var sets: [SetData] = []
}

struct SetData: Identifiable {
    let id = UUID()
    var weight: Double
    var reps: Int
}
