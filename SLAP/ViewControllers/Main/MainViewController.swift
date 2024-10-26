//
//  MainViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import UIKit

class MainViewController: UIViewController, AppViewController {
    var appEnv: AppEnv
    
    let logger = Logger.defaultLogger()

    required init?(coder: NSCoder, appEnv: AppEnv) {
        self.appEnv = appEnv
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateInterface()
    }

    func updateInterface() {
        
    }
}
