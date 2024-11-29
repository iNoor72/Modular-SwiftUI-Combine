//
//  MockNetworkMonitor.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import Foundation
import Combine
@testable import Movies_SwiftUI_Combine

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnectedPublisher = CurrentValueSubject<Bool, Never>(true)
}
