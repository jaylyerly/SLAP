//
//  Defaults.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog

private let searchTermKey = "searchTerm"

class Defaults {
    
    var config: Config
    var defaults: UserDefaults
    private let logger = Logger.defaultLogger()
    
    var searchTerm: String? {
        get { defaults.string(forKey: searchTermKey) }
        set { defaults.setValue(newValue, forKey: searchTermKey) }
    }
    
    init(config: Config, userDefaults: UserDefaults = UserDefaults.standard) {
        self.config = config
        self.defaults = userDefaults
    }
}
