//
//  Config.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

class Config {
    let bundleId = Bundle.main.bundleIdentifier ?? "com.sonicbunny.unknown"

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
        
    var version: String {
         "\(appVersion) (\(buildNumber))"
    }
}
