//
//  ApiTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class ApiTests: TestCase {
    
    var receivedObjects = [Decodable]()
    var api: Api!
    var config = FakeConfig()

    override func setUpWithError() throws {
        try super.setUpWithError()

        let singleData = try Data.jsonData(forFilePrefix: "rabbit")
        let listData = try Data.jsonData(forFilePrefix: "rabbits.publishable")

        let singleUrl = config.apiRoot
            .appending(path: "animals")
            .appending(path: "OU812")
        let listUrl = config.apiRoot
            .appending(path: "animals")
            .appending(queryItems: [URLQueryItem(name: "status_type", value: "publishable")])
        
        UrlProtocolMock.testURLs = [
            singleUrl: singleData,
            listUrl: listData,
        ]
        
        api = Api(
            config: config,
            protocolClasses: [UrlProtocolMock.self],
            defaultSessionConfig: .ephemeral
        )
        api.delegate = self
    }
    
    override func tearDownWithError() throws {
        api = nil
        receivedObjects = []
        try super.tearDownWithError()
    }
    
    func testGetDetail() async throws {
        // initial condition
        XCTAssertTrue(receivedObjects.isEmpty)
        
        try await api.refresh(withInternalId: "OU812")
        
        expectNoDifference(receivedObjects.count, 1)
        
        let obj = try XCTUnwrap(receivedObjects.first)
        let rabbit = try XCTUnwrap(obj as? Rabbit)
        expectNoDifference(rabbit.name, "Honey")
        expectNoDifference(rabbit.age, 2)
        expectNoDifference(rabbit.weight, 4)
    }
    
    func testList() async throws {
        // initial condition
        XCTAssertTrue(receivedObjects.isEmpty)
        
        try await api.refreshList()
        
        expectNoDifference(receivedObjects.count, 12)
        
        let obj = try XCTUnwrap(receivedObjects.last)
        let rabbit = try XCTUnwrap(obj as? Rabbit)
        expectNoDifference(rabbit.name, "Romeo")
        expectNoDifference(rabbit.age, 3)
        expectNoDifference(rabbit.weight, nil)
    }

}

extension ApiTests: ApiDelegate {
    
    func api(_ api: Api, didReceive object: any Decodable) {
        receivedObjects.append(object)
    }
    
}
