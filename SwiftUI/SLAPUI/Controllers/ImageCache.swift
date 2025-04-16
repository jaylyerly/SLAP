//
//  ImageCache.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/16/25.
//

import Foundation

class ImageCache {
    
    static let placeholderData: Data = {
        guard let url = Bundle.main.url(forResource: "placeholder", withExtension: "png") else {
            return Data()
        }
        guard let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }()

    private let cache: URLCache
    private let session: URLSession

    init(inMemory: Bool = false, sessionConfiguration: URLSessionConfiguration = .default) {
        if inMemory {
            self.cache = URLCache(memoryCapacity: 32 * 1_024 * 1_024, diskCapacity: 1_024 * 1_024 * 1_024)
        } else {
            self.cache = URLCache(memoryCapacity: 32 * 1_024 * 1_024, diskCapacity: 0)
        }
        session = URLSession(configuration: sessionConfiguration)
    }
    
    func imageDataFromCache(for url: URL) -> Data? {
        cache.cachedResponse(for: URLRequest(url: url))?.data
    }
    
    func imageDataFromCacheOrDownload(for url: URL) async throws -> Data? {
        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request) {
            return cachedResponse.data
        } else {
            let (data, response) = try await session.data(from: url)
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
            return data
        }
        
    }
    
}
