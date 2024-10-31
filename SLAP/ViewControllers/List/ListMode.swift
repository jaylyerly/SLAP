//
//  ListMode.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import CoreData
import UIKit

enum ListMode {
    case adoptables
    case favorites
}

extension ListMode {
    
    var title: String {
        switch self {
            case .adoptables:
                return "Adoptables"
            case .favorites:
                return "Favorites"
        }
    }
    
    var image: UIImage {
        switch self {
            case .adoptables:
                return Images.adoptables.img
            case .favorites:
                return Images.favorites.img
        }
    }
        
}

extension ListMode {
    
    func fetchResultsController(storage: Storage) -> NSFetchedResultsController<Rabbit> {
        let fetchRequest: NSFetchRequest<Rabbit> = Rabbit.fetchRequest()
        
        if self == .favorites {
            fetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Rabbit.isFavorite), true)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: storage.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        return fetchedResultsController
    }
    
}
