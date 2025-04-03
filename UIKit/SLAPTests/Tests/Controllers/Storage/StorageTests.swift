//
//  StorageTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class StorageTests: TestCase {
    
    var storage: Storage!
    var jsonRabbits = [RabbitStruct]()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // FakeStorage is just in-memory storage
        storage = FakeStorage()
        
        let jsonData = try Data.jsonData(forFilePrefix: "rabbits.publishable")
        let list = try JSONDecoder().decode(RabbitList.self, from: jsonData)
        jsonRabbits = list.animals
        expectNoDifference(jsonRabbits.count, 12)       // sanity check
    }
    
    override func tearDownWithError() throws {
        storage = nil
        jsonRabbits = []
        try super.tearDownWithError()
    }
    
    func testFetchRabbits() throws {
        jsonRabbits.forEach { storage.upsert(rabbitStruct: $0) }
        let jsonIds = jsonRabbits.map { $0.internalId }
        
        let rabbits = storage.rabbits
        let ids = rabbits.map { $0.internalId }
        expectNoDifference(Set(jsonIds), Set(ids))
        expectNoDifference(ids.count, 12)
    }
    
    func testFetchFavorites() throws {
        jsonRabbits.forEach { storage.upsert(rabbitStruct: $0) }

        let favIndices = [2, 5, 11]     // We'll mark these as favorites
        var favIds = [String]()
        try favIndices.forEach { idx in
            let rabbit = storage.rabbits[idx]
            try storage.toggle(favoriteRabbit: rabbit)
            if let rid = rabbit.internalId {
                favIds.append(rid)
            }
        }
        
        let fetchedIds = storage.favoriteRabbits.compactMap { $0.internalId }
        expectNoDifference(Set(fetchedIds), Set(favIds))
        expectNoDifference(fetchedIds.count, 3)
    }
    
    @MainActor
    func testFetchRabbitsWithRemove() async throws {
        jsonRabbits.forEach { storage.upsert(rabbitStruct: $0) }
        let jsonIds = jsonRabbits.map { $0.internalId }
        
        let rabbits = storage.rabbits
        var ids = Set(rabbits.map { $0.internalId })
        expectNoDifference(Set(ids), Set(jsonIds))
        expectNoDifference(ids.count, 12)
        
        try rabbits[0..<4].forEach { rabbit in
            ids.remove(rabbit.internalId)
            try storage.delete(rabbit)
        }
        expectNoDifference(storage.rabbits.count, 8)
        expectNoDifference(ids, Set(storage.rabbits.compactMap { $0.internalId }))
    }
    
}
