//
//  SexTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/15/25.
//

import Foundation
@testable import SLAPUI
import Testing

@Suite("Sex Tests") struct SexTests {
    
    @Test func parsing() throws {
        #expect(Sex(str: "M") == .male)
        #expect(Sex(str: "F") == .female)
        #expect(Sex(str: "X") == .unknown)
        #expect(Sex(str: "") == .unknown)
        #expect(Sex(str: "m") == .male)
        #expect(Sex(str: "f") == .female)
        #expect(Sex(str: "Male") == .male)
        #expect(Sex(str: "Female") == .female)
        #expect(Sex(str: "male") == .male)
        #expect(Sex(str: "female") == .female)
        #expect(Sex(str: "u") == .unknown)
        #expect(Sex(str: "unknown") == .unknown)
        #expect(Sex(str: "U") == .unknown)
        #expect(Sex(str: "Unknown") == .unknown)

    }
    
}
