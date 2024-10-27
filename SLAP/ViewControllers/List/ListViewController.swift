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
            image: mode.image,
            tag: 0
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    func refreshData() {
        switch mode {
            case .adoptables:
                Task {
                    do {
                        try await api.refreshList()
                    } catch {
                        alert.display(error, presenter: self)
                    }
                }
            case .favorites:
                // Favorites are stored locally, nothing to refresh
                break
        }
        
    }
}
