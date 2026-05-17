import Foundation

struct User: Equatable {
    let id: UUID
    let name: String
    let email: String
}

struct AuthSession: Equatable {
    let user: User
    let token: String
}
