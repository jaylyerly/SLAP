//
//  FakeApi.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

class FakeApi: Api {
    
}

extension Api {
    
    static func fake() -> FakeApi { FakeApi() }
    
}
