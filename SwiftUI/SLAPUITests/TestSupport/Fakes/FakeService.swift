//
//  FakeService.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
@testable import SLAPUI

class FakeService: Service {
    
}

extension Service {
    
    static func fake(notificationCenter: NotificationCenter) -> FakeService {
        try! FakeService(api: .fake(), storage: .fake(), notificationCenter: notificationCenter)
    }
    
}
