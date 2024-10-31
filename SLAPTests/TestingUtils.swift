//
//  TestingUtils.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/31/24.
//

import UIKit
import XCTest

// Assert that the given button has the correct target object and selector
func assertActionsContain<T: NSObject>(_ selector: Selector,
                                       forControl control: UIControl?,
                                       withTarget target: T,
                                       forEvent event: UIControl.Event = .touchUpInside) {
    assertActionsContain(NSStringFromSelector(selector), forControl: control, withTarget: target, forEvent: event)
}

func assertActionsContain<T: NSObject>(_ name: String,
                                       forControl control: UIControl?,
                                       withTarget target: T,
                                       forEvent event: UIControl.Event = .touchUpInside) {
    guard let control else {
        XCTFail("Value of control is nil")
        return
    }
    var containsTarget = false
    control.allTargets.forEach { someTarget in
        if (someTarget as? T) == target {
            containsTarget = true
        }
    }
    XCTAssertTrue(containsTarget)
    if let actions = control.actions(forTarget: target, forControlEvent: event) {
        XCTAssertTrue(actions.contains(name), "Action for \(name) not found in \(target).")
    } else {
        XCTFail("Failed to get actions for \(target)")
    }
}

// Assert that the given BarButtonItem has the correct target object and selector
func assertBarButtonAction(_ selector: Selector,
                           forBarButtonItem barButton: UIBarButtonItem?,
                           withTarget target: AnyObject?) {
    assertBarButtonAction(NSStringFromSelector(selector), forBarButtonItem: barButton, withTarget: target)
}

func assertBarButtonAction(_ name: String,
                           forBarButtonItem barButton: UIBarButtonItem?,
                           withTarget target: AnyObject?) {
    guard let barButton else {
        XCTFail("Value of barButton is nil")
        return
    }
    XCTAssertTrue(barButton.target === target)
    let action = barButton.action?.description
    
    XCTAssertEqual(action, name, "Action for \(name) not found in \(String(describing: target?.description!)).")
}
