import SwiftUI

enum AppColors {
    // Complete dark theme with white accents
    static let primary = Color.white // White for primary elements
    static let secondary = Color(hex: "A0A0A0") // Light gray for secondary text
    static let background = Color(hex: "000000") // Pure black background
    static let secondaryBackground = Color(hex: "1A1A1A") // Very dark gray for elevated surfaces
    static let accent = Color.white // White accent
    static let tertiary = Color(hex: "2A2A2A") // Dark gray for cards
    static let success = Color(hex: "10B981") // Success green
    static let danger = Color(hex: "EF4444") // Danger red
    static let textPrimary = Color.white // White text
    static let textSecondary = Color(hex: "B0B0B0") // Light gray text
    static let border = Color.white // White borders
}

// Color extension for hex support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum AppSpacing {
    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
}

enum AppFonts {
    static let largeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let title = Font.system(.title2, design: .rounded).weight(.semibold)
    static let headline = Font.system(.headline, design: .rounded)
    static let body = Font.system(.body, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded)
}
