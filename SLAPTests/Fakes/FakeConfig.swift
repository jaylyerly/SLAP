//
//  FakeConfig.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

class FakeConfig: Config {
    
    override var appVersion: String { "1.2.3" }
    override var buildNumber: String { "42" }
    
}

extension Config {
    
    static func fake() -> Config { FakeConfig() }
    
}
