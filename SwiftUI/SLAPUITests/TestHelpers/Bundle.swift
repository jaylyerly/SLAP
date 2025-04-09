//
//  Bundle.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import Foundation

// Make a dummy class to look for to find the test bundle.
private class TestBeacon {}

extension Bundle {
    
    static var testBundle: Bundle {
        return Bundle(for: TestBeacon.self)
    }
    
}
