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

            if set.setType == .weightReps {
                HStack(spacing: AppSpacing.medium) {
                    HStack(spacing: AppSpacing.extraSmall) {
                        Text("\(set.weight ?? 0, specifier: "%.1f")")
                            .font(AppFonts.body)
                        Text("kg")
                            .font(AppFonts.caption)
                            .foregroundColor(.secondary)
                    }

                    Text("×")
                        .foregroundColor(.secondary)

                    HStack(spacing: AppSpacing.extraSmall) {
                        Text("\(set.reps ?? 0)")
                            .font(AppFonts.body)
                        Text("reps")
                            .font(AppFonts.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                HStack(spacing: AppSpacing.medium) {
                    HStack(spacing: AppSpacing.extraSmall) {
                        Text("Level")
                            .font(AppFonts.caption)
                            .foregroundColor(.secondary)
                        Text("\(set.level ?? 0)")
                            .font(AppFonts.body)
                    }

                    Text("•")
                        .foregroundColor(.secondary)

                    HStack(spacing: AppSpacing.extraSmall) {
                        Text("\(set.duration ?? 0, specifier: "%.0f")")
                            .font(AppFonts.body)
                        Text("sec")
                            .font(AppFonts.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "minus.circle")
                    .foregroundColor(AppColors.danger)
            }
        }
        .padding(AppSpacing.small)
        .background(AppColors.background)
        .cornerRadius(8)
    }
}
