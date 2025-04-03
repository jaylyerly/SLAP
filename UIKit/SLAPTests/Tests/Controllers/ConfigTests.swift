//
//  ConfigTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/31/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class ConfigTests: TestCase {
    
    var config: Config!

    override func setUpWithError() throws {
        try super.setUpWithError()
        config = Config()
    }
    
    override func tearDownWithError() throws {
        config = nil
        try super.tearDownWithError()
    }
    
    func testValues() throws {
        expectNoDifference(config.apiRoot.absoluteString, "https://www.shelterluv.com/api/v1/")
        expectNoDifference(config.storeUrl.absoluteString, "https://shop.trianglerabbits.org")
        expectNoDifference(config.homeUrl.absoluteString, "https://www.trianglerabbits.org")
        expectNoDifference(config.bundleId, "com.sonicbunny.SLAP")
        expectNoDifference(config.version, "\(config.appVersion) (\(config.buildNumber))")
    }
    
}
