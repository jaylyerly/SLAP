//
//  Image.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/11/25.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Image {
    /// Initializes a SwiftUI `Image` from data.
    init(data: Data) {
        let defaultImageName = "photo"
        
        #if canImport(UIKit)
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: defaultImageName)
        }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: data) {
            self.init(nsImage: nsImage)
        } else {
            self.init(systemName: defaultImageName)
        }
        #else
        self.init(systemName: defaultImageName)
        #endif
    }

    @MainActor
    func pngData() -> Data? {
        
#if canImport(UIKit)
        return ImageRenderer(content: self).uiImage?.pngData()
#elseif canImport(AppKit)
        return ImageRenderer(content: self).nsImage?.pngData()
#else
        return nil
#endif
        
    }
        
}
