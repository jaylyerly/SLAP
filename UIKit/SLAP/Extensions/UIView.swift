//
//  UIView.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

extension UIView {
    
    func addSubViewEdgeToSafeEdge(_ subview: UIView,
                                  verticalMargin vMarg: CGFloat = 0,
                                  horizontalMargin hMarg: CGFloat = 0,
                                  includeBottomConstraint: Bool = true) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        let safe = safeAreaLayoutGuide
        
        safe.topAnchor.constraint(equalTo: subview.topAnchor, constant: -1 * vMarg).isActive = true
        safe.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: -1 * hMarg).isActive = true
        safe.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: hMarg).isActive = true
        if includeBottomConstraint {
            safe.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: vMarg).isActive = true
        }
    }
    
}

extension UIView {
    
    @IBInspectable var cornerRounding: CGFloat {   // swiftlint:disable:this ibinspectable_in_extension
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {   // swiftlint:disable:this ibinspectable_in_extension
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {   // swiftlint:disable:this ibinspectable_in_extension
        get { layer.borderColor.map { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
    func setBorder(_ color: UIColor?, width: CGFloat = 1.0) {
        borderWidth = width
        borderColor = color
    }
    
}
