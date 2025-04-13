//
//  Animal_Endpoints.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias AnimalEndpoint = Endpoint<Animal>

extension Animal {
        
    static func detail(forId objId: String) -> AnimalEndpoint {
        AnimalEndpoint(pathPrefix: "animals", objId: objId)
    }
    
}
