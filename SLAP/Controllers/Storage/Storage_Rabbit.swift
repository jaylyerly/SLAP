//
//  Storage_Rabbit.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/28/24.
//

import CoreData
import Foundation
import UIKit

typealias RabbitResult = Result<Rabbit, Error>

extension Storage {
    var rabbits: [Rabbit] {
        rabbits(fromContext: persistentContainer.viewContext)
    }
    
    func rabbits(fromContext context: NSManagedObjectContext,
                 withPredicate predicate: NSPredicate? = nil) -> [Rabbit] {
        let fetchRequest: NSFetchRequest<Rabbit> = Rabbit.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
//            return try persistentContainer.viewContext.fetch(fetchRequest)
            return try context.fetch(fetchRequest)
        } catch {
            logger.error("Failed to fetch rabbits: \(error)")
            return []
        }

    }
    
    var favoritePredicate: NSPredicate {
        NSPredicate(format: "%K == %d", #keyPath(Rabbit.isFavorite), true)
    }
    
    var favoriteRabbits: [Rabbit] {
        rabbits(fromContext: persistentContainer.viewContext, withPredicate: favoritePredicate)
//        let req = Rabbit.fetchRequest()
//        req.predicate = NSPredicate(format: "%K == %d", #keyPath(Rabbit.isFavorite), true)
//
//        do {
//            return try persistentContainer.viewContext.fetch(req)
//        } catch {
//            logger.error("Failed to fetch fav rabbits: \(error)")
//            return []
//        }
    }
    
    var publishedPredicate: NSPredicate {
        NSPredicate(format: "%K == %d", #keyPath(Rabbit.isPublished), true)
    }
    
    var publishedRabbits: [Rabbit] {
        rabbits(fromContext: persistentContainer.viewContext, withPredicate: publishedPredicate)

//        let req = Rabbit.fetchRequest()
//        req.predicate = NSPredicate(format: "%K == %d", #keyPath(Rabbit.isPublished), true)
//
//        do {
//            return try persistentContainer.viewContext.fetch(req)
//        } catch {
//            logger.error("Failed to fetch published rabbits: \(error)")
//            return []
//        }
    }
    
    func toggle(favoriteRabbit rabbit: Rabbit?) throws {
        guard let rabbit else { return }
        rabbit.isFavorite.toggle()
        try save(failureMessage: "Failed to save Rabbit")
    }
    
    func rabbit(withInternalId internalId: String,
                context: NSManagedObjectContext? = nil) throws -> Rabbit {
        let context = context ?? persistentContainer.viewContext
        let req = Rabbit.fetchRequest()
        req.predicate = NSPredicate(format: "%K == %@",
                                    #keyPath(Rabbit.internalId),
                                    internalId as CVarArg)
        let rabbits = try context.fetch(req)
        
        if rabbits.isEmpty { throw StorageError.notFound }
        if rabbits.count > 1 { throw StorageError.foundTooMany }
        return rabbits[0]
    }
    
    func rabbit(withId objId: NSManagedObjectID) throws -> Rabbit {
        try object(with: objId, type: Rabbit.self)
    }
    
    @discardableResult
    func upsert(
        rabbitStruct rStruct: RabbitStruct?,
        isPublished: Bool? = nil,
        context: NSManagedObjectContext? = nil,
        save doSave: Bool = true
    ) -> RabbitResult {
        guard let rStruct else { return .failure(StorageError.inputIsNil) }
        
        let context = context ?? persistentContainer.viewContext
        
        // Update an existing rabbit with the same ID, otherwise,
        // make a new one.
        let theRabbit: Rabbit
        do {
            theRabbit = try rabbit(withInternalId: rStruct.internalId, context: context)
        } catch {
            theRabbit = Rabbit(context: context)
        }
        
        theRabbit.internalId = rStruct.internalId
        theRabbit.sex = rStruct.sex.rawValue
        if let age = rStruct.age {
            theRabbit.age = Float(age)
        }
        theRabbit.altered = rStruct.altered
        theRabbit.name = rStruct.name
        theRabbit.rabbitDescription = rStruct.rabbitDescription
        if let weight = rStruct.weight {
            theRabbit.weight = Float(weight)
        }
        
        if let isPublished {
            theRabbit.isPublished = isPublished
        }
        
        return RabbitResult {
            let coverPhotoUrl = rStruct.coverPhoto?.absoluteString
            
            // Make a list of all the photo URLs (cover + photos) from JSON
            var rUrls = Set(rStruct.photos.compactMap { $0.absoluteString })
            if let coverPhotoUrl {
                rUrls.insert(coverPhotoUrl)
            }
            
            // Make a list of all the core data photo urls
            let tUrls = Set(theRabbit.photos.compactMap { $0.url })
            
            let addUrls = rUrls.subtracting(tUrls)   // urls that need adding
            let delUrls = tUrls.subtracting(rUrls)   // urls to be delete
            
            // Delete photos in delUrls
            theRabbit.photos.forEach { obj in
                if let url = obj.url, delUrls.contains(url) {
                    theRabbit.removeFromImageModels(obj)
                }
            }
            
            // Add photos from addUrls
            addUrls.forEach { url in
                let iModel = ImageModel(context: context)
                iModel.url = url
                if let coverPhotoUrl {
                    iModel.isCover = (url == coverPhotoUrl)
                } else {
                    iModel.isCover = false
                }
                
                theRabbit.addToImageModels(iModel)
            }
            
//            // Check all the Urls and mark the cover photo
//            if let coverPhotoUrl {
//                theRabbit.photos.forEach { obj in
//                    // Make sure we explicitly set this on each one
//                    // to turn the old one off if it changes
//                    obj.isCover = (obj.url == coverPhotoUrl)
//                }
//            }
            
            if doSave {
                try save(failureMessage: "Failed to save Rabbit")
            }
                
            return theRabbit
        }
    }
    
}
