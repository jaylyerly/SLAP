//
//  Data.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import XCTest

extension Data {
    
    static func jsonData(forFilePrefix prefix: String) throws -> Data {
        let bundle = Bundle(for: TestCase.self)
        let url = try XCTUnwrap(bundle.url(forResource: prefix, withExtension: "json"))
        return try Data(contentsOf: url)
    }
    
}
