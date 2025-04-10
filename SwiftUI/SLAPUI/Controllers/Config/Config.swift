//
//  Config.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import SwiftUI

class Config {
    
    // swiftlint:disable force_unwrapping
    var apiRoot: URL { URL(string: "https://www.shelterluv.com/api/v1/")! }
    let storeUrl = URL(string: "https://shop.trianglerabbits.org")!
    let homeUrl = URL(string: "https://www.trianglerabbits.org")!
    // swiftlint:enable force_unwrapping

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
    
    var bodyFont: Font = .custom("Marker Felt", size: 18, relativeTo: .body)
    var titleFont: Font = .custom("Marker Felt", size: 32, relativeTo: .title)
    var largeTitleFont: Font = .custom("Marker Felt", size: 48, relativeTo: .largeTitle)

}
