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
    
    func image(_ images: Images) -> UIImage {
        switch self {
            case .adoptables:
                return images.adoptables
            case .favorites:
                return images.favorites
        }
    }
    
}
