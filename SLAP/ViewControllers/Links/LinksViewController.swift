//
//  StoreViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import UIKit

class LinksViewController: UIViewController, AppEnvConsumer {
    var appEnv: AppEnv
    
    let logger = Logger.defaultLogger()
    
    lazy var heroImageView: UIImageView = {
        let banner = Images.banner.img
        let aspect = banner.size.height / banner.size.width
        let view = UIImageView(image: banner)
        
        // Lock the aspect of the image view to the image aspect
        view.heightAnchor.constraint(equalTo: view.widthAnchor,
                                     multiplier: aspect)
            .activate("BannerAspect")
        
        return view
    }()
    
    lazy var storeButton: UIButton = {
        let action = UIAction(title: " Shop",
                              image: Images.store.img) { [weak self] action in
            self?.storeAction(action)
        }
        return buildButton(action: action)
    }()
    
    lazy var websiteButton: UIButton = {
        let action = UIAction(title: " WebSite",
                              image: Images.house.img) { [weak self] action in
            self?.websiteAction(action)
        }
        return buildButton(action: action)
    }()

    lazy var buttonRow1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.addArrangedSubview(websiteButton)
        stackView.addArrangedSubview(storeButton)
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.spacing = 12
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.addArrangedSubview(heroImageView)
        mainStackView.addArrangedSubview(buttonRow1)
        mainStackView.addArrangedSubview(Spacer())

        return mainStackView
    }()
    
    init(appEnv: AppEnv) {
        self.appEnv = appEnv
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Links", image: Images.link.img, tag: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        title = "Links"
    }
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubViewEdgeToSafeEdge(mainStackView, verticalMargin: 16, horizontalMargin: 16)
    }
    
    private func buildButton(action: UIAction) -> UIButton {
        let button = UIButton(primaryAction: action)
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1.0)
            .activate("ButtonAspect")
        button.backgroundColor = .accent
        button.tintColor = .white
        button.cornerRounding = 16
        button.titleLabel?.font = Style.bodyFont
        return button

    }
}

extension LinksViewController {
    
    @IBAction func storeAction(_ sender: Any?) {
        webLinks.openWebLinkViewController(
            url: config.storeUrl,
            presentingViewController: self
        )
    }
    
    @IBAction func websiteAction(_ sender: Any?) {
        webLinks.openWebLinkViewController(
            url: config.homeUrl,
            presentingViewController: self
        )
    }

}
