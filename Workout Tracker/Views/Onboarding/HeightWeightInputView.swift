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

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text("Height")
                    .font(AppFonts.headline)
                    .foregroundColor(.primary)

                HStack(spacing: AppSpacing.medium) {
                    TextField("Enter height", text: $viewModel.height)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)

                    Picker("Unit", selection: $viewModel.heightUnit) {
                        Text("cm").tag(HeightUnit.cm)
                        Text("in").tag(HeightUnit.inches)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                }
            }

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text("Weight")
                    .font(AppFonts.headline)
                    .foregroundColor(.primary)

                HStack(spacing: AppSpacing.medium) {
                    TextField("Enter weight", text: $viewModel.weight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)

                    Picker("Unit", selection: $viewModel.weightUnit) {
                        Text("kg").tag(WeightUnit.kg)
                        Text("lbs").tag(WeightUnit.lbs)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                }
            }

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
