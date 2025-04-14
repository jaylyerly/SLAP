//
//  ConfigTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import Testing

@Suite("Config Tests") struct ConfigTests {
    
    let config = Config()
    
    @Test func checkUrls() throws {
        
        expectNoDifference(config.apiRoot.absoluteString, "https://www.shelterluv.com/api/v1/")
        expectNoDifference(config.storeUrl.absoluteString, "https://shop.trianglerabbits.org")
        expectNoDifference(config.homeUrl.absoluteString, "https://www.trianglerabbits.org")
    }
    
    @Test func checkVersionInfo() throws {
        let appVersion = try #require(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
        let buildNumber = try #require(Bundle.main.infoDictionary?["CFBundleVersion"] as? String)

        expectNoDifference(config.bundleId, "com.sonicbunny.SLAPUI")
        expectNoDifference(config.appVersion, appVersion)
        expectNoDifference(config.buildNumber, buildNumber)
        expectNoDifference(config.version, "\(appVersion) (\(buildNumber))")
    }
    
    @Test func checkFonts() throws {
        expectNoDifference(config.bodyFont.name, "Marker Felt")
        expectNoDifference(config.titleFont.name, "Marker Felt")
        expectNoDifference(config.largeTitleFont.name, "Marker Felt")
        
        expectNoDifference(config.bodyFont.size, 18)
        expectNoDifference(config.titleFont.size, 32)
        expectNoDifference(config.largeTitleFont.size, 48)
        
        expectNoDifference(config.bodyFont.relativeTo, .body)
        expectNoDifference(config.titleFont.relativeTo, .title)
        expectNoDifference(config.largeTitleFont.relativeTo, .largeTitle)
    }
    
}
