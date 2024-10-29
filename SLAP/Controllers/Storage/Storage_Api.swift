//
//  Storage_Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

extension Storage: ApiDelegate {
    
    func api(_ api: Api, didReceive object: any Decodable, forEndpointName name: EndpointName) {
        
        switch name {
            case RabbitStruct.detailEndpointName:
                upsert(rabbitStruct: object as? RabbitStruct)
            default:
                break
        }
        
    }
    
    func api(_ api: Api, didReceiveList objects: [any Decodable], forEndpointName name: EndpointName) {
        switch name {
            case RabbitList.publishableEndpointName:
                objects
                    .compactMap { $0 as? RabbitStruct }
                    .forEach { upsert(rabbitStruct: $0) }
            default:
                break
        }
    }
    
}
