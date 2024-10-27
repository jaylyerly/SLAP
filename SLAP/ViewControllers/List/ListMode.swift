//
//  ListMode.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

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
