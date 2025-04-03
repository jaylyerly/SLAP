//
//  RabbitList_Endpoints.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias RabbitListEndpoint = Endpoint<RabbitList>

extension RabbitList {
    
    static let publishableEndpointName = "PublishedRabbitList"
    
    static func publishable() -> RabbitListEndpoint {
        let params = ["status_type": "publishable"]
        return RabbitListEndpoint(
            name: publishableEndpointName,
            pathPrefix: "animals",
            queryParams: params
        )
    }
    
}
