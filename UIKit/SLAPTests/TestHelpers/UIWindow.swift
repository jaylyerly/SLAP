//
//  UIWindow.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

extension UIWindow {
    
    func clearWindow() {
        subviews.forEach { $0.removeFromSuperview() }
        rootViewController = nil
        windowScene = nil
    }
    
}
