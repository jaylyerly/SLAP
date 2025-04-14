//
//  ApiTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/13/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import Testing

@Suite("Api Tests") struct ApiTests {
    
    let api: Api
    
    init() throws {
        let config = PreviewConfig()
        
        let singleData = try Data.jsonData(forFilePrefix: "animal")
        let listData = try Data.jsonData(forFilePrefix: "animals.publishable")
        
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
    }
    
    @Test func getDetail() async throws {
        
        let animal = try await api.refreshAnimal(withInternalId: "OU812")
        #expect(animal.name == "Honey")

        #expect(aboutEqual(animal.weight, 4.0962))
        #expect(aboutEqual(animal.age, 2.666666))
        
    }
    
    @Test func getList() async throws {
        
        let wrapper = try await api.refreshPublishableAnimals()
        #expect(wrapper.hasMore == false)
        #expect(wrapper.success == 1)
        #expect(wrapper.totalCount == 12)
        let animals = wrapper.animals
        #expect(animals.count == 12)

        let lastAnimal = try #require(animals.last)
        #expect(lastAnimal.name == "Romeo")
        #expect(aboutEqual(lastAnimal.age, 3.33333)).self
        #expect(lastAnimal.weight == 5.7)
        
    }
}
