//
//  AppEnv.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

extension AppEnv {

    static func fake(config: Config = .fake(),
                     defaults: Defaults? = nil,
                     alert: Alert = .fake(),
                     style: Style = Style(),
                     api: Api? = nil,
                     storage: Storage? = nil,
                     webLinks: WebLinks = .fake(),
                     notificationCenter: NotificationCenter = .fake()) -> AppEnv {
    
        let defaults = defaults ?? .fake(config: config)
        let storage = storage ?? .fake(notificationCenter: notificationCenter)
        let api = api ?? .fake(config: config)
        
        api.delegate = storage
        
        return AppEnv(config: config,
                      alert: alert,
                      defaults: defaults,
                      style: style,
                      api: api,
                      storage: storage,
                      webLinks: webLinks,
                      notificationCenter: notificationCenter)
        
    }
    
}
