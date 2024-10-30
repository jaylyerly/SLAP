//
//  DetailViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import UIKit

class DetailViewController: UIViewController, AppEnvConsumer {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var contentStack: UIStackView!
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let internalId: String
    let rabbit: Rabbit?
    
    required init?(coder: NSCoder,
                   appEnv: AppEnv,
                   internalId: String) {
        self.appEnv = appEnv
        self.internalId = internalId
        self.rabbit = try? appEnv.storage.rabbit(withInternalId: internalId)
        
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            try await api.refresh(withInternalId: internalId)
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

        guard let rabbit else { return }
        
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
        
    }
}
