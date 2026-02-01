import SwiftUI
import SwiftData

struct OnboardingCompleteView: View {
    @Bindable var viewModel: OnboardingViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: AppSpacing.extraLarge) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(AppColors.success)

            VStack(spacing: AppSpacing.medium) {
                Text("You're all set, \(viewModel.name)!")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Let's start tracking your workouts and reaching your fitness goals.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            PrimaryButton(title: "Start Tracking") {
                viewModel.saveUserProfile(modelContext: modelContext)
            }
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}
