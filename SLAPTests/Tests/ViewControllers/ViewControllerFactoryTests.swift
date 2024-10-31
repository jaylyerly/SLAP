//
//  ViewControllerFactoryTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/29/24.
//

@testable import SLAP
import UIKit
import XCTest

class ViewControllerFactoryTests: TestCase {
    
    var appEnv: AppEnv!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        appEnv = .fake()
    }
    
    override func tearDownWithError() throws {
        appEnv = nil
        try super.tearDownWithError()
    }
    
    func testStoreButton() throws {
        // Load all the VCs to make sure all the storyboards are configured correctly
        XCTAssertNotNil(ViewControllerFactory.main(appEnv: appEnv))
        XCTAssertNotNil(ViewControllerFactory.links(appEnv: appEnv))
        XCTAssertNotNil(ViewControllerFactory.list(appEnv: appEnv, mode: .adoptables))
        XCTAssertNotNil(ViewControllerFactory.detail(appEnv: appEnv, internalId: ""))
    }
    
}
