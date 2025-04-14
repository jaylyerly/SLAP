//
//  AnimalWrapperTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/3/25.
//

import Foundation
import Testing

@testable import SLAPUI

@Suite("Animal Wrappr Model Tests") struct AnimalWrapperTests {
    
    let listJson: Data
    let wrapper: AnimalWrapper
    
    init() throws {
        listJson = try Data.jsonData(forFilePrefix: "animals.publishable")
        wrapper = try JSONDecoder().decode(AnimalWrapper.self, from: listJson)
    }
    
    @Test func parseAnimalWrapper() throws {
        #expect(wrapper.success == 1)
        #expect(wrapper.totalCount == 12)
        #expect(wrapper.hasMore == false)
        #expect(wrapper.animals.count == 12)
    }
    
}
