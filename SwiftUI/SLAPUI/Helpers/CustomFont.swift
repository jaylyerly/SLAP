//
//  CustomFont.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
import SwiftUI

struct CustomFont {

    let name: String
    let size: CGFloat
    let relativeTo: Font.TextStyle
    
    let font: Font
    
    init(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) {
        self.name = name
        self.size = size
        self.relativeTo = textStyle
        self.font = Font.custom(name, size: size, relativeTo: textStyle)
    }
    
}
