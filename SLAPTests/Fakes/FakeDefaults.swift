//
//  FakeDefaults.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

class FakeDefaults: Defaults {
    
    let userDefaultsSuiteName = "TestDefaults"
    
    init(config: Config) {
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
        let defaults = UserDefaults(suiteName: userDefaultsSuiteName)!
        super.init(config: config, userDefaults: defaults)
    }

}

extension Defaults {
    
    static func fake(config: Config) -> FakeDefaults { FakeDefaults(config: config) }

}
