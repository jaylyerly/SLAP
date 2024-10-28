//
//  RabbitListEndpointTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import SwiftData
import XCTest

class RabbitListEndpointTests: TestCase {
    
    let modelContainer = try! ModelContainer(for: Rabbit.self)

    var baseUrl = FakeConfig().apiRoot
    var baseUrlString: String { baseUrl.absoluteString }
    
    func testUrl() throws {
        let endpoint = RabbitList.publishable()
        let expectedUrlString = "\(baseUrlString)animals?status_type=publishable"
        expectNoDifference(endpoint.url(forBaseUrl: baseUrl).absoluteString, expectedUrlString)
    }
    
    func testParse() throws {
        let jsonData = try Data.jsonData(forFilePrefix: "rabbits.publishable")
        let endpoint = RabbitList.publishable()
        let list = try endpoint.parse(data: jsonData)

        // Spot check results
        expectNoDifference(list.success, 1)
        expectNoDifference(list.hasMore, false)
        expectNoDifference(list.totalCount, 12)
        expectNoDifference(list.animals.count, 12)
    }
    
}
