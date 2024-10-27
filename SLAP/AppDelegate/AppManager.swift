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
        let images = Images()
        let style = Style()
        let alert = Alert()
        let webLinks = WebLinks()
        
        // Connect up the delegates
        api.delegate = storage
        
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
        Task {
            // Refresh the rabbit list right away
            // FIXME -- this should move to ListVC so it can report errors
            try? await api.refreshList()
        }
    }
    
}
