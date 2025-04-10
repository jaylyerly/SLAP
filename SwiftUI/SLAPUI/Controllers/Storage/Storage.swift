//
//  Storage.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/4/25.
//

import Foundation
import SwiftData

class Storage {

    let modelContainer: ModelContainer
    
    init(inMemoryOnly: Bool = false) throws {
        let modelConfig = ModelConfiguration(isStoredInMemoryOnly: inMemoryOnly)
        modelContainer = try ModelContainer(for: Animal.self, configurations: modelConfig)
    }
    
    func getContext() -> ModelContext {
        ModelContext(modelContainer)
    }

}
