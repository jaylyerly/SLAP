//
//  StorageTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/11/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import SwiftData
import Testing

@Suite("Storage Tests") struct StorageTests {
    
    let storage: Storage
    let referenceAnimals: [Animal]
    
    init() throws {
        let jsonData = try Data.jsonData(forFilePrefix: "animals.publishable")
        let wrapper = try JSONDecoder().decode(AnimalWrapper.self, from: jsonData)
        referenceAnimals = wrapper.animals
        
        storage = try Storage(inMemoryOnly: true)
        
        try storage.upsertPublishable(animals: referenceAnimals)
    }
    
    @Test func validateInitialConditions() throws {
        let animals = try storage.animals()
        let publishedAnimals = try storage.publishableAnimals()
        let favoriteAnimals = try storage.favoriteAnimals()
        
        // Total animal count should be the same as the reference set.
        #expect(animals.count == referenceAnimals.count)
        
        // All the reference animals should be loaded as publishable
        #expect(publishedAnimals.count == referenceAnimals.count)
        
        // No favs to start
        #expect(favoriteAnimals.isEmpty)
    }
    
    @Test func checkPublishedFlagClears() throws {
        // Pretend we got two published animals from the API
        let newAnimals = [referenceAnimals[0], referenceAnimals[1]]
        
        try storage.upsertPublishable(animals: newAnimals)
        
        // Now there should only be two animals in the published set
        #expect(try storage.publishableAnimals().count == 2)
        
        // But the total count should still be the same
        #expect(try storage.animals().count == referenceAnimals.count)
        
        // And still no favs
        #expect(try storage.favoriteAnimals().isEmpty)
    }
    
    @Test func checkFavoriting() async throws {
        #expect(try storage.favoriteAnimals().isEmpty)

        let favAnimal = referenceAnimals[0]
        try storage.setFavorite(animal: favAnimal, toValue: true)
        
        #expect(try storage.favoriteAnimals().count == 1)
        let newAnimal = try #require(try storage.animal(withInternalId: favAnimal.internalId))
        let isFav = try #require(newAnimal.isFavorite as Bool?)
        #expect(isFav)
        #expect(try storage.favoriteAnimals()[0].id == favAnimal.id)
    }
    
    @Test func checkDelete() async throws {
        let animals = try storage.animals()
        #expect(animals.count == 12)
        
        for idx in 0..<4 {
            try storage.delete(animal: animals[idx])
        }
        
        expectNoDifference(try storage.animals().count, 8)
        
        try storage.delete(animals: animals)
        
        expectNoDifference(try storage.animals().isEmpty, true)
    }
    
    @Test func checkUpsert() async throws {
        // Nuke all existing animals
        try storage.deleteAllAnimals()
        expectNoDifference(try storage.animals().count, 0)

        let animal = referenceAnimals[0]
        let name = animal.name
        
        // Insert into DB
        try storage.upsert(animal: animal)
        
        // Now there should be one animal
        expectNoDifference(try storage.animals().count, 1)
        expectNoDifference(try storage.animals().first?.name, name)
        
        // Insert again
        try storage.upsert(animal: animal)

        // Now there should still be one animal
        expectNoDifference(try storage.animals().count, 1)
        expectNoDifference(try storage.animals().first?.name, name)
        
        // Create a new animal as though it has come from the API, same ID, but new name and no context
        let newAnimal = Animal(internalId: animal.internalId, name: "TopKnot")
        try storage.upsert(animal: newAnimal)
        
        // Still one animal, but new name
        expectNoDifference(try storage.animals().count, 1)
        expectNoDifference(try storage.animals().first?.name, "TopKnot")
    }
    
}
