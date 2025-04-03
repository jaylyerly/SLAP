//
//  Server.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

class Server {
    
    let baseUrl: URL
    let session: URLSession
    
    init(baseUrl: URL, sessionConfiguration: URLSessionConfiguration = .default) {
        self.baseUrl = baseUrl
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func load<T>(endpoint: Endpoint<T>) async throws -> T {
        let url = endpoint.url(forBaseUrl: baseUrl)
        let (data, _) = try await session.data(from: url)
        let obj = try endpoint.parse(data: data)
        return obj
    }
    
}
