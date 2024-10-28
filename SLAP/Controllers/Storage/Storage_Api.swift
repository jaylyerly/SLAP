//
//  Storage_Api.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

extension Storage: ApiDelegate {
    
    func api(_ api: Api, didReceive object: any Decodable, forEndpointName name: EndpointName) {
        
        Task {
            await MainActor.run {
                switch name {
                    case Rabbit.detailEndpointName:
                        do {
                            try insert(rabbit: object as? Rabbit)
                        } catch {
                            logger.error("Failed to add incoming single rabbit from API. \(error)")
                        }
                    default:
                        break
                }
            }
        }
        
    }
    
    func api(_ api: Api, didReceiveList objects: [any Decodable], forEndpointName name: EndpointName) {
        Task {
            await MainActor.run {
                
                switch name {
                    case RabbitList.publishableEndpointName:
                        let rabbits = objects.compactMap { $0 as? Rabbit }
                        do {
                            try importNewList(rabbits: rabbits)
                        } catch {
                            logger.error("Failed to import new list: \(error)")
                        }
                    default:
                        break
                }
            }
        }
    }
    
}
