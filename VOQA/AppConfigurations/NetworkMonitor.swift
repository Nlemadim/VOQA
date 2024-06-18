//
//  NetworkMonitor.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    @Published var connectionError: ConnectionError?

    private init() {
        self.monitor = NWPathMonitor()
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .unsatisfied {
                    self.connectionError = ConnectionError(
                        title: "No Connection",
                        message: "Your internet connection appears to be offline. Please check your connection and try again.",
                        errorType: .noConnection
                    )
                } else if path.status == .satisfied {
                    if let currentError = self.connectionError, currentError.errorType == .connectionError(.noConnection) {
                        self.connectionError = ConnectionError(
                            title: "Connection Restored",
                            message: "Your internet connection has been restored. You can continue using the app.",
                            errorType: .connectionRestored
                        )
                    } else {
                        self.connectionError = nil
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }
}
