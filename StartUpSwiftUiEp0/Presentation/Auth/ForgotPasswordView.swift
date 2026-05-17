import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthFlowViewModel
    @State private var email = ""

    var body: some View {
        AuthScreenContainer {
            AuthCard {
                VStack(spacing: 8) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(AppTheme.accent)
                    Text("Reset password")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    Text("We will send a reset link to your email")
                        .foregroundStyle(.white.opacity(0.72))
                }

                AuthTextField(title: "Email", systemImage: "envelope", text: $email, keyboardType: .emailAddress)

                PrimaryAuthButton(title: "Send reset link", isLoading: viewModel.isLoading) {
                    Task { await viewModel.sendResetLink(email: email) }
                }

                Button("Back to login") {
                    viewModel.screen = .login
                }
                .foregroundStyle(AppTheme.accent)
                .font(.footnote.weight(.semibold))
            }
        }
    }
}
