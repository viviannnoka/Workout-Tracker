import SwiftUI

struct WelcomeView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppSpacing.extraLarge) {
            Spacer()

            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(AppColors.primary)

            VStack(spacing: AppSpacing.medium) {
                Text("Welcome to Workout Tracker")
                    .font(AppFonts.largeTitle)
                    .multilineTextAlignment(.center)

                Text("Track your workouts, monitor your progress, and achieve your fitness goals.")
                    .font(AppFonts.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            PrimaryButton(title: "Get Started") {
                viewModel.nextStep()
            }
        }
        .padding(AppSpacing.large)
    }
}
