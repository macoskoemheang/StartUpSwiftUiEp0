import SwiftUI

struct HomeView: View {
    let session: AuthSession
    let onLogout: () -> Void

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(AppTheme.accent)

                Text("Hello, \(session.user.name)")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text(session.user.email)
                    .foregroundStyle(.white.opacity(0.72))

                Text("Your auth flow is connected and ready for the next feature.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.86))
                    .padding(.top, 8)

                PrimaryAuthButton(title: "Logout", isLoading: false, action: onLogout)
                    .padding(.top, 8)
            }
            .padding(24)
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(AppTheme.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .padding()
        }
    }
}
