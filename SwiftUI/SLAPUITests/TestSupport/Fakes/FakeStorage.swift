//
//  FakeStorage.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
@testable import SLAPUI

class FakeStorage: Storage {
    
}

extension Storage {
    
    static func fake(loadData: Bool = true) -> FakeStorage {
        let storage = try! FakeStorage(inMemoryOnly: true)
        
        if loadData {
            let animals = Animal.previewAnimals
            animals.forEach { $0.isPublishable = true }
            animals.first?.isFavorite = true
            animals.last?.isFavorite = true
            
            try! storage.upsert(animals: animals)
        }
        
        return storage
    }
    
}
