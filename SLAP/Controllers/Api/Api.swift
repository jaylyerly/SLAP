//
//  Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

protocol ApiDelegate: AnyObject {
    func api(_ api: Api, didReceive object: Decodable, forEndpointName name: EndpointName)
    func api(_ api: Api, didReceiveList objects: [Decodable], forEndpointName name: EndpointName)
}

class Api {
    
    let config: Config
    
    weak var delegate: ApiDelegate?
    
    private let server: Server
    
    init(config: Config,
         protocolClasses: [AnyClass]? = nil, // these are for mocking during tests
         defaultSessionConfig: URLSessionConfiguration = .default) {
        self.config = config
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "x-api-key": Secrets.apiKey
        ]
        if let protocolClasses {
            sessionConfig.protocolClasses = protocolClasses
        }
        self.server = Server(baseUrl: config.apiRoot,
                             sessionConfiguration: sessionConfig)
    }
    
    func refreshList() async throws {
        let list = try await server.load(endpoint: RabbitList.publishable())
        delegate?.api(
            self,
            didReceiveList: list.animals,
            forEndpointName: RabbitList.publishableEndpointName
        )
    }
    
    func refresh(withInternalId internalId: String) async throws {
        let rabbit = try await server
            .load(endpoint: RabbitStruct.detail(forId: internalId))
        delegate?.api(self, didReceive: rabbit, forEndpointName: RabbitStruct.detailEndpointName)
    }
        
}
