//
//  ListViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import UIKit

class ListViewController: UICollectionViewController, AppEnvConsumer {
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let mode: ListMode

    required init?(coder: NSCoder, 
                   appEnv: AppEnv,
                   mode: ListMode) {
        self.appEnv = appEnv
        self.mode = mode
        super.init(coder: coder)
        
        tabBarItem = UITabBarItem(
            title: mode.title,
            image: mode.image(images),
            tag: 0
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
