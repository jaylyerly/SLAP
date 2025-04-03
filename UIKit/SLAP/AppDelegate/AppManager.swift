//
//  AppManager.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

struct AppManager {
    
    let appEnv: AppEnv
    
    init() {
        let config = Config()
        let defaults = Defaults(config: config)
        let storage = Storage()
        let api = Api(config: config)
        let alert = Alert()
        let webLinks = WebLinks()
        
        // Connect up the delegates
        api.delegate = storage
        
        appEnv = AppEnv(
            config: config,
            alert: alert,
            defaults: defaults,
            api: api,
            storage: storage,
            webLinks: webLinks,
            notificationCenter: NotificationCenter.default
        )
        
        // Start things up once the frameworks are in place.
        storage.start()
    }
    
}
