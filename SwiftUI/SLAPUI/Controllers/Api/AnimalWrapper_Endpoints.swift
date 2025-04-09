//
//  AnimalWrapper_Endpoints.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias AnimalWrapperEndpoint = Endpoint<AnimalWrapper>

extension AnimalWrapper {
    
    static let publishableEndpointName = "PublishedAnimalList"
    
    static func publishable() -> AnimalWrapperEndpoint {
        let params = ["status_type": "publishable"]
        return AnimalWrapperEndpoint(
            name: publishableEndpointName,
            pathPrefix: "animals",
            queryParams: params
        )
    }
    
}
