import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutListView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }
                .tag(0)

            NewWorkoutView()
                .tabItem {
                    Label("New Workout", systemImage: "plus.circle.fill")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(2)
        }
    }
}
