//
//  Rabbit.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/28/24.
//

import CoreData

class Rabbit: NSManagedObject {}

extension Rabbit {

    var photos: [ImageModel] {
        guard let imageModels else { return [] }
        let iModels = imageModels.compactMap { $0 as? ImageModel }
        return iModels
    }
    
    var coverPhoto: ImageModel? {
        guard let imageModels else { return nil }
        return imageModels
            .compactMap { $0 as? ImageModel }
            .first { $0.isCover }
    }
}
