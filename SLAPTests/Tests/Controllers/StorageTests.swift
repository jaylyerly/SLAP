//
//  StorageTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import SwiftData
import XCTest

class StorageTests: TestCase {
    
    var storage: Storage!
    var fakeNC: FakeNotificationCenter!
    var rabbits = [Rabbit]()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeNC = FakeNotificationCenter()
        let modelConfig = ModelConfiguration(isStoredInMemoryOnly: true)
        storage = Storage(modelConfigurations: modelConfig, notificationCenter: fakeNC)
        
        let jsonData = try Data.jsonData(forFilePrefix: "rabbits.publishable")
        let list = try JSONDecoder().decode(RabbitList.self, from: jsonData)
        rabbits = list.animals
        expectNoDifference(rabbits.count, 12)       // sanity check
    }
    
    override func tearDownWithError() throws {
        storage = nil
        fakeNC = nil
        rabbits = []
        try super.tearDownWithError()
    }
    
    @MainActor
    func testFetchRabbits() throws {
        try rabbits.forEach { try storage.insert(rabbit: $0) }
        let rabbitIds = rabbits.map { $0.id }
        
        let fetchedRabbits = storage.rabbits
        let fetchedIds = fetchedRabbits.map { $0.id }
        expectNoDifference(Set(fetchedIds), Set(rabbitIds))
        expectNoDifference(fetchedIds.count, 12)
    }
    
    @MainActor
    func testFetchFavorites() throws {
        try rabbits.forEach { try storage.insert(rabbit: $0) }
        
        let favIndices = [2, 5, 11]     // We'll mark these as favorites
        var favIds = [String]()
        favIndices.forEach { idx in
            let rabbit = storage.rabbits[idx]
            rabbit.isFavorite = true
            favIds.append(rabbit.internalId)
        }
        
        let fetchedRabbits = storage.favorites
        let fetchedIds = fetchedRabbits.map { $0.internalId }
        expectNoDifference(Set(fetchedIds), Set(favIds))
        expectNoDifference(fetchedIds.count, 3)
    }
    
    @MainActor
    func testFetchRabbitsWithRemove() async throws {
        try rabbits.forEach { try storage.insert(rabbit: $0) }
        let rabbitIds = rabbits.map { $0.id }
        
        let fetchedRabbits = storage.rabbits
        let fetchedIds = fetchedRabbits.map { $0.id }
        expectNoDifference(Set(fetchedIds), Set(rabbitIds))
        expectNoDifference(fetchedIds.count, 12)
        
        try fetchedRabbits[0..<4].forEach { rabbit in
            try storage.delete(rabbit: rabbit)
        }
        expectNoDifference(storage.rabbits.count, 8)
        let ids = storage.rabbits.map { $0.id }
        print("rabbit ids: \(ids)")
    }
    
    func testFetchRabbitsWithRemoveNonMainActor() async throws {
        let context = storage.getContext()
        try rabbits.forEach { try storage.insert(rabbit: $0, inContext: context) }
        let rabbitIds = rabbits.map { $0.id }
        
        let fetchedRabbits = storage.rabbits(inContext: context)
        let fetchedIds = fetchedRabbits.map { $0.id }
        expectNoDifference(Set(fetchedIds), Set(rabbitIds))
        expectNoDifference(fetchedIds.count, 12)
        
        try fetchedRabbits[0..<4].forEach { rabbit in
            try storage.delete(rabbit: rabbit, inContext: context)
        }
        expectNoDifference(storage.rabbits(inContext: context).count, 8)
        let ids = storage.rabbits(inContext: context).map { $0.id }
        print("rabbit ids: \(ids)")
    }
    
    // This one fails, with the operations done in different contexts
//    func testFetchRabbitsWithRemoveRandomContext() async throws {
//        
//        try rabbits.forEach { try storage.insert(rabbit: $0, inContext: storage.getContext()) }
//        let rabbitIds = rabbits.map { $0.id }
//        
//        let fetchedRabbits = storage.rabbits(inContext: storage.getContext())
//        let fetchedIds = fetchedRabbits.map { $0.id }
//        expectNoDifference(Set(fetchedIds), Set(rabbitIds))
//        expectNoDifference(fetchedIds.count, 12)
//        
//        try fetchedRabbits[0..<4].forEach { rabbit in
//            try storage.delete(rabbit: rabbit, inContext: storage.getContext())
//        }
//        expectNoDifference(storage.rabbits(inContext: storage.getContext()).count, 8)
//        let ids = storage.rabbits(inContext: storage.getContext()).map { $0.id }
//        print("rabbit ids: \(ids)")
//    }
    
    @MainActor
    func testNotificationForSingleUpdate() async throws {
        XCTAssertNil(fakeNC.lastNotification) // initial condition
        
        do {
            let rabbit = rabbits[0]
            try storage.insert(rabbit: rabbit)
            expectNoDifference(fakeNC.lastNotification?.name, .storageDidUpdateDetail)
            let obj = try XCTUnwrap(fakeNC.lastNotification?.object as? Rabbit)
            expectNoDifference(rabbit.internalId, obj.internalId)
        }
        // reset
        fakeNC.lastNotification = nil
        
        do {
            let rabbit = rabbits[2]
            try storage.insert(rabbit: rabbit)
            expectNoDifference(fakeNC.lastNotification?.name, .storageDidUpdateDetail)
            let obj = try XCTUnwrap(fakeNC.lastNotification?.object as? Rabbit)
            expectNoDifference(rabbit.internalId, obj.internalId)
        }

    }
    
    @MainActor
    func testNotificationForListUpdate() async throws {
        XCTAssertNil(fakeNC.lastNotification) // initial condition
        
        try storage.importNewList(rabbits: rabbits)
        expectNoDifference(fakeNC.lastNotification?.name, .storageDidUpdateList)
        XCTAssertNil(fakeNC.lastNotification?.object)  // no object for list notification

    }

}
