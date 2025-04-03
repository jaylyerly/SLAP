//
//  FakeAlert.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
@testable import SLAP
import XCTest

class FakeAlert: Alert {
    
    var lastMsg: String?
    var lastTitle = ""
    var lastParentViewController: UIViewController?
    
    override func displayErrorWithMessage(_ msg: String,
                                          title: String = "Error",
                                          presentingViewController parentVC: UIViewController,
                                          completion: (() -> Void)? = nil ) {
        lastMsg = msg
        lastTitle = title
        lastParentViewController = parentVC
        completion?()
    }
    
}

extension Alert {
    
    static func fake() -> FakeAlert { FakeAlert() }
    
}
