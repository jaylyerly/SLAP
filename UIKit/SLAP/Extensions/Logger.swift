//
//  Logger.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import OSLog

extension Logger {
        
    init(category: String) {
        let bundleID = Bundle.main.bundleIdentifier ?? "com.sonicbunny.unknown"
        self.init(subsystem: bundleID, category: category)
    }

    static func defaultLogger(category: String = #fileID) -> Logger {
        Logger(category: category)
    }

}
