//
//  Item.swift
//  SLAP2
//
//  Created by Jay Lyerly on 4/1/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
