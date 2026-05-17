import Combine
import Foundation
import Network

@MainActor
final class ConnectivityMonitor: ObservableObject {
    enum State: Equatable {
        case checking
        case connected
        case disconnected
    }

    @Published private(set) var state: State = .checking
    @Published private(set) var waitingRequestCount = 0

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityMonitor")
    private var connectionWaiters: [CheckedContinuation<Void, Never>] = []

    init() {
        startMonitoring()
    }

    deinit {
        monitor.cancel()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                self?.updateState(path.status == .satisfied ? .connected : .disconnected)
            }
        }
        monitor.start(queue: queue)
    }

    func waitUntilConnected() async {
        guard state != .connected else { return }

        waitingRequestCount += 1
        defer { waitingRequestCount -= 1 }

        await withCheckedContinuation { continuation in
            connectionWaiters.append(continuation)
        }
    }

    private func updateState(_ newState: State) {
        state = newState

        guard newState == .connected else { return }

        let waiters = connectionWaiters
        connectionWaiters.removeAll()
        waiters.forEach { $0.resume() }
    }
}
