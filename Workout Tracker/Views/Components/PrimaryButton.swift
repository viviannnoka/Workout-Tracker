import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? AppColors.primary : AppColors.secondary)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}
