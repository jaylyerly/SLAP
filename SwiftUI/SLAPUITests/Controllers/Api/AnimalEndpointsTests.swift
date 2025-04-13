//
//  AnimalEndpointTests.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/13/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import Testing


@Suite("Animal Endpoints Tests") struct AnimalEndpointsTests {

    let config: Config
    let baseUrl: URL
    let baseUrlString: String
    
    init() throws {
        config = PreviewConfig()
        baseUrl = config.apiRoot
        baseUrlString = baseUrl.absoluteString
    }

    @Test func checkUrl() throws {
        let endpoint = Animal.detail(forId: "OU812")
        let expectedUrlString = "\(baseUrlString)animals/OU812"
        expectNoDifference(endpoint.url(forBaseUrl: baseUrl).absoluteString, expectedUrlString)
    }

    @Test func checkParse() throws {
        let jsonData = try Data.jsonData(forFilePrefix: "animal")
        let endpoint = Animal.detail(forId: "OU812")
        let animal = try endpoint.parse(data: jsonData)
        
        #expect(animal.name == "Honey")
        #expect(aboutEqual(animal.age, 2.666666))
        #expect(aboutEqual(animal.weight, 4.0962))
    }
    
}

