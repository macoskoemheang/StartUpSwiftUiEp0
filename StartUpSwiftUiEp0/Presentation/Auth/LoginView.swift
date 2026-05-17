import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthFlowViewModel
    @State private var email = "demo@swiftui.dev"
    @State private var password = "Password123"

    var body: some View {
        AuthScreenContainer {
            AuthCard {
                header(title: "Welcome back", subtitle: "Sign in to continue your journey")

                AuthTextField(title: "Email", systemImage: "envelope", text: $email, keyboardType: .emailAddress)
                AuthTextField(title: "Password", systemImage: "lock", text: $password, isSecure: true)

                HStack {
                    Spacer()
                    Button("Forgot password?") {
                        viewModel.screen = .forgotPassword
                    }
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(AppTheme.accent)
                }

                PrimaryAuthButton(title: "Login", isLoading: viewModel.isLoading) {
                    Task { await viewModel.login(email: email, password: password) }
                }

                footer(prefix: "New here?", actionTitle: "Create account") {
                    viewModel.screen = .register
                }
            }
        }
    }
}

private extension LoginView {
    func header(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.system(size: 34))
                .foregroundStyle(AppTheme.accent)

            Text(title)
                .font(.title.bold())
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
        }
    }

    func footer(prefix: String, actionTitle: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 4) {
            Text(prefix)
                .foregroundStyle(.white.opacity(0.72))
            Button(actionTitle, action: action)
                .foregroundStyle(AppTheme.accent)
                .fontWeight(.semibold)
        }
        .font(.footnote)
    }
}
