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
}

protocol AppEnvConsumer {
    var appEnv: AppEnv { get }
    var logger: Logger { get }
    
    var config: Config { get }
    var alert: Alert { get }
    var defaults: Defaults { get }
    var style: Style { get }
    var images: Images { get }
}

extension AppEnvConsumer {
    var config: Config { appEnv.config }
    var alert: Alert { appEnv.alert }
    var defaults: Defaults { appEnv.defaults }
    var style: Style { appEnv.style }
    var images: Images { appEnv.images }
}

protocol AppViewController: UIViewController, AppEnvConsumer {
    
    init?(coder: NSCoder, appEnv: AppEnv)
    
}
