//
//  ImagesTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class ImagesTests: TestCase {
    
    func testImages() throws {
        // Cycle through all the images and make sure they're not nil,
        // eg that the image loaded and didn't crash on force unwrap
        Images.allCases.forEach { XCTAssertNotNil($0.img) }
    }
    
}
