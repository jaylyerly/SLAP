//
//  Endpoint.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

enum EndpointHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias EndpointName = String

struct Endpoint<T: Codable> {
    
    let name: EndpointName
    let pathPrefix: String
    let objId: String?
    let method: EndpointHttpMethod
    let queryParams: [String: String]?
    
    init(name: EndpointName,
         pathPrefix: String,
         method: EndpointHttpMethod = .get,
         objId: String? = nil,
         queryParams: [String: String]? = nil) {
        self.pathPrefix = pathPrefix
        self.objId = objId
        self.method = method
        self.queryParams = queryParams
        self.name = name
    }
    
    func url(forBaseUrl baseUrl: URL) -> URL {
        var url = baseUrl

        if !pathPrefix.isEmpty {
            url.appendPathComponent(pathPrefix)
        }
        
        if let objId {
            url.appendPathComponent(objId)
        }
        
        if let queryParams {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)
            comps?.queryItems = queryParams.map { URLQueryItem(name: $0.0, value: $0.1) }
            if let newUrl = comps?.url {
                url = newUrl
            }
        }
        
        return url
    }
    
    func parse(data: Data) throws -> T {
        let obj = try JSONDecoder().decode(T.self, from: data)
        return obj
    }
    
}
