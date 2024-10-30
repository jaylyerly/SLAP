//
//  Style.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

enum Style {
    
    // swiftlint:disable force_unwrapping
    static let accentForegroundColor = UIColor.white
    static let accentSecondaryColor = UIColor(named: "SecondaryAccent")!
    static let accentBackgroundColor = UIColor.accent.withAlphaComponent(0.7)
    static let accentFont = UIFont(name: "MarkerFelt-Wide", size: 32)!
    // swiftlint:enable force_unwrapping
    
    static func initialize() {
        UITabBar.appearance().barTintColor = .orange
        UITabBar.appearance().tintColor = .white
    }
}
