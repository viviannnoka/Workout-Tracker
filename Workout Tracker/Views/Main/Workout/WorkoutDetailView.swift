import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    let workout: WorkoutSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text("Date")
                        .font(AppFonts.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Text(workout.date, style: .date)
                        .font(AppFonts.title)

                    Text(workout.date, style: .time)
                        .font(AppFonts.body)
                        .foregroundColor(.secondary)
                }

                if !workout.notes.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Notes")
                            .font(AppFonts.caption)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)

                        Text(workout.notes)
                            .font(AppFonts.body)
                    }
                }

                if let exercises = workout.exercises, !exercises.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        Text("Exercises")
                            .font(AppFonts.caption)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)

                        ForEach(exercises) { exercise in
                            ExerciseDetailView(exercise: exercise)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseDetailView: View {
    let exercise: ExerciseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(exercise.exerciseName)
                .font(AppFonts.title)

            if let sets = exercise.sets, !sets.isEmpty {
                VStack(spacing: AppSpacing.small) {
                    ForEach(sets.sorted(by: { $0.setNumber < $1.setNumber })) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                                .font(AppFonts.body)
                                .foregroundColor(.secondary)
                                .frame(width: 60, alignment: .leading)

                            HStack(spacing: AppSpacing.medium) {
                                HStack(spacing: AppSpacing.extraSmall) {
                                    Text("\(set.weight, specifier: "%.1f")")
                                        .font(AppFonts.body)
                                    Text("kg")
                                        .font(AppFonts.caption)
                                        .foregroundColor(.secondary)
                                }

                                Text("×")
                                    .foregroundColor(.secondary)

                                HStack(spacing: AppSpacing.extraSmall) {
                                    Text("\(set.reps)")
                                        .font(AppFonts.body)
                                    Text("reps")
                                        .font(AppFonts.caption)
                                        .foregroundColor(.secondary)
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
