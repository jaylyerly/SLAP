//
//  Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

protocol ApiDelegate: AnyObject {
    func api(_ api: Api, didReceive object: Decodable)
}

class Api {
    
    let config: Config
    
    weak var delegate: ApiDelegate?
    
    private let server: Server
    
    init(config: Config) {
        self.config = config
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "x-api-key": Secrets.apiKey
        ]
        self.server = Server(baseUrl: config.apiRoot,
                             sessionConfiguration: sessionConfig)
    }
    
    func refreshList() async throws {
        let list = try await server.load(endpoint: RabbitList.publishable())
        print("rabbits \(list)")
        for rabbit in list.animals {
            delegate?.api(self, didReceive: rabbit)
        }
    }
    
    func refresh(withInternalId internalId: String) async throws {
        let rabbit = try await server
            .load(endpoint: Rabbit.detail(forId: internalId))
        print("rabbit: \(rabbit)")
        delegate?.api(self, didReceive: rabbit)
    }
        
}
