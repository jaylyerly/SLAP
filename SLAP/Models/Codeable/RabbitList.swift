//
//  RabbitList.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

struct RabbitList: Codable {
    
    enum CodingKeys: String, CodingKey {
        case rawTotalCount = "total_count"
        case hasMore = "has_more"
        case success
        case animals
    }

    var success: Int
    var animals: [RabbitStruct]
    var rawTotalCount: String
    var hasMore: Bool
    
    var totalCount: Int? {
        Int(rawTotalCount)
    }
}
