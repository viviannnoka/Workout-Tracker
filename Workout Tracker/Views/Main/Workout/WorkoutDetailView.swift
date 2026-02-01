import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let date: Date
    let workouts: [WorkoutSession]

    @State private var workoutToDelete: WorkoutSession?
    @State private var showingDeleteAlert = false
    @State private var workoutToEdit: WorkoutSession?
    @State private var showingEditWorkout = false

    var sortedWorkouts: [WorkoutSession] {
        workouts.sorted { $0.date > $1.date }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text("Date")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .textCase(.uppercase)

                    Text(date, style: .date)
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                }

                ForEach(sortedWorkouts) { workout in
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        HStack {
                            Text(workout.date, style: .time)
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)

                            Spacer()

                            Button(action: {
                                workoutToEdit = workout
                                showingEditWorkout = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(AppColors.textPrimary)
                            }

                            Button(action: {
                                workoutToDelete = workout
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(AppColors.danger)
                            }
                        }

                        if !workout.notes.isEmpty {
                            Text(workout.notes)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.bottom, AppSpacing.small)
                        }

                        if let exercises = workout.exercises, !exercises.isEmpty {
                            ForEach(exercises) { exercise in
                                ExerciseDetailView(exercise: exercise)
                            }
                        }
                    }
                    .padding()
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(AppColors.background)
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Workout?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteWorkout()
            }
        } message: {
            Text("This workout session will be permanently deleted.")
        }
        .sheet(isPresented: $showingEditWorkout) {
            if let workout = workoutToEdit {
                EditWorkoutView(workout: workout)
            }
        }
    }

    private func deleteWorkout() {
        guard let workout = workoutToDelete else { return }
        modelContext.delete(workout)
        try? modelContext.save()

        // If this was the last workout for this date, go back
        if workouts.count == 1 {
            dismiss()
        }
    }
}

struct ExerciseDetailView: View {
    let exercise: ExerciseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(exercise.exerciseName)
                .font(AppFonts.title)
                .foregroundColor(AppColors.textPrimary)

            if !exercise.notes.isEmpty {
                Text(exercise.notes)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .italic()
            }

            if let sets = exercise.sets, !sets.isEmpty {
                VStack(spacing: AppSpacing.small) {
                    ForEach(sets.sorted(by: { $0.setNumber < $1.setNumber })) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                                .frame(width: 60, alignment: .leading)

                            if set.setTypeEnum == .weightReps {
                                HStack(spacing: AppSpacing.medium) {
                                    HStack(spacing: AppSpacing.extraSmall) {
                                        Text("\(set.weight ?? 0, specifier: "%.1f")")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.textPrimary)
                                        Text("kg")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }

                                    Text("×")
                                        .foregroundColor(AppColors.textSecondary)

                                    HStack(spacing: AppSpacing.extraSmall) {
                                        Text("\(set.reps ?? 0)")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.textPrimary)
                                        Text("reps")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                            } else {
                                HStack(spacing: AppSpacing.medium) {
                                    HStack(spacing: AppSpacing.extraSmall) {
                                        Text("Level")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                        Text("\(set.level ?? 0)")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.textPrimary)
                                    }

                                    Text("•")
                                        .foregroundColor(AppColors.textSecondary)

                                    HStack(spacing: AppSpacing.extraSmall) {
                                        Text("\(set.duration ?? 0, specifier: "%.0f")")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.textPrimary)
                                        Text("sec")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                            }

                            Spacer()
                        }
                        .padding(AppSpacing.small)
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
    }
}
