//
//  RabbitStruct_Endpoints.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias AnimalEndpoint = Endpoint<Animal>

extension Animal {
    
    static let detailEndpointName = "AnimalDetail"
    
    static func detail(forId objId: String) -> AnimalEndpoint {
        AnimalEndpoint(name: detailEndpointName, pathPrefix: "animals", objId: objId)
    }
    
}
