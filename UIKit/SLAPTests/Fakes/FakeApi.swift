//
//  FakeApi.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

class FakeApi: Api {
    
    var didRefreshList = false
    var didRefreshSingle = false
    
    var singleRefreshInternalIds = [String]()
    
    override func refreshList() async throws {
        didRefreshList = true
    }
    
    override func refresh(withInternalId internalId: String) async throws {
        didRefreshSingle = true
        singleRefreshInternalIds.append(internalId)
    }
    
}

extension Api {
    
    static func fake(config: Config) -> FakeApi {
        FakeApi(config: config)
    }
    
}
