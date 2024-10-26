//
//  Spacer.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

class Spacer: UIView {}

extension UIView {
        
    static func spacer(width: CGFloat? = nil, height: CGFloat? = nil) -> Spacer {
        let view = Spacer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let width {
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
            widthConstraint.activate("spacer-width")
        }
        
        if let height {
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.activate("spacer-width")
        }
        view.backgroundColor = .clear
        return view
    }
}
