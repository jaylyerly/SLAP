//
//  main.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

// Switch active AppDelegate at startup so as not to create full app instance during unit tests
// http://qualitycoding.org/app-delegate-for-tests/

let appDelegateClass: AnyClass = NSClassFromString("SLAP.TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  NSStringFromClass(appDelegateClass))
