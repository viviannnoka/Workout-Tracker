import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [UserProfile]
    @State private var showingEditProfile = false

    var user: UserProfile? {
        users.first
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    if let user = user {
                        VStack(spacing: AppSpacing.extraLarge) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(AppColors.primary)

                            Text(user.name)
                                .font(AppFonts.largeTitle)
                        }
                        .padding(.top, AppSpacing.large)

                        VStack(spacing: AppSpacing.medium) {
                            ProfileInfoRow(label: "Age", value: "\(user.age) years")
                            ProfileInfoRow(label: "Height", value: String(format: "%.1f cm", user.height))
                            ProfileInfoRow(label: "Weight", value: String(format: "%.1f kg", user.weight))
                        }
                        .padding()
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(12)

                        if let workouts = user.workouts {
                            VStack(spacing: AppSpacing.medium) {
                                ProfileInfoRow(label: "Total Workouts", value: "\(workouts.count)")
                            }
                            .padding()
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(12)
                        }

                        PrimaryButton(title: "Edit Profile") {
                            showingEditProfile = true
                        }
                        .padding(.top, AppSpacing.large)
                    } else {
                        Text("No profile found")
                            .font(AppFonts.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingEditProfile) {
                if let user = user {
                    EditProfileView(user: user)
                }
            }
        }
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(AppFonts.body)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(AppFonts.headline)
        }
    }
}
