import SwiftUI

struct AgeInputView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text("How old are you?")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.textPrimary)

                Text("This helps us provide age-appropriate guidance.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextField(
                title: "Age *",
                placeholder: "Enter your age",
                text: $viewModel.age,
                keyboardType: .numberPad
            )

            Spacer()

            PrimaryButton(
                title: "Continue",
                action: { viewModel.nextStep() },
                isEnabled: viewModel.isAgeValid
            )
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}
