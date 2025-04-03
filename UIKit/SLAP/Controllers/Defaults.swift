//
//  Defaults.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog

private let mainTabBarSelectionKey = "mainTabBarSelection"

class Defaults {
    
    var config: Config
    var defaults: UserDefaults
    private let logger = Logger.defaultLogger()
    
    var mainTabBarSelection: MainTabBarTag {
        get {
            // NB: integer(forKey:) returns 0 if not found
            let value = defaults.integer(forKey: mainTabBarSelectionKey)
            return MainTabBarTag(rawValue: value) ?? .adoptables
        }
        set { defaults.setValue(newValue.rawValue, forKey: mainTabBarSelectionKey) }

    }
    
    init(config: Config, userDefaults: UserDefaults = UserDefaults.standard) {
        self.config = config
        self.defaults = userDefaults
    }
}
