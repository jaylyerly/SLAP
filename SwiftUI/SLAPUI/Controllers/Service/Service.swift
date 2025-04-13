//
//  Service.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/4/25.
//

import Combine
import Foundation
import OSLog

extension NSNotification.Name {
    static let didUpdateFavorites = Notification.Name("SLAP.didUpdateFavorites")
    static let didUpdateAnimals = Notification.Name("SLAP.didUpdateAnimals")
    static let didUpdateAnimal = Notification.Name("SLAP.didUpdateAnimal")
}

@Observable
class Service {
    
    static let userInfoAnimalInternalIdKey = "animalInternalId"
    
    let api: Api
    let storage: Storage
    let notificationCenter: NotificationCenter
    let logger = Logger.defaultLogger()
    
    init(api: Api? = nil, storage: Storage? = nil, notificationCenter: NotificationCenter = .default) throws {
        self.api = api ?? Api()
        self.storage = try storage ?? (try Storage())
        self.notificationCenter = notificationCenter
    }
    
}

// MARK: - Animals
extension Service {
    
    var publishableAnimals: [Animal] {
        do {
            return try storage.publishableAnimals()
        } catch {
            logger.error("Failed to get publishable animals from storage: \(error.localizedDescription)")
            return []
        }
    }
    
    private func notifyDidUpdateAnimals() {
        notificationCenter.post(name: .didUpdateAnimals, object: self)
    }
    
    private func notifyDidUpdateAnimal(_ animal: Animal) {
        notificationCenter.post(name: .didUpdateAnimal,
                                object: self,
                                userInfo: [Service.userInfoAnimalInternalIdKey: animal.internalId])
    }
    
    func animal(withInternalId internalId: String) -> Animal? {
        do {
            return try storage.animal(withInternalId: internalId)
        } catch {
            logger.error("Failed to get animal with ID: \(internalId): \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func updateAnimal(withInternalId internalId: String) async -> Animal? {
        if let animal = try? await api.refreshAnimal(withInternalId: internalId) {
            do {
                try storage.upsert(animal: animal)
                notifyDidUpdateAnimal(animal)
            } catch {
                self.logger.error("Failed to update animal: \(error.localizedDescription)")
            }
            return animal
        }
            
        return nil
    }
    
    @discardableResult
    func updateAnimals() async -> [Animal] {
        let wrapper = try? await api.refreshPublishableAnimals()
        let animals = wrapper?.animals ?? []
        do {
            try storage.upsertPublishable(animals: animals)
            notifyDidUpdateAnimals()
            animals.forEach { notifyDidUpdateAnimal($0) }
        } catch {
            logger.error("Failed to update animals: \(error.localizedDescription)")
        }
        
        return animals
    }    

}

// MARK: - Favorites
extension Service {
     
    var favoriteAnimals: [Animal] {
        do {
            return try storage.favoriteAnimals()
        } catch {
            logger.error("Failed to get favorite animals from storage: \(error.localizedDescription)")
            return []
        }
    }
    
    private func notifyDidUpdateFavorite(_ animal: Animal) {
        notificationCenter.post(name: .didUpdateFavorites,
                                object: self,
                                userInfo: [Service.userInfoAnimalInternalIdKey: animal.internalId])
    }
    
    func favorite(_ animal: Animal) async {
        do {
            try storage.setFavorite(animal: animal, toValue: true)
            notifyDidUpdateFavorite(animal)
        } catch {
            logger.error("Failed to toggle favorite: \(error.localizedDescription)")
        }
    }
    
    func unFavorite(_ animal: Animal) async {
        do {
            try storage.setFavorite(animal: animal, toValue: false)
            notifyDidUpdateFavorite(animal)
        } catch {
            logger.error("Failed to toggle favorite: \(error.localizedDescription)")
        }
    }
    
}
