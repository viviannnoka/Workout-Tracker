import SwiftUI

struct HeightWeightInputView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text("Your measurements")
                    .font(AppFonts.largeTitle)

                Text("Help us track your fitness journey.")
                    .font(AppFonts.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextField(
                title: "Height (cm)",
                placeholder: "Enter your height",
                text: $viewModel.height,
                keyboardType: .decimalPad
            )

            CustomTextField(
                title: "Weight (kg)",
                placeholder: "Enter your weight",
                text: $viewModel.weight,
                keyboardType: .decimalPad
            )

            Spacer()

            PrimaryButton(
                title: "Continue",
                action: { viewModel.nextStep() },
                isEnabled: viewModel.isHeightValid && viewModel.isWeightValid
            )
        }
        .padding(AppSpacing.large)
    }
}
