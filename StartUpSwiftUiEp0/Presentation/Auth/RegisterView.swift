import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthFlowViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        AuthScreenContainer {
            AuthCard {
                VStack(spacing: 8) {
                    Text("Create account")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    Text("Start with a small, clean foundation")
                        .foregroundStyle(.white.opacity(0.72))
                }

                AuthTextField(title: "Full name", systemImage: "person", text: $name)
                AuthTextField(title: "Email", systemImage: "envelope", text: $email, keyboardType: .emailAddress)
                AuthTextField(title: "Password", systemImage: "lock", text: $password, isSecure: true)

                PrimaryAuthButton(title: "Register", isLoading: viewModel.isLoading) {
                    Task { await viewModel.register(name: name, email: email, password: password) }
                }

                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundStyle(.white.opacity(0.72))
                    Button("Login") {
                        viewModel.screen = .login
                    }
                    .foregroundStyle(AppTheme.accent)
                    .fontWeight(.semibold)
                }
                .font(.footnote)
            }
        }
    }
}
