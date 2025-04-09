//
//  TestDriver.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/8/25.
//

import Foundation
import SwiftUI

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            Text("I'm running tests!")
        }
    }
}

@main
enum TestDriver {
    static func main() { // swiftlint:disable:this unused_declaration
        if NSClassFromString("XCTestCase") != nil {
            TestApp.main()
        } else {
            SLAPUIApp.main()
        }
    }
}
