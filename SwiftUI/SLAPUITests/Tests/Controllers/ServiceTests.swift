//
//  ServiceTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/15/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import SwiftData
import Testing

@Suite("Service Tests") struct ServiceTests {
    
    let service: Service
    let notificationCenter: NotificationCenter
    
    init() throws {
        let api: Api = .fake()
        let storage: Storage = .fake()
        notificationCenter = NotificationCenter()
        
        service = try Service(api: api, storage: storage, notificationCenter: notificationCenter)
    }
    
    @Test func publishedAnimals() throws {
        expectNoDifference(service.publishableAnimals.count, 12)
    }
    
    @Test func favoriteAnimals() async throws {
        expectNoDifference(service.favoriteAnimals.count, 2)
        let ids = service.favoriteAnimals.map(\.internalId)
        expectNoDifference(Set(ids), Set(["63517731", "93309348"]))
    }
    
    @Test func animal() async throws {
        let animal = try #require(service.animal(withInternalId: "63517731"))
        expectNoDifference(animal.name, "Dancer")
        expectNoDifference(animal.rawAge, 22)
        expectNoDifference(animal.rawWeight, "3.1")
        expectNoDifference(animal.rawSex, "Female")
    }

    @Test func favorite() async throws {
        let animal = service.publishableAnimals[1]
        let internalId = animal.internalId
        expectNoDifference(animal.isFavorite, nil)
        
        func getIsFavorite() -> Bool {
            do {
                let animal = service.animal(withInternalId: internalId)
                let isFavorite = try #require(animal?.isFavorite as Bool?)
                return isFavorite
            } catch {
                Issue.record("Throw while getting isFavorite: \(error)")
                return false
            }
        }
        
        await service.favorite(animal)
        expectNoDifference(getIsFavorite(), true)
        
        await service.unFavorite(animal)
        expectNoDifference(getIsFavorite(), false)

        await service.favorite(animal)
        expectNoDifference(getIsFavorite(), true)
    }

    // TODO -- check that favorites calls post notifications
    
    @Test func updateAnimal() async throws {
        // Get an ID and delete that animal from storage
        let internalId = service.publishableAnimals[1].internalId
        try service.storage.delete(animalWithInternalId: internalId)
        expectNoDifference(service.animal(withInternalId: internalId), nil)
        
        // Now ask the service to update that animal (pull from api)
        let animal = try #require(await service.updateAnimal(withInternalId: internalId))
        expectNoDifference(animal.name, "Honey")
        expectNoDifference(animal.rawAge, 32)
        expectNoDifference(animal.rawWeight, "4.0962")
    }
    
    @Test func updateAnimals() async throws {
        // Delete all the animals
        try service.storage.deleteAllAnimals()
        expectNoDifference(service.publishableAnimals.count, 0)
        
        // Now ask the service to update that animal (pull from api)
        let animals = await service.updateAnimals()
        expectNoDifference(animals.count, 12)
        expectNoDifference(service.publishableAnimals.count, 12)
    }
}
