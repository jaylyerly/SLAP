//
//  ImageTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/13/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import SwiftUI
import Testing

@Suite("Image Tests") struct ImageTests {
    
    @Test func checkDataRoundTrip() async throws {
        
        let bundle = Bundle.testBundle
        let url = try #require(bundle.url(forResource: "kermit", withExtension: "png"))
        let data = try Data(contentsOf: url)
        
        let image = Image(data: data)
        let result = await Task { @MainActor in
            try #require(image.pngData())
        }.result
        
        let newData = try result.get()

        // Check that the new data is not empty.  Encodings and renderings make the process lossy, so
        // we won't get back the exact bits that went in.
        #expect(!newData.isEmpty)
    }
}
