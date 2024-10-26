//
//  AppEnv.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog
import UIKit

struct AppEnv {
    let config: Config
    let alert: Alert
    let defaults: Defaults
    let style: Style
    let images: Images
    let api: Api
    let storage: Storage
    let webLinks: WebLinks
}

protocol AppEnvConsumer {
    var appEnv: AppEnv { get }
    var logger: Logger { get }
    
    var config: Config { get }
    var alert: Alert { get }
    var defaults: Defaults { get }
    var style: Style { get }
    var images: Images { get }
    var api: Api { get }
    var storage: Storage { get }
    var webLinks: WebLinks { get }
}

extension AppEnvConsumer {
    var config: Config { appEnv.config }
    var alert: Alert { appEnv.alert }
    var defaults: Defaults { appEnv.defaults }
    var style: Style { appEnv.style }
    var images: Images { appEnv.images }
    var api: Api { appEnv.api }
    var storage: Storage { appEnv.storage }
    var webLinks: WebLinks { appEnv.webLinks }
}

protocol AppViewController: UIViewController, AppEnvConsumer {
    
    init?(coder: NSCoder, appEnv: AppEnv)
    
}
