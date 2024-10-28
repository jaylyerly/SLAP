//
//  FakeNotificationCenter.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation

class FakeNotificationCenter: NotificationCenter {
    
    // just store anything that was posted for testing
    var lastNotification: Notification?

    override func post(_ notification: Notification) {
        lastNotification = notification
    }
    
    override func post(name aName: NSNotification.Name, object anObject: Any?) {
        lastNotification = .init(name: aName, object: anObject)
    }
    
    override func post(name aName: NSNotification.Name,
                       object anObject: Any?,
                       userInfo aUserInfo: [AnyHashable: Any]? = nil) {
        lastNotification = .init(name: aName, object: anObject, userInfo: aUserInfo)
    }
}

extension NotificationCenter {
    
    static func fake() -> FakeNotificationCenter { FakeNotificationCenter() }
    
}
