//
//  AnimalWrapper.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

struct AnimalWrapper: Codable {
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case hasMore = "has_more"
        case success
        case animals
    }

    var success: Int
    var animals: [Animal]
    var totalCount: Int
    var hasMore: Bool
    
}
