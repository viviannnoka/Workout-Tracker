import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [UserProfile]
    @State private var showingEditProfile = false

    var user: UserProfile? {
        users.first
    }

    var uniqueWorkoutDates: Int {
        guard let user = user, let workouts = user.workouts else { return 0 }
        let calendar = Calendar.current
        let uniqueDates = Set(workouts.map { calendar.startOfDay(for: $0.date) })
        return uniqueDates.count
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
                            ProfileInfoRow(label: "Height", value: String(format: "%.1f %@", user.height, user.heightUnit))
                            ProfileInfoRow(label: "Weight", value: String(format: "%.1f %@", user.weight, user.weightUnit))
                        }
                        .padding()
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(12)

                        VStack(spacing: AppSpacing.medium) {
                            ProfileInfoRow(label: "Workout Days", value: "\(uniqueWorkoutDates)")
                        }
                        .padding()
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(12)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEditProfile = true }) {
                        Image(systemName: "pencil")
                    }
                }
            }
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
