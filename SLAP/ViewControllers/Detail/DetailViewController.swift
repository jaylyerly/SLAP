//
//  DetailViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import UIKit

class DetailViewController: UIViewController, AppEnvConsumer {
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let detailId: String
    
    required init?(coder: NSCoder,
                   appEnv: AppEnv,
                   detailId: String) {
        self.appEnv = appEnv
        self.detailId = detailId
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
