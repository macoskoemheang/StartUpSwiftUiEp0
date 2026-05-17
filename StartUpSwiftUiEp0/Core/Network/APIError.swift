import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case server(statusCode: Int, message: String?)
    case decodingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case let .server(statusCode, message):
            return message ?? "Request failed with status code \(statusCode)."
        case .decodingFailed:
            return "We could not read the server response."
        case let .unknown(error):
            return error.localizedDescription
        }
    }
}
