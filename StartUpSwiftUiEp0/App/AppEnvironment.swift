import Foundation

struct AppEnvironment {
    let authRepository: AuthRepository

    static let demo = AppEnvironment(authRepository: DemoAuthRepository())

    static func live(connectivityMonitor: ConnectivityMonitor) -> AppEnvironment {
        AppEnvironment(
            authRepository: RemoteAuthRepository(
                apiClient: APIClient(
                    baseURL: URL(string: "https://api.yourdomain.com/")!,
                    connectivityMonitor: connectivityMonitor
                )
            )
        )
    }
}
