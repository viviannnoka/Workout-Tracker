import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSession.date, order: .reverse) private var workouts: [WorkoutSession]

    var body: some View {
        NavigationStack {
            Group {
                if workouts.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(workouts) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                WorkoutRowView(workout: workout)
                            }
                        }
                        .onDelete(perform: deleteWorkouts)
                    }
                }
            }
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "list.bullet.clipboard")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)

            Text("No workouts yet")
                .font(AppFonts.title)
                .foregroundColor(.secondary)

            Text("Start logging your workouts to see them here")
                .font(AppFonts.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.extraLarge)
    }

    private func deleteWorkouts(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(workouts[index])
        }
    }
}

struct WorkoutRowView: View {
    let workout: WorkoutSession

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(workout.date, style: .date)
                .font(AppFonts.headline)

            Text(workout.date, style: .time)
                .font(AppFonts.caption)
                .foregroundColor(.secondary)

            if let exercises = workout.exercises, !exercises.isEmpty {
                Text("\(exercises.count) exercise\(exercises.count == 1 ? "" : "s")")
                    .font(AppFonts.body)
                    .foregroundColor(.secondary)
            }

            if !workout.notes.isEmpty {
                Text(workout.notes)
                    .font(AppFonts.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, AppSpacing.extraSmall)
    }
}
