//
//  Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog

protocol ApiDelegate: AnyObject {
    func api(_ api: Api, didReceive object: Decodable, forEndpointName name: EndpointName)
    func api(_ api: Api, didReceiveList objects: [Decodable], forEndpointName name: EndpointName)
}

class Api {
    
    let config: Config
    
    weak var delegate: ApiDelegate?
    let logger = Logger.defaultLogger()
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
        print("refreshing list")
        let list = try await server.load(endpoint: RabbitList.publishable())
        print("list refresh complete")
        delegate?.api(
            self,
            didReceiveList: list.animals,
            forEndpointName: RabbitList.publishableEndpointName
        )
    }
    
    func refresh(withInternalId internalId: String) async throws {
        logger.info("refreshing single with ID \(internalId)")
        let rabbit = try await server
            .load(endpoint: RabbitStruct.detail(forId: internalId))
        logger.info("single refresh complete for ID \(internalId)")
        delegate?.api(self, didReceive: rabbit, forEndpointName: RabbitStruct.detailEndpointName)
    }
        
}
