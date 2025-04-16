//
//  SLAPUIApp.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import SwiftData
import SwiftUI

struct SLAPUIApp: App {
    @State private var config = Config()
    @State private var service: Service = {
        do {
            return try Service()
        } catch {
            fatalError("Could not create Service: \(error)")
        }
    }()
    @State private var imageCache = ImageCache()

    var body: some Scene {
        WindowGroup {
            MainTab()
        }
        .modelContainer(service.storage.modelContainer)
        .environment(\.service, service)
        .environment(\.config, config)
        .environment(\.imageCache, imageCache)
    }
}

extension EnvironmentValues {
    @Entry var service: Service = try! Service()  // swiftlint:disable:this force_try
    @Entry var config = Config()
    @Entry var imageCache = ImageCache()
}
