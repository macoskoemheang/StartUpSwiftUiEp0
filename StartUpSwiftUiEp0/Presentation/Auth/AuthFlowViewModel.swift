import Foundation
import Combine

@MainActor
final class AuthFlowViewModel: ObservableObject {
    enum Screen {
        case login
        case register
        case forgotPassword
    }

    @Published var screen: Screen = .login
    @Published var session: AuthSession?
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var resetConfirmationMessage: String?

    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let forgotPasswordUseCase: ForgotPasswordUseCase

    init(repository: AuthRepository) {
        self.loginUseCase = LoginUseCase(repository: repository)
        self.registerUseCase = RegisterUseCase(repository: repository)
        self.forgotPasswordUseCase = ForgotPasswordUseCase(repository: repository)
    }

    func login(email: String, password: String) async {
        await perform {
            self.session = try await self.loginUseCase.execute(email: email, password: password)
        }
    }

    func register(name: String, email: String, password: String) async {
        await perform {
            self.session = try await self.registerUseCase.execute(name: name, email: email, password: password)
        }
    }

    func sendResetLink(email: String) async {
        await perform {
            try await self.forgotPasswordUseCase.execute(email: email)
            self.resetConfirmationMessage = "Reset instructions were sent to \(email)."
            self.screen = .login
        }
    }

    func logout() {
        session = nil
        screen = .login
    }

    private func perform(_ operation: @escaping () async throws -> Void) async {
        isLoading = true
        alertMessage = nil
        defer { isLoading = false }

        do {
            try await operation()
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
