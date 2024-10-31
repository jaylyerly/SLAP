//
//  StorageAPITests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/30/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class StorageAPITests: TestCase {
    
    var appEnv: AppEnv!
    var storage: Storage!
    var smallRabbitList = [RabbitStruct]()
    var bigRabbitList = [RabbitStruct]()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // FakeStorage is just in-memory storage
        storage = FakeStorage()
        appEnv = .fake(storage: storage)
        
        let smallJsonData = try Data.jsonData(forFilePrefix: "rabbits.publishable")
        let smallSet = try JSONDecoder().decode(RabbitList.self, from: smallJsonData)
        smallRabbitList = smallSet.animals
        expectNoDifference(smallRabbitList.count, 12)       // sanity check
        
        let bigJsonData = try Data.jsonData(forFilePrefix: "rabbits")
        let bigSet = try JSONDecoder().decode(RabbitList.self, from: bigJsonData)
        bigRabbitList = bigSet.animals
        expectNoDifference(smallRabbitList.count, 12)       // sanity check
        
    }
    
    override func tearDownWithError() throws {
        appEnv = nil
        storage = nil
        smallRabbitList = []
        bigRabbitList = []
        try super.tearDownWithError()
    }
    
    func testClearingOldRabbits() throws {
        bigRabbitList.forEach { storage.upsert(rabbitStruct: $0, isPublished: true) }
        expectNoDifference(storage.publishedRabbits.count, 100)
        
        // Pretend we got the small list from the API.
        // This should remove all rabbits but the 12 in the small list
        storage.api(appEnv.api, didReceiveList: smallRabbitList, forEndpointName: RabbitList.publishableEndpointName)
        
        expectNoDifference(storage.publishedRabbits.count, 12)
        expectNoDifference(storage.rabbits.count, 12)

        // And now go back the other way.
        storage.api(appEnv.api, didReceiveList: bigRabbitList, forEndpointName: RabbitList.publishableEndpointName)
        
        expectNoDifference(storage.publishedRabbits.count, 100)
        expectNoDifference(storage.rabbits.count, 100)
    }
    
    func testClearingOldRabbitsWithFavorites() throws {
        bigRabbitList.forEach { storage.upsert(rabbitStruct: $0, isPublished: true) }
        expectNoDifference(storage.publishedRabbits.count, 100)
        
        // Set three rabbits as favorites so these three should always hang around
        let rabbits = storage.rabbits
        try storage.toggle(favoriteRabbit: rabbits[0])
        try storage.toggle(favoriteRabbit: rabbits[1])
        try storage.toggle(favoriteRabbit: rabbits[2])
        
        // Pretend we got the small list from the API.
        // This should remove all rabbits but the 12 in the small list
        storage.api(appEnv.api, didReceiveList: smallRabbitList, forEndpointName: RabbitList.publishableEndpointName)
        
        // 12 published rabbits + 3 favorites for 15 total
        expectNoDifference(storage.publishedRabbits.count, 12)
        expectNoDifference(storage.rabbits.count, 15)

        // And now go back the other way.
        storage.api(appEnv.api, didReceiveList: bigRabbitList, forEndpointName: RabbitList.publishableEndpointName)
        
        // Now everyone is published and there are 100 total including the 3 favs
        expectNoDifference(storage.publishedRabbits.count, 100)
        expectNoDifference(storage.rabbits.count, 100)
    }
    
}
