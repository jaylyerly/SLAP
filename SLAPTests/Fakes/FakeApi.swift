//
//  FakeApi.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

class FakeApi: Api {
    
    override func refreshList() async throws {
        print("refresh list")
    }
    
    override func refresh(withInternalId internalId: String) async throws {
        print("refresh single with ID: \(internalId)")
    }
    
}

extension Api {
    
    static func fake(config: Config) -> FakeApi {
        FakeApi(config: config)
    }
    
}
