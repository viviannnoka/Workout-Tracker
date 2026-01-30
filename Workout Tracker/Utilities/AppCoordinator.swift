import SwiftUI
import SwiftData

struct AppCoordinator: View {
    @Query private var users: [UserProfile]

    var body: some View {
        if let user = users.first, user.hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingContainerView()
        }
    }
}
