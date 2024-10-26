//
//  TestingAppDelegate.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
@testable import SLAP
import UIKit

class TestingAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let logger = Logger.defaultLogger()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logger.debug("Test App Delegate engaged!")
        return true
    }

}
