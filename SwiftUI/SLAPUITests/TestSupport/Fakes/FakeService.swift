//
//  FakeService.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
@testable import SLAPUI

class FakeService: Service {
    
    var lastUpdateAnimalWithInternalId: String?
    var lastFetchedAnimalWithInternalId: String?
    var didUpdateAnimals = false
    var lastFavoriteAnimal: Animal?
    var lastUnFavoriteAnimal: Animal?
    
    override func animal(withInternalId internalId: String) -> Animal? {
        lastFetchedAnimalWithInternalId = internalId
        return super.animal(withInternalId: internalId)
    }
    
    override func updateAnimal(withInternalId internalId: String) async -> Animal? {
        lastUpdateAnimalWithInternalId = internalId
        return await super.updateAnimal(withInternalId: internalId)
    }
    
//    override func updateAnimals() async -> [Animal] {
//        didUpdateAnimals = true
//        return await super.updateAnimals()
//    }
    
    override func favorite(_ animal: Animal) async {
        lastFavoriteAnimal = animal
        await super.favorite(animal)
    }
    
    override func unFavorite(_ animal: Animal) async {
        lastUnFavoriteAnimal = animal
        await super.unFavorite(animal)
    }
}

extension Service {
    
    static func fake(notificationCenter: NotificationCenter) -> FakeService {
        try! FakeService(api: .fake(), storage: .fake(), notificationCenter: notificationCenter)
    }
    
}

