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

    static func testEnv(config: Config = .fake,
                        defaults: Defaults? = nil,
                        alert: Alert = .fake,
                        style: Style = Style(),
                        images: Images = Images()) -> AppEnv {
    
        let defaults = defaults ?? .fake(config: config)

        return AppEnv(config: config,
                      alert: alert,
                      defaults: defaults,
                      style: style,
                      images: images)
        
    }
    
}
