//
//  PreviewConfig.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/9/25.
//

import Foundation

class PreviewConfig: Config {
    
    // swiftlint:disable:next force_unwrapping
    override var apiRoot: URL { URL(string: "https://example.com/api/v1/")! }
    
}

extension Config {
    
    static let preview = PreviewConfig()
}
