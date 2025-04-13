//
//  AnimalWrapperEndpointsTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/13/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import Testing

@Suite("Animal Wrapper Endpoints Tests") struct AnimalWrapperEndpointsTests {

    let config: Config
    let baseUrl: URL
    let baseUrlString: String
    
    init() throws {
        config = PreviewConfig()
        baseUrl = config.apiRoot
        baseUrlString = baseUrl.absoluteString
    }

    @Test func checkUrl() throws {
        let endpoint = AnimalWrapper.publishable()
        let expectedUrlString = "\(baseUrlString)animals?status_type=publishable"
        expectNoDifference(endpoint.url(forBaseUrl: baseUrl).absoluteString, expectedUrlString)
    }

    @Test func checkParse() throws {
        let jsonData = try Data.jsonData(forFilePrefix: "animals.publishable")
        let endpoint = AnimalWrapper.publishable()
        let list = try endpoint.parse(data: jsonData)

        // Spot check results
        #expect(list.success == 1)
        #expect(list.hasMore == false)
        #expect(list.totalCount == 12)
        #expect(list.animals.count == 12)
    }
    
}
