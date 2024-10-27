//
//  Rabbit_Endpoints.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias RabbitEndpoint = Endpoint<Rabbit>

extension Rabbit {
    
    static func detail(forId objId: String) -> RabbitEndpoint {
        RabbitEndpoint(pathPrefix: "animals", objId: objId)
    }
    
}
