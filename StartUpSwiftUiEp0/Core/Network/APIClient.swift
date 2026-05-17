import Foundation

struct EmptyResponse: Decodable {}

struct APIClient {
    let baseURL: URL
    var session: URLSession = .shared
    var connectivityMonitor: ConnectivityMonitor?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func send<Response: Decodable, Body: Encodable>(
        path: String,
        method: String,
        body: Body? = Optional<String>.none,
        responseType: Response.Type = Response.self
    ) async throws -> Response {
        let url = baseURL.appending(path: path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            request.httpBody = try encoder.encode(body)
        }

        do {
            await connectivityMonitor?.waitUntilConnected()

            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let serverMessage = try? decoder.decode(ServerMessage.self, from: data).message
                throw APIError.server(statusCode: httpResponse.statusCode, message: serverMessage)
            }

            if data.isEmpty, Response.self == EmptyResponse.self {
                return EmptyResponse() as! Response
            }

            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
}

private struct ServerMessage: Decodable {
    let message: String
}
