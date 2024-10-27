//
//  DefaultsTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class DefaultsTests: TestCase {
    
    var defaults: Defaults!
    var userDefaults: UserDefaults!
    var config = FakeConfig()
    let userDefaultsSuiteName = "TestDefaults"

    override func setUpWithError() throws {
        try super.setUpWithError()
        // nuke any old leftover data
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
        userDefaults = UserDefaults(suiteName: userDefaultsSuiteName)
        defaults = Defaults(config: config, userDefaults: userDefaults)
    }
    
    override func tearDownWithError() throws {
        defaults = nil
        userDefaults = nil
        try super.tearDownWithError()
    }
    
    func testMainTabBarSelection() throws {
        // Check default value
        expectNoDifference(defaults.mainTabBarSelection, .adoptables)
        
        // Check read/write
        defaults.mainTabBarSelection = .links
        expectNoDifference(defaults.mainTabBarSelection, .links)
        
        // Check another instance
        let newDefaults = Defaults(config: config, userDefaults: userDefaults)
        expectNoDifference(defaults.mainTabBarSelection, .links)
    }
    
}
