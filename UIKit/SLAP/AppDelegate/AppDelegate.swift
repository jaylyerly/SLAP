//
//  AppDelegate.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appManager: AppManager?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let appMgr = AppManager()
        
        let mainVC = ViewControllerFactory.main(appEnv: appMgr.appEnv)
        window?.rootViewController = mainVC

        window?.makeKeyAndVisible()
        
        return true
    }
    
}
