//
//  Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

class Api {
    
    let config: Config
    let storage: Storage
    
    private let session: URLSession
    
    init(config: Config, storage: Storage) {
        self.config = config
        self.storage = storage
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "x-api-key": Secrets.apiKey
        ]
        self.session = URLSession(configuration: sessionConfig)
    }
    
    func refreshList() async throws {
        let url = buildUrl()
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        let rabbits = try decoder.decode([Rabbit].self, from: data)
        
        print("rabbits \(rabbits)")

    }
    
    func refresh(withInternalId internalId: String) throws {

    }
    
    private func buildUrl(withInternalId internalID: String? = nil) -> URL {
        var url = config.apiRoot
        url = url.appending(component: "animals", directoryHint: .isDirectory)
        if let internalID {
            url = url.appending(component: internalID)
        }
        return url
    }
    
    
}
