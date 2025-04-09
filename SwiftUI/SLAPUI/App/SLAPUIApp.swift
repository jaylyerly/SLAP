//
//  SLAPUIApp.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import SwiftUI
import SwiftData

struct SLAPUIApp: App {
    @State private var config = Config()
    @State private var service: Service = {
        do {
            return try Service()
        } catch {
            fatalError("Could not create Service: \(error)")
        }
    }()
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Animal.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            MainTab()
        }
        .modelContainer(service.storage.modelContainer)
        .environment(\.service, service)
        .environment(\.config, config)
    }
}

extension EnvironmentValues {
    @Entry var service: Service = try! Service()
    @Entry var config: Config = Config()
}
