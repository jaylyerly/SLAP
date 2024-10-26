//
//  LinksViewControllerTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class LinksViewControllerTests: TestCase {
    
    var linksVC: LinksViewController!
    var appEnv: AppEnv!
    
    var webLinks: FakeWebLinks { appEnv.webLinks as! FakeWebLinks }
    var config: Config { appEnv.config }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        appEnv = .fake()
        linksVC = ViewControllerFactory.links(appEnv: appEnv)
    }
    
    override func tearDownWithError() throws {
        linksVC = nil
        appEnv = nil
        try super.tearDownWithError()
    }
    
    func testStoreButton() {
        XCTAssertNotNil(linksVC.view)
        
        XCTAssertNil(webLinks.lastOpenUrl)
        XCTAssertNil(webLinks.lastPresentingViewController)
        
        linksVC.storeButton.sendActions(for: .touchUpInside)
        
        expectNoDifference(webLinks.lastOpenUrl, config.storeUrl)
        XCTAssertTrue(webLinks.lastPresentingViewController === linksVC)
    }
    
    func testWebsiteButton() {
        XCTAssertNotNil(linksVC.view)
        
        XCTAssertNil(webLinks.lastOpenUrl)
        XCTAssertNil(webLinks.lastPresentingViewController)
        
        linksVC.websiteButton.sendActions(for: .touchUpInside)
        
        expectNoDifference(webLinks.lastOpenUrl, config.homeUrl)
        XCTAssertTrue(webLinks.lastPresentingViewController === linksVC)
    }
    
}
