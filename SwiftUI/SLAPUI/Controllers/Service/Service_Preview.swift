//
//  Service_Preview.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/9/25.
//

import Foundation
import OSLog

extension Service {
    
//    private static let previewAnimals: [Animal] = {
//        guard let url = Bundle.main.url(forResource: "animals.publishable", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let wrapper = try? JSONDecoder().decode(AnimalWrapper.self, from: data) else {
//            return []
//        }
//
//        return wrapper.animals
//    }()
    
    static let preview: Service = {
        do {
            let api = Api(config: .preview)
            let storage = try Storage(inMemoryOnly: true)
            try storage.add(animals: Animal.previewAnimals)
            let service = try Service(api: api, storage: storage)
            return service
        } catch {
            fatalError("Unable to create preview service: \(error)")
        }
    }()
    
}
