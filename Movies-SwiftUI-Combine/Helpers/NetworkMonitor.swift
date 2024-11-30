//
//  NetworkMonitor.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Network
import Combine

protocol NetworkMonitorProtocol {
    var isConnectedPublisher: CurrentValueSubject<Bool, Never> { get }
}

public final class NetworkMonitor: @unchecked Sendable, NetworkMonitorProtocol {

    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .background)
    public let isConnectedPublisher = CurrentValueSubject<Bool, Never>(true)

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnectedPublisher.send(isConnected)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
