//
//  UIAction.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

extension UIAction {

    // Notes: Low level cheat for executing a UIAction, only
    // appropriate for testing
    private typealias ActionHandlerBlock = @convention(block) (UIAction) -> Void

    var handler: UIActionHandler {
        let handler = value(forKey: "handler") as AnyObject
        return unsafeBitCast(handler, to: ActionHandlerBlock.self)
    }

    /// Run the UIActionHandler
    func execute() {
        handler(self)
    }

}
