//
//  Workout_TrackerApp.swift
//  Workout Tracker
//
//  Created by Vivian Nnoka on 2026-01-29.
//

import SwiftUI
import SwiftData

@main
struct Workout_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator()
        }
        .modelContainer(for: [UserProfile.self, WorkoutSession.self, ExerciseEntry.self, ExerciseSet.self])
    }
}
