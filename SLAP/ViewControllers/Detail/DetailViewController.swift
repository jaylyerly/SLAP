//
//  DetailViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import CoreData
import OSLog
import UIKit

class DetailViewController: UIViewController, AppEnvConsumer {

    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let objectId: NSManagedObjectID?
    let rabbit: Rabbit?
    var favoritesButtonItem: UIBarButtonItem?

    private var ageText: String {
        guard let rabbit else { return "" }

        if rabbit.age > 0 {
            if rabbit.age < 1 {
                return String(format: "Age: Under 1 year")
            }
            if rabbit.age < 2 {
                return String(format: "Age: 1 year")
            }
            return String(format: "Age: %.0f years", rabbit.age)
        }
        return ""
    }
    
    private var weightText: String {
        guard let rabbit else { return "" }

        if rabbit.weight > 0 {
            return String(format: "Weight: %.0f lbs.", rabbit.weight)
        }
        return ""
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var innerContentContainer: UIView!
    @IBOutlet weak var outerContentContainer: UIView!

    required init?(coder: NSCoder,
                   appEnv: AppEnv,
                   objectId: NSManagedObjectID?) {
        self.appEnv = appEnv
        self.objectId = objectId
        if let objectId {
            self.rabbit = try? appEnv.storage.rabbit(withId: objectId)
        } else {
            self.rabbit = nil
        }

        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            if let internalId = rabbit?.internalId {
                try await api.refresh(withInternalId: internalId)
            }
        }
        setupInterface()
        updateInterface()
    }
    
    @IBAction func toggleFavorite(_ sender: Any?) {
        do {
            try storage.toggle(favoriteRabbit: rabbit)
        } catch {
            logger.error("Failed to toggle favorite: \(error)")
        }
        updateInterface()
    }
    
    func buildImageView() -> UIImageView {
        let view = UIImageView()
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).activate("imageAspect1")
        return view
    }
    
    func setupInterface() {
//        [ageLabel, weightLabel, descriptionLabel].forEach { lbl in
//            lbl.font = Style.bodyFont
//        }
//        
        let fabButtonItem = UIBarButtonItem(image: Images.isNotFavorite.img,
                                            style: .plain,
                                            target: self,
                                            action: #selector(Self.toggleFavorite(_:)))
        navigationItem.rightBarButtonItem = fabButtonItem
        favoritesButtonItem = fabButtonItem
        
        outerContentContainer.backgroundColor = Style.accentBackgroundColor
        innerContentContainer.backgroundColor = Style.accentForegroundColor
        innerContentContainer.roundCorners(.allCorners, radius: Style.cornerRadius * 2)

        guard let rabbit else { return }
        
        title = rabbit.name
        
        rabbit.photos.forEach { iModel in
            let imageView = buildImageView()
            iModel.load(storage: storage) { data in
                if let data {
                    imageView.image = UIImage(data: data)
                }
            }
            imageStack.addArrangedSubview(imageView)
        }
    }
    
    func updateInterface() {
        view.backgroundColor = Style.accentBackgroundColor
        
        ageLabel.text = ageText
        weightLabel.text = weightText
        
        guard let rabbit else {
            descriptionLabel.text = ""
            return
        }
        
        descriptionLabel.text = rabbit.rabbitDescription
        
        favoritesButtonItem?.image = rabbit.isFavorite ? Images.isFavorite.img : Images.isNotFavorite.img
    }
    
}
