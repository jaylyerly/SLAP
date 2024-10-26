//
//  TestCase.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

private let defaultTimeoutFactor = 1.0

@MainActor
class TestCase: XCTestCase {
    
    var testWindows = [UIWindow]()
    
    var waitTimeout: TimeInterval { 2.0 * timeoutFactor }      // seconds to wait for values to be equal

    // This the multiplier factor for increasing test timeouts on the CI server.
    // It is 3 by default unless a different value is present in the OCL_TIMEOUT_FACTOR
    // environment variable.
    let timeoutFactor: Double = {
        guard let value = ProcessInfo.processInfo.environment["SB_TIMEOUT_FACTOR"], let factor = Double(value) else {
            return defaultTimeoutFactor
        }
        print(">>>>>> Setting the test timeout factor to \(factor). <<<<<<")
        return factor
    }()
    
    func testWindow(withViewController viewController: UIViewController,
                    appEnv: AppEnv = .testEnv(),
                    shouldWrapInNavController wrap: Bool = false,
                    frame: CGRect = .zero) -> UIWindow {
        
        let window = UIWindow(frame: frame)
        testWindows.append(window)
        
        guard let scene = (UIApplication.shared.connectedScenes
                            .first { $0 is UIWindowScene }),
              let windowScene = scene as? UIWindowScene else {
                  XCTFail("Can't get current window scene")
                  return window
              }
        
        window.windowScene = windowScene
        window.makeKeyAndVisible()
        if wrap {
            let navVC = UINavigationController(rootViewController: viewController)
            window.rootViewController = navVC
        } else {
            window.rootViewController = viewController
        }
        
        // Make sure the view controller gets loaded
        XCTAssertNotNil(viewController.view)
        
        return window
    }
    
    override func waitForExpectations(timeout: TimeInterval, handler: (@Sendable (Error?) -> Void)? = nil) {
        super.waitForExpectations(timeout: timeout * timeoutFactor, handler: handler)
    }
    
    override func wait(for expectations: [XCTestExpectation], timeout seconds: TimeInterval) {
        super.wait(for: expectations, timeout: seconds * timeoutFactor)
    }
    
    override func wait(for expectations: [XCTestExpectation],
                       timeout seconds: TimeInterval,
                       enforceOrder enforceOrderOfFulfillment: Bool) {
        super.wait(for: expectations, timeout: seconds * timeoutFactor, enforceOrder: enforceOrderOfFulfillment)
    }
    
    func executeRunLoop(for timeout: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(timeout * timeoutFactor))
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // make linter happy with balanced setup / teardown
        XCTAssertTrue(testWindows.isEmpty)
    }
    
    override func tearDownWithError() throws {
        testWindows.forEach { $0.clearWindow() }
        testWindows.removeAll()
        try super.tearDownWithError()
    }
    
}

// MARK: - time delayed asserts
extension TestCase {
    
