import Foundation

struct AppEnvironment {
    let authRepository: AuthRepository

    static let demo = AppEnvironment(authRepository: DemoAuthRepository())

    static let live = AppEnvironment(
        authRepository: RemoteAuthRepository(
            apiClient: APIClient(baseURL: URL(string: "https://api.yourdomain.com/")!)
        )
    )
}
