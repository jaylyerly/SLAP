//
//  AlertTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/31/24.
//

import CustomDump
@testable import SLAP
import XCTest

class AlertTests: TestCase {
    
    var alert: Alert!
    var window: UIWindow!
    
    var viewController: UIViewController {
        window.rootViewController!
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        alert = Alert()
        window = testWindow(withViewController: UIViewController(), shouldWrapInNavController: false)
    }
    
    override func tearDownWithError() throws {
        alert = nil
        window.rootViewController = nil
        window = nil
        try super.tearDownWithError()
    }
    
    func testDisplayErrorWithMessageWithDefaults() {
        XCTAssertNil(viewController.presentedViewController as? UIAlertController)
        alert.displayErrorWithMessage(
            "D'oh!",
            presentingViewController: viewController
        )
        let alert = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Alert")
        XCTAssertEqual(alert?.message, "D'oh!")
        XCTAssertEqual(alert?.actions.count, 1)
        XCTAssertEqual(alert?.actions.first?.title, "OK")
        alert?.dismiss(animated: false)
    }
    
    func testDisplayErrorWithMessageWithArgs() {
        XCTAssertNil(viewController.presentedViewController as? UIAlertController)
        alert.displayErrorWithMessage(
            "Something broke!",
            title: "Whoops!",
            presentingViewController: viewController
        )
        let alert = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.actions.count, 1)
        XCTAssertEqual(alert?.actions.first?.title, "OK")
        XCTAssertEqual(alert?.title, "Whoops!")
        XCTAssertEqual(alert?.message, "Something broke!")        
        alert?.dismiss(animated: false)
    }
    
    func testDisplayError() {
        XCTAssertNil(viewController.presentedViewController as? UIAlertController)
        let error = GenericError(reason: "Something broke!")
        alert.display(error, presenter: viewController)
        let alert = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.actions.count, 1)
        XCTAssertEqual(alert?.actions.first?.title, "OK")
        XCTAssertEqual(alert?.title, "Error")
        XCTAssertEqual(alert?.message, "Something broke!")
        alert?.dismiss(animated: false)
    }
    
}