    func XCTWaitUntilNotNil<T>(_ expr: @autoclosure (() throws -> T?),
                               _ msg: @autoclosure () -> String? = "",
                               extraWaitFactor: Double = 1,
                               fileID: StaticString = #fileID,
                               filePath: StaticString = #filePath,
                               line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilNotNil: Still nil after \(self.waitTimeout * extraWaitFactor) seconds."
        }
        try XCTWaitUntilTrue(expr() != nil,
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             fileID: fileID,
                             filePath: filePath,
                             line: line)
    }
    
    func XCTWaitUntilNil<T>(_ expr: @autoclosure (() throws -> T?),
                            _ msg: @autoclosure () -> String? = "",
                            extraWaitFactor: Double = 1,
                            fileID: StaticString = #fileID,
                            filePath: StaticString = #filePath,
                            line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilNotNil: Still not nil after \(self.waitTimeout * extraWaitFactor) seconds."
        }
        try XCTWaitUntilTrue(expr() == nil,
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             fileID: fileID,
                             filePath: filePath,
                             line: line)
    }
    
    func XCTWaitUntilNotEqual<T>(_ expr1: @autoclosure (() throws -> T),
                                 _ expr2: @autoclosure (() throws -> T),
                                 _ msg: @autoclosure () -> String? = "",
                                 extraWaitFactor: Double = 1,
                                 fileID: StaticString = #fileID,
                                 filePath: StaticString = #filePath,
                                 line: UInt = #line) rethrows where T: Equatable {
        let failureMsg: () -> String = {
            "XCTWaitUntilEqual: Still equal after in \(self.waitTimeout * extraWaitFactor) seconds"
        }
        try XCTWaitUntilTrue(expr1() != expr2(),
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             fileID: fileID,
                             filePath: filePath,
                             line: line)
    }
    
    func XCTWaitUntilFalse(_ expr: @autoclosure (() throws -> Bool),
                           _ msg: @autoclosure () -> String? = "",
                           failureMessage: @autoclosure () -> String? = "",
                           extraWaitFactor: Double = 1,
                           fileID: StaticString = #fileID,
                           filePath: StaticString = #filePath,
                           line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilFalse: Still not false after in \(self.waitTimeout * extraWaitFactor) seconds"
        }
        
        try XCTWaitUntilTrue(!expr(),
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             fileID: fileID,
                             filePath: filePath,
                             line: line)
    }
    
    func XCTWaitUntilTrue(_ expr: @autoclosure (() throws -> Bool?),
                          _ msg: @autoclosure () -> String? = "",
                          failureMessage: @autoclosure () -> String? = "",
                          extraWaitFactor: Double = 1,
                          fileID: StaticString = #fileID,
                          filePath: StaticString = #filePath,
                          line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilTrue: Still not true after in \(self.waitTimeout * extraWaitFactor) seconds"
        }
        try XCTWaitUntilEqual(expr(),
                              true,
                              msg(),
                              failureMsg: failureMsg(),
                              extraWaitFactor: extraWaitFactor,
                              fileID: fileID,
                              filePath: filePath,
                              line: line)
    }
    
    func XCTWaitUntilEqual<T>(_ expr1: @autoclosure (() throws -> T),
                              _ expr2: @autoclosure (() throws -> T),
                              _ msg: @autoclosure () -> String? = "",
                              failureMsg: @autoclosure () -> String? = "",
                              extraWaitFactor: Double = 1,
                              fileID: StaticString = #fileID,
                              filePath: StaticString = #filePath,
                              line: UInt = #line) rethrows where T: Equatable {
        
        let start = Date()
        var val1 = try expr1()
        var val2 = try expr2()
        let effectiveWaitTimeout = waitTimeout * extraWaitFactor
        while val1 != val2 {
            if Date().timeIntervalSince(start) > (effectiveWaitTimeout) {
                var txt = failureMsg() ?? ""
                
                if txt.isEmpty {
                    txt = "\(val1) not equal to \(val2) after \(effectiveWaitTimeout) seconds"
                }
                txt += " "
                txt += msg() ?? ""
                
                // check for difference during failure
                expectNoDifference(val1, val2, txt, fileID: fileID, filePath: filePath, line: line)
                return
            }
            executeRunLoop(for: 0.01)
            val1 = try expr1()
            val2 = try expr2()
        }
    }
}

// MARK: - UIImage comparison
extension TestCase {
    
    func XCTAssertImagesMatch(_ image1: UIImage?,
                              _ image2: UIImage?,
                              accuracy: Double = 0.01,
                              fileID: StaticString = #fileID,
                              filePath: StaticString = #filePath,
                              line: UInt = #line) {
        guard let image1, let image2 else {
            XCTFail("Image is nil!", file: filePath, line: line)
            return
        }
        let norm1 = image1.pngNormalizedImage
        let norm2 = image2.pngNormalizedImage
        let scale = UIScreen.main.scale
        expectNoDifference(norm1.size,
                           norm2.size,
                           "Image size mismatch at scale: \(scale)",
                           fileID: fileID,
                           filePath: filePath,
                           line: line)
        guard let diff = norm1.compare(toImage: norm2) else {
            XCTFail("Unable to compare images.", file: filePath, line: line)
            return
        }
        XCTAssertLessThan(diff, accuracy, file: filePath, line: line)
    }
    
}

extension TestCase {
    
    func url(forName name: String, withExtension ext: String = "") throws -> URL {
        let bundle = Bundle(for: Self.self)
        let url = try XCTUnwrap(bundle.url(forResource: name, withExtension: ext))
        return url
    }
    
}
