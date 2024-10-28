//
//  Rabbit_Endpoints.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias RabbitEndpoint = Endpoint<Rabbit>

extension Rabbit {
    
    static let detailEndpointName = "RabbitDetail"
    
    static func detail(forId objId: String) -> RabbitEndpoint {
        RabbitEndpoint(name: detailEndpointName, pathPrefix: "animals", objId: objId)
    }
    
}
