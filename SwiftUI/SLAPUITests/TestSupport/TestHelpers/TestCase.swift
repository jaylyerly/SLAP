//
//  TestCase.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
@testable import SLAPUI
import XCTest

private let defaultTimeoutFactor = 1.0

class TestCase: XCTestCase {

    var isContinuousIntegration: Bool {
        // Xcode Cloud defines a number of environment variables,
        // including CI=TRUE
        ProcessInfo.processInfo.environment["CI"] == "TRUE"
    }

    var waitTimeout: TimeInterval { 2.0 * timeoutFactor } // seconds to wait for values to be equal

    // This the multiplier factor for increasing test timeouts on the CI server.
    // It is 3 by default unless a different value is present in the OCL_TIMEOUT_FACTOR
    // environment variable.
    let timeoutFactor: Double = {
        guard let value = ProcessInfo.processInfo.environment["OCL_TIMEOUT_FACTOR"], let factor = Double(value) else {
            return defaultTimeoutFactor
        }
        print(">>>>>> Setting the test timeout factor to \(factor). <<<<<<")
        return factor
    }()

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

}

// MARK: - time delayed asserts

extension TestCase {

    func XCTWaitUntilNotNil(_ expr: @autoclosure (() throws -> (some Any)?),
                            _ msg: @autoclosure () -> String? = "",
                            extraWaitFactor: Double = 1,
                            file: StaticString = #filePath,
                            line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilNotNil: Still nil after \(self.waitTimeout * extraWaitFactor) seconds."
        }
        try XCTWaitUntilTrue(expr() != nil,
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             file: file,
                             line: line)
    }

    func XCTWaitUntilNil(_ expr: @autoclosure (() throws -> (some Any)?),
                         _ msg: @autoclosure () -> String? = "",
                         extraWaitFactor: Double = 1,
                         file: StaticString = #filePath,
                         line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilNotNil: Still not nil after \(self.waitTimeout * extraWaitFactor) seconds."
        }
        try XCTWaitUntilTrue(expr() == nil,
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             file: file,
                             line: line)
    }

    func XCTWaitUntilNotEqual<T>(_ expr1: @autoclosure (() throws -> T),
                                 _ expr2: @autoclosure (() throws -> T),
                                 _ msg: @autoclosure () -> String? = "",
                                 extraWaitFactor: Double = 1,
                                 file: StaticString = #filePath,
                                 line: UInt = #line) rethrows where T: Equatable {
        let failureMsg: () -> String = {
            "XCTWaitUntilEqual: Still equal after in \(self.waitTimeout * extraWaitFactor) seconds"
        }
        try XCTWaitUntilTrue(expr1() != expr2(),
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             file: file,
                             line: line)
    }

    func XCTWaitUntilFalse(_ expr: @autoclosure (() throws -> Bool),
                           _ msg: @autoclosure () -> String? = "",
                           failureMessage: @autoclosure () -> String? = "",
                           extraWaitFactor: Double = 1,
                           file: StaticString = #filePath,
                           line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilFalse: Still not false after in \(self.waitTimeout * extraWaitFactor) seconds"
        }

        try XCTWaitUntilTrue(!expr(),
                             msg(),
                             failureMessage: failureMsg(),
                             extraWaitFactor: extraWaitFactor,
                             file: file,
                             line: line)
    }

    func XCTWaitUntilTrue(_ expr: @autoclosure (() throws -> Bool?),
                          _ msg: @autoclosure () -> String? = "",
                          failureMessage _: @autoclosure () -> String? = "",
                          extraWaitFactor: Double = 1,
                          file: StaticString = #filePath,
                          line: UInt = #line) rethrows {
        let failureMsg: () -> String = {
            "XCTWaitUntilTrue: Still not true after in \(self.waitTimeout * extraWaitFactor) seconds"
        }
        try XCTWaitUntilEqual(expr(),
                              true,
                              msg(),
                              failureMsg: failureMsg(),
                              extraWaitFactor: extraWaitFactor,
                              file: file,
                              line: line)
    }

    func XCTWaitUntilEqual<T>(_ expr1: @autoclosure (() throws -> T),
                              _ expr2: @autoclosure (() throws -> T),
                              _ msg: @autoclosure () -> String? = "",
                              failureMsg: @autoclosure () -> String? = "",
                              extraWaitFactor: Double = 1,
                              file: StaticString = #filePath,
                              line: UInt = #line) rethrows where T: Equatable {

        let start = Date()
        var val1 = try expr1()
        var val2 = try expr2()
        let effectiveWaitTimeout = waitTimeout * extraWaitFactor
        while val1 != val2 {
            if Date().timeIntervalSince(start) > effectiveWaitTimeout {
                var txt = failureMsg() ?? ""

                if txt.isEmpty {
                    txt = "\(val1) not equal to \(val2) after \(effectiveWaitTimeout) seconds"
                }
                txt += " "
                txt += msg() ?? ""

                // check for difference during failure
                XCTAssertNoDifference(val1, val2, txt, file: file, line: line)
                return
            }
            executeRunLoop(for: 0.01)
            val1 = try expr1()
            val2 = try expr2()
        }
    }
}

extension TestCase {

    func url(forName name: String, withExtension ext: String = "") throws -> URL {
        let bundle = Bundle(for: Self.self)
        let url = try XCTUnwrap(bundle.url(forResource: name, withExtension: ext))
        return url
    }

}
