//
//  NetworkMonitor.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Network
import Combine
import Reachability

protocol NetworkMonitorProtocol {
    var isConnectedPublisher: CurrentValueSubject<Bool, Never> { get }
}

public final class NetworkMonitor: @unchecked Sendable, NetworkMonitorProtocol {
    static let shared = NetworkMonitor()
    
    private let reachability = try! Reachability()
    public let isConnectedPublisher = CurrentValueSubject<Bool, Never>(true)
    
    private init() {
        reachability.whenReachable = { [weak self] reachability in
            guard let self else { return }
            print("Reachable: \(reachability)")
            isConnectedPublisher.send(true)
        }
        
        reachability.whenUnreachable = { [weak self] _ in
            guard let self else { return }
            print("Unreachable")
            isConnectedPublisher.send(false)
        }
    }
    
    func startMonitoring() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
    }
}
