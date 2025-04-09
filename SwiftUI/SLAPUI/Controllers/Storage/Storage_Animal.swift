//
//  Storage_Animal.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/4/25.
//

import Foundation
import SwiftData

extension Storage {
    
    func animal(withInternalId internalId: String) throws -> Animal? {
        let context = getContext()
        let predicate = #Predicate<Animal> { $0.internalId == internalId }
        let descriptor = FetchDescriptor(predicate: predicate)
        let animal = try context.fetch(descriptor).first
        return animal
    }
    
    func animals() throws -> [Animal] {
        let context = getContext()
        let descriptor = FetchDescriptor<Animal>()
        let animals = try context.fetch(descriptor)
        return animals
    }

    func add(animals: [Animal]) throws {
        let context = getContext()
        animals.forEach {
            context.insert($0)
        }
        try context.save()
        
    }
    
    func add(animal: Animal) throws {
        try add(animals: [animal])
    }
    
    func delete(animals: [Animal]) throws {
        let context = getContext()
        animals.forEach {
            context.delete($0)
        }
        try context.save()
    }
    
    func delete(animal: Animal) throws {
        try delete(animals: [animal])
    }
}
