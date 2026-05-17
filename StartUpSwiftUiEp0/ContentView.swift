import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: AuthFlowViewModel

    init(repository: AuthRepository = AppEnvironment.demo.authRepository) {
        _viewModel = StateObject(wrappedValue: AuthFlowViewModel(repository: repository))
    }

    var body: some View {
        Group {
            if let session = viewModel.session {
                HomeView(session: session, onLogout: viewModel.logout)
            } else {
                switch viewModel.screen {
                case .login:
                    LoginView(viewModel: viewModel)
                case .register:
                    RegisterView(viewModel: viewModel)
                case .forgotPassword:
                    ForgotPasswordView(viewModel: viewModel)
                }
            }
        }
        .animation(.spring(duration: 0.35), value: viewModel.screen)
        .animation(.spring(duration: 0.35), value: viewModel.session)
        .alert("Notice", isPresented: Binding(
            get: { viewModel.alertMessage != nil },
            set: { if !$0 { viewModel.alertMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .alert("Email sent", isPresented: Binding(
            get: { viewModel.resetConfirmationMessage != nil },
            set: { if !$0 { viewModel.resetConfirmationMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.resetConfirmationMessage ?? "")
        }
    }
}

#Preview {
    ContentView()
}
