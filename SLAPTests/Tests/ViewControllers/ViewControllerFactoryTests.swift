//
//  ViewControllerFactoryTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/29/24.
//

import UIKit
@testable import SLAP
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
        XCTAssertNotNil(ViewControllerFactory.main(appEnv: appEnv))
        XCTAssertNotNil(ViewControllerFactory.links(appEnv: appEnv))
        XCTAssertNotNil(ViewControllerFactory.list(appEnv: appEnv, mode: .adoptables))
        XCTAssertNotNil(ViewControllerFactory.detail(appEnv: appEnv, detailId: ""))
    }
    
}
