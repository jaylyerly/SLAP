//
//  LinksTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import SwiftUI
import Testing
import ViewInspector

@Suite("Links Tests") struct LinksTests {

    var view: Links
    
    init() throws {
        view = Links()
    }
        
    @MainActor
    @Test func checkLinks() async throws {
        let config = Config.fake()
        try await ViewHosting.host(view.environment(\.config, config)) {
            try await view.inspection.inspect { hostedView in
                let links = hostedView.findAll(ViewType.Link.self)
                
                expectNoDifference(links.count, 2)
                
                let urls = try links.map { try $0.url() }
                
                expectNoDifference(Set(urls), Set([config.homeUrl, config.storeUrl]))
            }
        }
    }
    
}
