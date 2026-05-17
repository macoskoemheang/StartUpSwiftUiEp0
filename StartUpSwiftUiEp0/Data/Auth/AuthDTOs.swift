import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct RegisterRequestDTO: Encodable {
    let name: String
    let email: String
    let password: String
}

struct ForgotPasswordRequestDTO: Encodable {
    let email: String
}

struct AuthResponseDTO: Decodable {
    let id: UUID
    let name: String
    let email: String
    let token: String

    func toDomain() -> AuthSession {
        AuthSession(user: User(id: id, name: name, email: email), token: token)
    }
}
