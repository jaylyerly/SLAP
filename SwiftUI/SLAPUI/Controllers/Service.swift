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
    
    var animals: [Animal] {
        do {
            return try storage.animals()
        } catch {
            logger.error("Failed to get animals from storage: \(error.localizedDescription)")
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
                try storage.add(animal: animal)
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
        let wrapper = try? await api.refreshAnimals()
        let animals = wrapper?.animals ?? []
        do {
            try storage.add(animals: animals)
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
     
    var favorites: [Animal] {
        fatalError("Favorites not implemented yet")
//        do {
//            return try storage.favorites()
//        } catch {
//            logger.error("Failed to get favorites from storage: \(error.localizedDescription)")
//            return []
//        }
    }
    
    private func notifyDidUpdateFavorite(_ animal: Animal) {
        notificationCenter.post(name: .didUpdateFavorites,
                                object: self,
                                userInfo: [Service.userInfoAnimalInternalIdKey: animal.internalId])
    }
    
    @discardableResult
    func toggleFavorite(withInternalId internalId: String) async -> Animal? {
        if let animal = try? await api.refreshAnimal(withInternalId: internalId) {
            do {
                try storage.add(animal: animal)
                notifyDidUpdateFavorite(animal)
            } catch {
                self.logger.error("Failed to update animal: \(error.localizedDescription)")
            }
            return animal
        }
            
        return nil
    }
    
}
