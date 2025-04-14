//
//  FakeConfig.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
@testable import SLAPUI

class FakeConfig: PreviewConfig {
    
}

extension Config {
    
    static func fake() -> FakeConfig {
        FakeConfig()
    }

}
