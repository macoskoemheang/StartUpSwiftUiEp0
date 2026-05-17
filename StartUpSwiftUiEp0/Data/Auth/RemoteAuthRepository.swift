import Foundation

struct RemoteAuthRepository: AuthRepository {
    let apiClient: APIClient

    func login(email: String, password: String) async throws -> AuthSession {
        let response: AuthResponseDTO = try await apiClient.send(
            path: "auth/login",
            method: "POST",
            body: LoginRequestDTO(email: email, password: password)
        )
        return response.toDomain()
    }

    func register(name: String, email: String, password: String) async throws -> AuthSession {
        let response: AuthResponseDTO = try await apiClient.send(
            path: "auth/register",
            method: "POST",
            body: RegisterRequestDTO(name: name, email: email, password: password)
        )
        return response.toDomain()
    }

    func requestPasswordReset(email: String) async throws {
        let _: EmptyResponse = try await apiClient.send(
            path: "auth/forgot-password",
            method: "POST",
            body: ForgotPasswordRequestDTO(email: email)
        )
    }
}
