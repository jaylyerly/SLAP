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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contentStack: UIStackView!
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let objectId: NSManagedObjectID
    let rabbit: Rabbit?
    var favoritesButtonItem: UIBarButtonItem?
    
    required init?(coder: NSCoder,
                   appEnv: AppEnv,
                   objectId: NSManagedObjectID) {
        self.appEnv = appEnv
        self.objectId = objectId
        self.rabbit = try? appEnv.storage.rabbit(withId: objectId)
        
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
    
    func buildImageView() -> UIImageView {
        let view = UIImageView()
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).activate("imageAspect1")
        return view
    }
    
    func setupInterface() {
        let fabButtonItem = UIBarButtonItem(image: Images.isNotFavorite.img,
                                            style: .plain,
                                            target: self,
                                            action: #selector(DetailViewController.toggleFavorite(_:)))
        navigationItem.rightBarButtonItem = fabButtonItem
        favoritesButtonItem = fabButtonItem
        
        guard let rabbit else { return }
        
        title = rabbit.name
        
        rabbit.photos.forEach { iModel in
            let imageView = buildImageView()
            iModel.load(storage: storage) { data in
                if let data {
                    imageView.image = UIImage(data: data)
                }
            }
            contentStack.addArrangedSubview(imageView)
        }
    }
    
    func updateInterface() {
        guard let rabbit else {
            nameLabel.text = "<UNKNOWN>"
            infoLabel.text = ""
            descriptionLabel.text = ""
            return
        }
        
        nameLabel.text = rabbit.name
        infoLabel.text = "Age: \(rabbit.age)  Weight: \(rabbit.weight)"
        descriptionLabel.text = rabbit.rabbitDescription
        
        favoritesButtonItem?.image = rabbit.isFavorite ? Images.isFavorite.img : Images.isNotFavorite.img
    }
    
    @IBAction func toggleFavorite(_ sender: Any?) {
        do {
            try storage.toggle(favoriteRabbit: rabbit)
        } catch {
            logger.error("Failed to toggle favorite: \(error)")
        }
        updateInterface()
    }
}
