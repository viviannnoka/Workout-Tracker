import SwiftUI

struct SetRowView: View {
    let setNumber: Int
    @Binding var set: SetData
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text("Set \(setNumber)")
                .font(AppFonts.body)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)

            HStack(spacing: AppSpacing.medium) {
                HStack(spacing: AppSpacing.extraSmall) {
                    Text("\(set.weight, specifier: "%.1f")")
                        .font(AppFonts.body)
                    Text("kg")
                        .font(AppFonts.caption)
                        .foregroundColor(.secondary)
                }

                Text("×")
                    .foregroundColor(.secondary)

                HStack(spacing: AppSpacing.extraSmall) {
                    Text("\(set.reps)")
                        .font(AppFonts.body)
                    Text("reps")
                        .font(AppFonts.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
            }
        }
        .padding(AppSpacing.small)
        .background(AppColors.background)
        .cornerRadius(8)
    }
}
