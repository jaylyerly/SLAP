//
//  FakeStorage.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

class FakeStorage: Storage {
    
    init() {
        super.init(storeType: .inMemory)
        start()
    }
    
}

extension Storage {
    
    static func fake() -> FakeStorage { FakeStorage() }
    
}
