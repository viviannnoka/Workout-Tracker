import SwiftUI

struct NameInputView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text("What's your name?")
                    .font(AppFonts.largeTitle)

                Text("We'll use this to personalize your experience.")
                    .font(AppFonts.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextField(
                title: "Name",
                placeholder: "Enter your name",
                text: $viewModel.name
            )

            Spacer()

            PrimaryButton(
                title: "Continue",
                action: { viewModel.nextStep() },
                isEnabled: viewModel.isNameValid
            )
        }
        .padding(AppSpacing.large)
    }
}
