import Foundation

struct DemoAuthRepository: AuthRepository {
    func login(email: String, password: String) async throws -> AuthSession {
        try await simulateNetwork()
        guard email == "demo@swiftui.dev", password == "Password123" else {
            throw AuthDemoError.invalidCredentials
        }
        return makeSession(name: "SwiftUI Learner", email: email)
    }

    func register(name: String, email: String, password: String) async throws -> AuthSession {
        try await simulateNetwork()
        guard !name.isEmpty, email.contains("@"), password.count >= 8 else {
            throw AuthDemoError.invalidRegistration
        }
        return makeSession(name: name, email: email)
    }

    func requestPasswordReset(email: String) async throws {
        try await simulateNetwork()
        guard email.contains("@") else {
            throw AuthDemoError.invalidEmail
        }
    }

    private func simulateNetwork() async throws {
        try await Task.sleep(for: .milliseconds(700))
    }

    private func makeSession(name: String, email: String) -> AuthSession {
        AuthSession(
            user: User(id: UUID(), name: name, email: email),
            token: "demo-token"
        )
    }
}

private enum AuthDemoError: LocalizedError {
    case invalidCredentials
    case invalidRegistration
    case invalidEmail

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Use demo@swiftui.dev and Password123, or create a new account."
        case .invalidRegistration:
            return "Please enter a name, valid email, and password with at least 8 characters."
        case .invalidEmail:
            return "Please enter a valid email address."
        }
    }
}
