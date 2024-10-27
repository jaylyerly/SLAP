//
//  MainViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import SafariServices
import UIKit

class MainViewController: UITabBarController, AppViewController {
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
        delegate = self

        let adoptVC = ViewControllerFactory.list(appEnv: appEnv, mode: .adoptables)
        let adoptNavVC = UINavigationController(rootViewController: adoptVC)
        
        let favoritesVC = ViewControllerFactory.list(appEnv: appEnv, mode: .favorites)
        let favNavVC = UINavigationController(rootViewController: favoritesVC)

        let storeVC = ViewControllerFactory.links(appEnv: appEnv)
        storeVC.tabBarItem.tag = MainTabBarTag.links.rawValue
        
        setViewControllers([adoptNavVC, favNavVC, storeVC], animated: false)
        
        selectedIndex = defaults.mainTabBarSelection.rawValue
    }
    
}

extension MainViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selection = MainTabBarTag(rawValue: item.tag) else { return }
        defaults.mainTabBarSelection = selection
    }
    
}
