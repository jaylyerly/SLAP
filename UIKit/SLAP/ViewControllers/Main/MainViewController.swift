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
        view.backgroundColor = Style.accentBackgroundColor
        
        let adoptVC = ViewControllerFactory.list(appEnv: appEnv, mode: .adoptables)
        adoptVC.tabBarItem.tag = MainTabBarTag.adoptables.rawValue
        let adoptNavVC = UINavigationController(rootViewController: adoptVC)
        style(adoptNavVC)
        
        let favoritesVC = ViewControllerFactory.list(appEnv: appEnv, mode: .favorites)
        favoritesVC.tabBarItem.tag = MainTabBarTag.favorites.rawValue
        let favNavVC = UINavigationController(rootViewController: favoritesVC)
        style(favNavVC)
        
        let linksVC = ViewControllerFactory.links(appEnv: appEnv)
        linksVC.tabBarItem.tag = MainTabBarTag.links.rawValue
        let linksNavVC = UINavigationController(rootViewController: linksVC)
        style(linksNavVC)

        setViewControllers([adoptNavVC, favNavVC, linksNavVC], animated: false)
        
        selectedIndex = defaults.mainTabBarSelection.rawValue
        
        styleTabBar()
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
    }
    
    func styleTabBar() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Style.accentBackgroundColor
        
        tabBar.standardAppearance = appearance
        tabBar.isTranslucent = false
    }
    
    func style(_ navVC: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Style.accentBackgroundColor
        appearance.titleTextAttributes = [
            .foregroundColor: Style.accentForegroundColor,
            .backgroundColor: Style.accentBackgroundColor,
            .font: Style.accentFont,
        ]
        navVC.navigationBar.standardAppearance = appearance
        navVC.navigationBar.compactAppearance = appearance
        navVC.navigationBar.scrollEdgeAppearance = appearance
        
        navVC.navigationBar.barStyle = .default
        navVC.navigationBar.isTranslucent = false
        navVC.navigationBar.tintColor = Style.accentForegroundColor

    }
}

extension MainViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selection = MainTabBarTag(rawValue: item.tag) else { return }
        defaults.mainTabBarSelection = selection
    }
    
}
