//
//  AppEnv.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP

extension AppEnv {

    static var fake: AppEnv { .testEnv() }

    static func testEnv(config: Config = .fake(),
                        defaults: Defaults? = nil,
                        alert: Alert = .fake(),
                        style: Style = Style(),
                        images: Images = Images(),
                        api: Api? = nil,
                        storage: Storage? = nil,
                        webLinks: WebLinks = .fake()) -> AppEnv {
    
        let defaults = defaults ?? .fake(config: config)
        let api = api ?? .fake()
        let storage = storage ?? .fake()
        
        return AppEnv(config: config,
                      alert: alert,
                      defaults: defaults,
                      style: style,
                      images: images,
                      api: api,
                      storage: storage,
                      webLinks: webLinks)
        
    }
    
}
