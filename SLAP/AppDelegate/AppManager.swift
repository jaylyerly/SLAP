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
        let api = Api(config: config, storage: storage)
        let images = Images()
        let style = Style()
        let alert = Alert()
        let webLinks = WebLinks()
        
        appEnv = AppEnv(
            config: config,
            alert: alert,
            defaults: defaults,
            style: style,
            images: images,
            api: api,
            storage: storage,
            webLinks: webLinks
        )
    }
    
}
