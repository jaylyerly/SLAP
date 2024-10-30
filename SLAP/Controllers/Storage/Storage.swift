//
//  Storage.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import CoreData
import OSLog

enum StorageError: Error {
    case notFound
    case foundTooMany
    case inputIsNil
}

class Storage {
        
    // Load this once to avoid errors with multiple loads in unit tests
    static var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: Storage.self)
        
        guard let url = bundle.url(forResource: "SLAP", withExtension: "momd") else {
            fatalError("Failed to locate momd file for Models")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load momd file for Models")
        }
        
        return model
    }()

    let logger = Logger.defaultLogger()

    let persistentContainer: NSPersistentContainer
    
    private var hasStarted = false
    
    private let storeType: StoreType
    
    init(storeType: StoreType = .persisted) {
        self.storeType = storeType
        persistentContainer = NSPersistentContainer(name: "SLAPContainer",
                                                    managedObjectModel: Self.managedObjectModel)

        switch storeType {
            case .inMemory:
                // for testing
                persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
                start()
            case .persisted:
                if let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, 
                                                                 in: .userDomainMask).first {
                    let sqliteURL = storeDirectory.appendingPathComponent("SLAP.sqlite")
                    
                    let description = NSPersistentStoreDescription(url: sqliteURL)
                    description.shouldInferMappingModelAutomatically = true
                    description.shouldMigrateStoreAutomatically = true
                    persistentContainer.persistentStoreDescriptions = [description]
                    logger.info("CoreData DB is at \(sqliteURL)")
                }
        }
    }
    
    // loading the persistent stores is put in this start method to
    // prevent loading of the persistent data stack
    // while AppManager and Storage are  initialized
    func start() {
        if hasStarted {
           return
        }
        hasStarted = true
        
        persistentContainer.loadPersistentStores { description, error in
            
            if let error {
                fatalError("Core Data store failed to load with error: \(error) \n desc: \(description)")
            }
        }
    }
    
    func save(failureMessage: String = "Failed to save context") throws {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            logger.error("\(failureMessage) \(error)")
            throw error
        }
    }
    
    func delete(_ object: NSManagedObject) throws {
        persistentContainer.viewContext.delete(object)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            logger.error("Failed to delete object: \(error)")
            throw error
        }
    }
    
    func object(with objId: NSManagedObjectID) throws -> NSManagedObject {
        try persistentContainer.viewContext.existingObject(with: objId)
    }
    
    func object<T>(with objId: NSManagedObjectID, type: T.Type) throws -> T {
        let obj = try object(with: objId)
        if let typedObj = obj as? T {
            return typedObj
        }
        throw GenericError(reason: "Found object with id: \(objId) but was not \(type) type")
    }
}

/// Use inMemory for testing
enum StoreType {
    case inMemory, persisted
}
