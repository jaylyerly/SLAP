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
    var receivedObjectLists = [[Decodable]]()   // yes, a list of lists
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
        
        XCTWaitUntilEqual(receivedObjects.count, 1)
        XCTWaitUntilEqual(receivedObjectLists.count, 0)

        let obj = try XCTUnwrap(receivedObjects.first)
        let rabbit = try XCTUnwrap(obj as? RabbitStruct)
        expectNoDifference(rabbit.name, "Honey")
        XCTAssertEqual(try XCTUnwrap(rabbit.age), 2.666666, accuracy: 0.0001)
        expectNoDifference(rabbit.weight, 4.0962)
    }
    
    func testList() async throws {
        // initial condition
        XCTAssertTrue(receivedObjects.isEmpty)
        
        try await api.refreshList()
        
        XCTWaitUntilEqual(receivedObjects.count, 0)
        XCTWaitUntilEqual(receivedObjectLists.count, 1)
        let receivedList = try XCTUnwrap(receivedObjectLists.first)

        expectNoDifference(receivedList.count, 12)
        
        let obj = try XCTUnwrap(receivedList.last)
        let rabbit = try XCTUnwrap(obj as? RabbitStruct)
        expectNoDifference(rabbit.name, "Romeo")
        XCTAssertEqual(try XCTUnwrap(rabbit.age), 3.33333, accuracy: 0.0001)
        expectNoDifference(rabbit.weight, nil)
    }

}

extension ApiTests: ApiDelegate {
    
    func api(_ api: Api, didReceive object: any Decodable, forEndpointName name: EndpointName) {
        receivedObjects.append(object)
    }
    
    func api(_ api: Api, didReceiveList objects: [any Decodable], forEndpointName name: EndpointName) {
        receivedObjectLists.append(objects)
    }
        
}
