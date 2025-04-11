//
//  Api.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog

class Api {
    
    let config: Config
    let logger = Logger.defaultLogger()
    private let server: Server
    
    init(config: Config? = nil,
         protocolClasses: [AnyClass]? = nil, // these are for mocking during tests
         defaultSessionConfig: URLSessionConfiguration = .default) {
        self.config = config ?? Config()
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "x-api-key": Secrets.apiKey
        ]
        if let protocolClasses {
            sessionConfig.protocolClasses = protocolClasses
        }
        self.server = Server(baseUrl: self.config.apiRoot,
                             sessionConfiguration: sessionConfig)
    }
    
    func refreshPublishableAnimals() async throws -> AnimalWrapper {
        logger.info("refreshing animal list")

        let list = try await server.load(endpoint: AnimalWrapper.publishable())
        
        logger.info("animal list refresh complete: \(list.animals.count)")
        
        return list
    }
    
    func refreshAnimal(withInternalId internalId: String) async throws -> Animal {
        logger.info("refreshing single with ID \(internalId)")
        let animal = try await server.load(endpoint: Animal.detail(forId: internalId))
        logger.info("single refresh complete for ID \(internalId)")
        
        return animal
    }
        
}
