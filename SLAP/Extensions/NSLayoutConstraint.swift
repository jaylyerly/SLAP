//
//  NSLayoutConstraint.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

extension NSLayoutConstraint {
    
    func activate(_ identifier: String, priority floatPriority: Float = 999) {
        isActive = true
        self.identifier = identifier
        priority = UILayoutPriority(floatPriority)
    }
    
}
