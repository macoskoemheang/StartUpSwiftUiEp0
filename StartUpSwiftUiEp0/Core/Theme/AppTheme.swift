import SwiftUI

enum AppTheme {
    static let background = LinearGradient(
        colors: [Color(red: 0.07, green: 0.09, blue: 0.19), Color(red: 0.21, green: 0.11, blue: 0.36)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let card = Color.white.opacity(0.12)
    static let border = Color.white.opacity(0.18)
    static let accent = Color(red: 0.47, green: 0.77, blue: 1.0)
}
