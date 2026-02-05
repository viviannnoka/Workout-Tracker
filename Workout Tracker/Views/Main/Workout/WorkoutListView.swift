import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSession.date, order: .reverse) private var workouts: [WorkoutSession]
    @State private var showingNewWorkout = false
    @State private var searchText = ""

    var filteredWorkouts: [WorkoutSession] {
        if searchText.isEmpty {
            return workouts
        } else {
            return workouts.filter { workout in
                // Search in workout notes
                if workout.notes.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
                // Search in exercise names
                if let exercises = workout.exercises {
                    return exercises.contains { exercise in
                        exercise.exerciseName.localizedCaseInsensitiveContains(searchText)
                    }
                }
                return false
            }
        }
    }

    var groupedWorkouts: [(Date, [WorkoutSession])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredWorkouts) { workout in
            calendar.startOfDay(for: workout.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }

    var body: some View {
        NavigationStack {
            Group {
                if workouts.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(groupedWorkouts, id: \.0) { date, dayWorkouts in
                            NavigationLink(destination: WorkoutDetailView(date: date, workouts: dayWorkouts)) {
                                WorkoutDateRowView(date: date, workouts: dayWorkouts)
                            }
                            .listRowBackground(AppColors.secondaryBackground)
                        }
                        .onDelete(perform: deleteWorkoutGroup)
                    }
                    .scrollContentBackground(.hidden)
                    .background(AppColors.background)
                }
            }
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewWorkout) {
                NewWorkoutView()
            }
            .searchable(text: $searchText, prompt: "Search exercises or notes")
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "list.bullet.clipboard")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(AppColors.textSecondary)

            Text("No workouts yet")
                .font(AppFonts.title)
                .foregroundColor(AppColors.textPrimary)

            Text("Tap the + button to log your first workout")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }

    private func deleteWorkoutGroup(at offsets: IndexSet) {
        for index in offsets {
            let (_, workoutsToDelete) = groupedWorkouts[index]
            for workout in workoutsToDelete {
                modelContext.delete(workout)
            }
        }
    }
}

struct WorkoutDateRowView: View {
    let date: Date
    let workouts: [WorkoutSession]

    var sortedWorkouts: [WorkoutSession] {
        workouts.sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(date, style: .date)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            ForEach(Array(sortedWorkouts.enumerated()), id: \.element.id) { index, workout in
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    HStack {
                        Text("Session \(sortedWorkouts.count - index)")
                            .font(AppFonts.body)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)

                        Text(workout.date, style: .time)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    if let exercises = workout.exercises, !exercises.isEmpty {
                        let sortedExercises = exercises.sorted(by: { $0.createdAt > $1.createdAt })
                        Text(sortedExercises.map { $0.exerciseName }.joined(separator: ", "))
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .padding(.leading, AppSpacing.medium)
            }
        }
        .padding(.vertical, AppSpacing.extraSmall)
    }
}
