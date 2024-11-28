//
//  MockNetworkMonitor.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import Foundation
@testable import Movies_SwiftUI_Combine

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true
}
