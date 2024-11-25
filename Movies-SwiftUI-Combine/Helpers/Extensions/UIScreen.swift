//
//  UIScreen.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit.UIScreen

extension UIScreen {
    static private var current: UIScreen? { UIWindow.current?.screen }
    static var width: CGFloat { current?.bounds.width ?? 0 }
    static var height: CGFloat { current?.bounds.height ?? 0 }
}
