//
//  GenericError.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/28/24.
//

import Foundation

/// A completely generic error that includes a reason for the error.
struct GenericError: Error, LocalizedError {

    let reason: String
    let title: String?
    
    var localizedDescription: String { reason }
    
    var errorDescription: String? { reason }
}

extension GenericError {
    
    init(reason: String) {
        self.reason = reason
        title = nil
    }
    
}
