//
//  LinksUIViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 4/25/25.
//

import SwiftUI
import UIKit

class LinksUIViewController: UIHostingController<LinksWrapper<Links>> {

    init(config: Config) {
        let root = LinksWrapper(content: Links(), config: config)
        super.init(rootView: root)
        tabBarItem = UITabBarItem(title: "LinksUI", image: Images.link.img, tag: 0)
    }
    
    @available(*, unavailable)
    @MainActor @preconcurrency dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
