//
//  RabbitEndpointTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class RabbitEndpointTests: TestCase {
    
    var baseUrl = FakeConfig().apiRoot
    var baseUrlString: String { baseUrl.absoluteString }

    func testUrl() throws {
        let endpoint = Rabbit.detail(forId: "OU812")
        let expectedUrlString = "\(baseUrlString)animals/OU812"
        expectNoDifference(endpoint.url(forBaseUrl: baseUrl).absoluteString, expectedUrlString)
    }
    
    func testParse() throws {
        let jsonData = try Data.jsonData(forFilePrefix: "rabbit")
        let endpoint = Rabbit.detail(forId: "OU812")
        let rabbit = try endpoint.parse(data: jsonData)

        // Spot check results
        expectNoDifference(rabbit.name, "Honey")
        expectNoDifference(rabbit.age, 2)
        expectNoDifference(rabbit.weight, 4)
    }
    
}
