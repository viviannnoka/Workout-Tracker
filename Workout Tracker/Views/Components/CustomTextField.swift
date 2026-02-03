import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .foregroundColor(AppColors.textPrimary)
                .accentColor(AppColors.textPrimary)
                .autocorrectionDisabled()
                .padding()
                .background(AppColors.secondaryBackground)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.border, lineWidth: 2)
                )
        }
    }
}
