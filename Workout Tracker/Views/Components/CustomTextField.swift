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
                .foregroundColor(.primary)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, AppSpacing.small)
                .background(AppColors.secondaryBackground)
                .cornerRadius(8)
        }
    }
}
