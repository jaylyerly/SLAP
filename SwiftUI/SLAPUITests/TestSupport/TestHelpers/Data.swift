//
//  Data.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import Testing

extension Data {
    
    static func jsonData(forFilePrefix prefix: String) throws -> Data {
        let bundle = Bundle.testBundle
        let url = try #require(bundle.url(forResource: prefix, withExtension: "json"))
        return try Data(contentsOf: url)
    }
    
}
