import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: AuthFlowViewModel
    @EnvironmentObject private var connectivityMonitor: ConnectivityMonitor
    @State private var showConnectivitySnackbar = false
    @State private var snackbarDismissTask: Task<Void, Never>?
    @State private var hasResolvedInitialConnectivity = false

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
        .overlay(alignment: .top) {
            if showConnectivitySnackbar {
                ConnectivitySnackbar(
                    state: connectivityMonitor.state,
                    waitingRequestCount: connectivityMonitor.waitingRequestCount
                )
                    .padding(.top, 14)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: connectivityMonitor.state) { _, newState in
            handleConnectivityChange(newState)
        }
        .animation(.spring(duration: 0.35), value: showConnectivitySnackbar)
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

    private func handleConnectivityChange(_ state: ConnectivityMonitor.State) {
        guard state != .checking else { return }

        if !hasResolvedInitialConnectivity {
            hasResolvedInitialConnectivity = true

            if state == .connected {
                return
            }
        }

        snackbarDismissTask?.cancel()
        showConnectivitySnackbar = true

        if state == .connected {
            snackbarDismissTask = Task {
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { return }
                showConnectivitySnackbar = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ConnectivityMonitor())
}
