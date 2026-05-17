import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> AuthSession
    func register(name: String, email: String, password: String) async throws -> AuthSession
    func requestPasswordReset(email: String) async throws
}
