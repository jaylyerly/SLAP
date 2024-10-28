//
//  FakeStorage.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP
import SwiftData

class FakeStorage: Storage {
    
    override init(notificationCenter: NotificationCenter) {
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        super.init(modelConfigurations: modelConfiguration, notificationCenter: notificationCenter)
    }
    
}

extension Storage {
    
    static func fake(notificationCenter: NotificationCenter) -> FakeStorage {
        FakeStorage(notificationCenter: notificationCenter)
    }
    
}
