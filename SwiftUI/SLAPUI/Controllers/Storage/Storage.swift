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
    
    init() throws {
        modelContainer = try ModelContainer(for: Animal.self)
    }
    
    func getContext() -> ModelContext {
        ModelContext(modelContainer)
    }

}
