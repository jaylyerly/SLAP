//
//  URLCache.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/11/25.
//

import Foundation

extension URLCache {

    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
    
}
