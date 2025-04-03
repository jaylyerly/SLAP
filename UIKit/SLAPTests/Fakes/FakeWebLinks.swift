//
//  FakeWebLinks.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

@testable import SLAP
import UIKit

class FakeWebLinks: WebLinks {
    
    var lastOpenUrl: URL?
    var lastPresentingViewController: UIViewController?
    
    override func openWebLinkViewController(url: URL?,
                                            presentingViewController: UIViewController) {
        lastOpenUrl = url
        lastPresentingViewController = presentingViewController
    }
    
}

extension WebLinks {
    
    static func fake() -> FakeWebLinks { FakeWebLinks() }
    
}
