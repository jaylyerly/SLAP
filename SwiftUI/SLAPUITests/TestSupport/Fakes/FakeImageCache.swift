//
//  FakeImageCache.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/16/25.
//

import Foundation
@testable import SLAPUI
import Testing

class FakeImageCache: ImageCache {
    
    enum Mode {
        case cacheAlwaysWorks
        case cacheNeverWorks
    }
    
    private var mode: Mode
    private let imageData: Data
    
    init(mode: Mode) throws {
        self.mode = mode
        
        let bundle = Bundle.testBundle
        let url = try #require(bundle.url(forResource: "kermit", withExtension: "png"))
        imageData = try Data(contentsOf: url)
        
        super.init(inMemory: true)
    }
    
    override func imageDataFromCache(for url: URL) -> Data? {
        mode == .cacheAlwaysWorks ? imageData : nil
    }
    
    override func imageDataFromCacheOrDownload(for url: URL) async throws -> Data? {
        switch mode {
            case .cacheAlwaysWorks:
                // return data immediately
                return imageData
            case .cacheNeverWorks:
                // suspend for a bit and then deliver the data
                try await Task.sleep(for: .milliseconds(100))
                return imageData
        }
    }
    
}

extension ImageCache {
    
    static func fake(mode: FakeImageCache.Mode) throws -> ImageCache {
        try FakeImageCache(mode: mode)
    }
    
}
