//
//  RabbitList_Endpoints.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

typealias RabbitListEndpoint = Endpoint<RabbitList>

extension RabbitList {
    
    static func publishable() -> RabbitListEndpoint {
        let params = ["status_type": "publishable"]
        return RabbitListEndpoint(pathPrefix: "animals", queryParams: params)
    }
    
}
