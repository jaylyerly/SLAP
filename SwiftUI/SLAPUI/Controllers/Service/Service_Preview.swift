//
//  Service_Preview.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/9/25.
//

import Foundation
import OSLog

extension Service {
        
    static let preview: Service = {
        do {
            let api = Api(config: .preview)
            let storage = try Storage(inMemoryOnly: true)
            
            var animals = Animal.previewAnimals
            animals.forEach { $0.isPublishable = true }
            animals.first?.isFavorite = true
            animals.last?.isFavorite = true

            try storage.upsert(animals: animals)
            let service = try Service(api: api, storage: storage)
            return service
        } catch {
            fatalError("Unable to create preview service: \(error)")
        }
    }()
    
}
