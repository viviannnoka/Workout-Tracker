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
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Track your workouts, monitor your progress, and achieve your fitness goals.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            PrimaryButton(title: "Get Started") {
                viewModel.nextStep()
            }
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}
