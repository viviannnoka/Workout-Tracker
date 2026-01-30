import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.currentStep {
                case 0:
                    WelcomeView(viewModel: viewModel)
                case 1:
                    NameInputView(viewModel: viewModel)
                case 2:
                    AgeInputView(viewModel: viewModel)
                case 3:
                    HeightWeightInputView(viewModel: viewModel)
                case 4:
                    OnboardingCompleteView(viewModel: viewModel)
                default:
                    WelcomeView(viewModel: viewModel)
                }
            }
        }
    }
}
