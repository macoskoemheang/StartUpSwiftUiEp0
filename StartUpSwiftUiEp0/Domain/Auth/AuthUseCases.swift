import Foundation

struct LoginUseCase {
    let repository: AuthRepository

    func execute(email: String, password: String) async throws -> AuthSession {
        try await repository.login(email: email, password: password)
    }
}

struct RegisterUseCase {
    let repository: AuthRepository

    func execute(name: String, email: String, password: String) async throws -> AuthSession {
        try await repository.register(name: name, email: email, password: password)
    }
}

struct ForgotPasswordUseCase {
    let repository: AuthRepository

    func execute(email: String) async throws {
        try await repository.requestPasswordReset(email: email)
    }
}
