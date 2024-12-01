//
//  LoggingUtility.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 02/12/2024.
//

public func print(_ items: Any...) {
    #if DEBUG || BETA
    Swift.print(items)
    #endif
}
