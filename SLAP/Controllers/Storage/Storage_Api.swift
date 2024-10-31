//
//  Storage_Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import CoreData
import Foundation

extension Storage: ApiDelegate {
    
    func api(_ api: Api, didReceive object: any Decodable, forEndpointName name: EndpointName) {
        
        switch name {
            case RabbitStruct.detailEndpointName:
                upsert(rabbitStruct: object as? RabbitStruct)
            default:
                break
        }
        
    }
    
    func api(_ api: Api, didReceiveList objects: [any Decodable], forEndpointName name: EndpointName) {
        switch name {
            case RabbitList.publishableEndpointName:
                let rStructs = objects.compactMap { $0 as? RabbitStruct }
                importPublished(rStructs: rStructs)
            default:
                break
        }
    }
    
    private func importPublished(rStructs: [RabbitStruct]) {
        // Remove existing isPublished flags
        rabbits.forEach { $0.isPublished = false }
        
        // Upsert the new structs and set the isPublished flag true, but don't save
        rStructs.forEach { upsert(rabbitStruct: $0, isPublished: true, save: false) }
        
        // Delete the non-favorite, non-published rabbits
        let fetchRequest = Rabbit.fetchRequest()
        
        let favPredicate = NSPredicate(format: "%K != %d", #keyPath(Rabbit.isFavorite), true)
        let publishedPredicate = NSPredicate(format: "%K != %d", #keyPath(Rabbit.isPublished), true)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [favPredicate, publishedPredicate])
        
        do {
            let deletions = try persistentContainer.viewContext.fetch(fetchRequest)
            deletions.forEach { object in
                persistentContainer.viewContext.delete(object)
            }
            
            try save(failureMessage: "Failed to batch delete old entries.")
        } catch {
            logger.error("Failed to import newly published records.")
        }
    }
    
}
