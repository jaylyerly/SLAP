//
//  Images.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

enum Images: String, CaseIterable {
    case store = "storefront"          /// 􁽇
    case adoptables = "hare"           /// 􀓎
    case favorites = "heart.rectangle" /// 􁃪
    case house = "house"               /// 􀎞
    case link = "link"                 /// 􀉣
    case isFavorite = "heart.fill"     /// 􀊵
    case isNotFavorite = "heart"       /// 􀊴
    case banner
    case placeholderRabbit
}

extension Images {
    
    var img: UIImage {
        // swiftlint:disable force_unwrapping
        switch self {
            case .store:
                UIImage(systemName: "storefront")!
            case .adoptables:
                UIImage(systemName: "hare")!
            case .favorites:
                UIImage(systemName: "heart")!
            case .house:
                UIImage(systemName: "house")!
            case .link:
                UIImage(systemName: "link")!
            case .isFavorite:
                UIImage(systemName: "heart.fill")!
            case .isNotFavorite:
                UIImage(systemName: "heart")!
            case .banner:
                UIImage(named: "Banner")!
            case .placeholderRabbit:
                UIImage(named: "PlaceholderRabbit")!
        }
        // swiftlint:enable force_unwrapping
    }
}
