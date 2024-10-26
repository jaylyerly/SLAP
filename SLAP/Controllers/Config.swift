//
//  Config.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

class Config {
    
    // swiftlint:disable:next force_unwrapping
    let apiRoot = URL(string: "https://www.shelterluv.com/api/v1/")!

    // swiftlint:disable:next force_unwrapping
    let storeUrl = URL(string: "https://shop.trianglerabbits.org")!
    // swiftlint:disable:next force_unwrapping
    let homeUrl = URL(string: "https://www.trianglerabbits.org")!

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
