//
//  UIImage.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import UIKit

extension UIImage {
    
    var pngNormalizedImage: UIImage {
        // Convert image to PNG and back to image to force the same internal storage format
        UIImage(data: pngData()!)!
    }
    
    // Taken from: https://rosettacode.org/wiki/Percentage_difference_between_images#Swift
    // Note -- 'var concreteCgImage: CGImage' moved to main app
    
    /// Compare two images and compute the difference from 0 to 1.0
    /// 0 difference images are identical
    /// 1.0 difference images are exactly opposite (all black vs all white)
    func compare(toImage image2: UIImage) -> Double? {
        let image1 = self
        guard let data1 = pixelValues(fromCGImage: image1.concreteCgImage),
              let data2 = pixelValues(fromCGImage: image2.concreteCgImage),
              data1.count == data2.count else {
            return nil
        }
        
        let width = Double(image1.size.width)
        let height = Double(image1.size.height)
        
        return zip(data1, data2)
            .enumerated()
            .reduce(0.0) {
                // swiftlint:disable:next anonymous_argument_in_multiline_closure
                $1.offset % 4 == 3 ? $0 : $0 + abs(Double($1.element.0) - Double($1.element.1))
            }
        / (width * height * 3.0) / 255.0
    }
    
    private func pixelValues(fromCGImage imageRef: CGImage?) -> [UInt8]? {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        
        if let imageRef {
            width = imageRef.width
            height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = imageRef.bytesPerRow
            let totalBytes = height * bytesPerRow
            let bitmapInfo = imageRef.bitmapInfo
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities,
                                       width: width,
                                       height: height,
                                       bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow,
                                       space: colorSpace,
                                       bitmapInfo: bitmapInfo.rawValue)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
        }
        
        return pixelValues
    }

}

extension UIImage {
    
    var concreteImage: UIImage? {
        guard let cgImage = concreteCgImage else { return nil }
        let newImage = UIImage(cgImage: cgImage)
        newImage.accessibilityIdentifier = accessibilityIdentifier
        return newImage
    }
    
    var concreteCgImage: CGImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(size)
        
        var cgImage: CGImage?
        if let context = UIGraphicsGetCurrentContext() {
            
            draw(in: CGRect(origin: .zero, size: size))
            cgImage = context.makeImage()
        }
        
        return cgImage
    }
    
}
