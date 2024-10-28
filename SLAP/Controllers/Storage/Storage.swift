//
//  Storage.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog
import SwiftData

extension NSNotification.Name {
    static let storageDidUpdateList = Notification.Name("SLAP.storageDidUpdateList")
    static let storageDidUpdateDetail = Notification.Name("SLAP.storageDidUpdateDetail")
}

class Storage {
    
    let container: ModelContainer
    let notificationCenter: NotificationCenter
    let logger = Logger.defaultLogger()
    

    private let favoriteDescriptor = FetchDescriptor<Rabbit>(
        predicate: #Predicate { $0.isFavorite == true },
        sortBy: [.init(\.name)]
    )
    
    @MainActor
    var favorites: [Rabbit] {
        favorites(inContext: container.mainContext)
    }
    
    @MainActor
    var rabbits: [Rabbit] {
        rabbits(inContext: container.mainContext)
    }
    
    init(modelConfigurations: ModelConfiguration, notificationCenter: NotificationCenter) {
        // swiftlint:disable:next force_try
        container = try! ModelContainer(for: Rabbit.self, configurations: modelConfigurations)
        self.notificationCenter = notificationCenter
    }
    
    init(notificationCenter: NotificationCenter) {
        // swiftlint:disable:next force_try
        container = try! ModelContainer(for: Rabbit.self)
        self.notificationCenter = notificationCenter
    }
    
    func getContext() -> ModelContext {
        let context = ModelContext(container)
        context.autosaveEnabled = true
        return context
    }
    
    @MainActor
    func insert(rabbit: Rabbit?) throws {
        try insert(rabbit: rabbit, inContext: container.mainContext)
    }
    
    func insert(rabbit: Rabbit?, inContext context: ModelContext) throws {
        guard let rabbit else { return }

        // Preserve the stored value of isFavorite
        var isFavorite = false
        let existingDescriptor = FetchDescriptor<Rabbit>(
            predicate: #Predicate { $0.internalId == rabbit.internalId }
        )
        if let existingRabbit = try context.fetch(existingDescriptor).first {
            isFavorite = existingRabbit.isFavorite
        }
        rabbit.isFavorite = isFavorite
        
        context.insert(rabbit)
        try context.save()      // Why do we need this with autosaveEnabled == true?
        notificationCenter.post(name: .storageDidUpdateDetail, object: rabbit)
    }
      
    @MainActor
    func importNewList(rabbits: [Rabbit]) throws {
        try importNewList(rabbits: rabbits, inContext: container.mainContext)
    }
    
    func importNewList(rabbits: [Rabbit], inContext context: ModelContext) throws {
        // Get the ids for favorited existing rabbits
        let favoriteIds = favorites(inContext: context).map { $0.internalId }

        // Preserve isFavorite for new rabbits
        rabbits.forEach { rabbit in
            favoriteIds.forEach { fId in
                if rabbit.internalId == fId {
                    rabbit.isFavorite = true
                }
            }
        }
        
        // Delete all the non-favorites
        let notFavDescriptor = FetchDescriptor<Rabbit>(
            predicate: #Predicate { !$0.isFavorite }
        )
        try context.fetch(notFavDescriptor).forEach { rabbit in
            context.delete(rabbit)
        }
        
        // Insert the new rabbits
        rabbits.forEach { context.insert($0) }
        try context.save()
        
        notificationCenter.post(name: .storageDidUpdateList, object: nil)
    }
    
    @MainActor
    func delete(rabbit: Rabbit?) throws {
        try delete(rabbit: rabbit, inContext: container.mainContext)
    }
    
    func delete(rabbit: Rabbit?, inContext context: ModelContext) throws {
        guard let rabbit else { return }
        context.delete(rabbit)
        try context.save()
        notificationCenter.post(name: .storageDidUpdateDetail, object: rabbit)
    }
    
    func favorites(inContext context: ModelContext) -> [Rabbit] {
        do {
            return try context.fetch(favoriteDescriptor)
        } catch {
            logger.error("Can't fetch favorites: \(error)")
            return []
        }
    }
    
    func rabbits(inContext context: ModelContext) -> [Rabbit] {
        do {
            logger.info("Fetching Rabbits.")
            return try context.fetch(FetchDescriptor<Rabbit>())
        } catch {
            logger.error("Can't fetch rabbits: \(error)")
            return []
        }
    }

}
