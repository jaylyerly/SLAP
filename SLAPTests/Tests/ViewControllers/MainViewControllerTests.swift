//
//  MainViewControllerTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/31/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class MainViewControllerTests: TestCase {
    
    var mainVC: MainViewController!
    var appEnv: AppEnv!
        
    override func setUpWithError() throws {
        try super.setUpWithError()
        appEnv = .fake()
        mainVC = ViewControllerFactory.main(appEnv: appEnv)
    }
    
    override func tearDownWithError() throws {
        mainVC = nil
        appEnv = nil
        try super.tearDownWithError()
    }
    
    func testSetup() throws {
        XCTAssertNotNil(mainVC.view)
        
        expectNoDifference(mainVC.viewControllers?.count, 3)
        let nav0 = try XCTUnwrap(mainVC.viewControllers?[0] as? UINavigationController)
        let nav1 = try XCTUnwrap(mainVC.viewControllers?[1] as? UINavigationController)
        let nav2 = try XCTUnwrap(mainVC.viewControllers?[2] as? UINavigationController)
        XCTAssertTrue(nav0.viewControllers[0] is ListViewController)
        XCTAssertTrue(nav1.viewControllers[0] is ListViewController)
        XCTAssertTrue(nav2.viewControllers[0] is LinksViewController)

        expectNoDifference(nav0.viewControllers[0].tabBarItem.title, "Adoptables")
        expectNoDifference(nav1.viewControllers[0].tabBarItem.title, "Favorites")
        expectNoDifference(nav2.viewControllers[0].tabBarItem.title, "Links")
        
        expectNoDifference(nav0.viewControllers[0].tabBarItem.tag, MainTabBarTag.adoptables.rawValue)
        expectNoDifference(nav1.viewControllers[0].tabBarItem.tag, MainTabBarTag.favorites.rawValue)
        expectNoDifference(nav2.viewControllers[0].tabBarItem.tag, MainTabBarTag.links.rawValue)
    }
    
    func testTabBarDelegate() throws {
        XCTAssertNotNil(mainVC.view)
        
        // initial condition
        expectNoDifference(appEnv.defaults.mainTabBarSelection, .adoptables)

        let tabBarItem = try XCTUnwrap(mainVC.viewControllers?.last?.tabBarItem)
        mainVC.tabBar(mainVC.tabBar, didSelect: tabBarItem)
        
        expectNoDifference(appEnv.defaults.mainTabBarSelection, .links)
    }
}
