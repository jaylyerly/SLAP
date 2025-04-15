//
//  Storage_Animal.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/4/25.
//

import Foundation
import SwiftData

extension Storage {
    private var sortBy: [SortDescriptor<Animal>] {
        [SortDescriptor(\Animal.name)]
    }
    
    private func fetchDescriptor(withInternalId internalId: String) -> FetchDescriptor<Animal> {
        let predicate = #Predicate<Animal> { $0.internalId == internalId }
        let descriptor = FetchDescriptor(predicate: predicate)

        return descriptor
    }
    
    func animal(withInternalId internalId: String, context overrideContext: ModelContext? = nil) throws -> Animal? {
        let context = overrideContext ?? getContext()
        let descriptor = fetchDescriptor(withInternalId: internalId)
        let animal = try context.fetch(descriptor).first
        return animal
    }
    
    func animals(context overrideContext: ModelContext? = nil) throws -> [Animal] {
        let context = overrideContext ?? getContext()
        let descriptor = FetchDescriptor<Animal>(sortBy: sortBy)
        let animals = try context.fetch(descriptor)
        return animals
    }
    
    func favoriteAnimals() throws -> [Animal] {
        let context = getContext()
        let predicate = #Predicate<Animal> { $0.isFavorite == true }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: sortBy)
        let animals = try context.fetch(descriptor)
        return animals
    }
    
    func publishableAnimals() throws -> [Animal] {
        let context = getContext()
        let predicate = #Predicate<Animal> { $0.isPublishable == true }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: sortBy)
        let animals = try context.fetch(descriptor)
        return animals
    }

    func upsert(animals: [Animal], context overrideContext: ModelContext? = nil) throws {
        let context = overrideContext ?? getContext()
        try animals.forEach { animal in
            if let existingAnimal = try? context.fetch(fetchDescriptor(withInternalId: animal.internalId)).first {
                existingAnimal.merge(with: animal)  // overwrites fields only if not nil
            } else {
                if let modelContext = animal.modelContext {
                    // If the model already has a context, we can't insert it directly.  It must be removed
                    // from the other context.  Surely there's a better way to do this.
                    modelContext.delete(animal)
                    try modelContext.save()
                }
                context.insert(animal)
            }
        }
        if overrideContext == nil {
            try context.save()
        }
    }
    
    func upsertPublishable(animals: [Animal], context overrideContext: ModelContext? = nil) throws {
        let context = overrideContext ?? getContext()

        // Clear isPublishable flag on existing entries
        let existingAnimals = try context.fetch(FetchDescriptor<Animal>())
        existingAnimals.forEach { $0.isPublishable = false }
        
        // Set isPublishable on the new entries and upsert
        animals.forEach { $0.isPublishable = true }
        try upsert(animals: animals, context: context)
        if overrideContext == nil {
            try context.save()
        }
    }
    
    func upsert(animal: Animal, context overrideContext: ModelContext? = nil) throws {
        let context = overrideContext ?? getContext()
        
        try upsert(animals: [animal], context: context)
        
        if overrideContext == nil {
            try context.save()
        }

    }
    
    func delete(animalWithInternalId internalId: String, context overrideContext: ModelContext? = nil) throws {
        let context = overrideContext ?? getContext()
        if let animalToDelete = try animal(withInternalId: internalId, context: context) {
            context.delete(animalToDelete)
        }
        if overrideContext == nil {
            try context.save()
        }
    }
    
    func delete(animals: [Animal], context overrideContext: ModelContext? = nil) throws {
        let context = overrideContext ?? getContext()
        try animals.forEach { animal in
            try delete(animalWithInternalId: animal.internalId, context: context)
        }
        if overrideContext == nil {
            try context.save()
        }
    }
    
    func delete(animal: Animal) throws {
        try delete(animals: [animal])
    }
    
    func deleteAllAnimals(context overrideContext: ModelContext? = nil) throws {
        let context = overrideContext ?? getContext()
        
        try context.delete(model: Animal.self)
        
        if overrideContext == nil {
            try context.save()
        }
    }
    
    func setFavorite(animal inAnimal: Animal, toValue value: Bool) throws {
        let context = getContext()
        if let workingAnimal = try animal(withInternalId: inAnimal.internalId, context: context) {
            workingAnimal.isFavorite = value
            try context.save()
        } else {
            throw StorageError.animalNotFound("No animal found with internalId: \(inAnimal.internalId)")
        }
        
    }
}
