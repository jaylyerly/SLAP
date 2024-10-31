//
//  SecretsTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class SecretsTests: TestCase {
    
    func testApiKey() throws {
        // Just make sure that the apiKey is defined and is the right length
        expectNoDifference(Secrets.apiKey.count, 36)
    }
    
}
