//
//  ListCell.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/29/24.
//

import OSLog
import UIKit

class ListCell: UICollectionViewCell {
    
    private let logger = Logger.defaultLogger()
    
    private let imageView = UIImageView()
    private let nameView = UILabel()
    private let favButton = UIButton(type: .custom)

    var rabbit: Rabbit? {
        didSet { updateInterface() }
    }
    
    var appEnv: AppEnv?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInterface()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func toggleFavorite(_ sender: Any?) {
        do {
            try appEnv?.storage.toggle(favoriteRabbit: rabbit)
        } catch {
            logger.error("Failed to toggle isFavorite: \(error)")
        }
        updateInterface()
    }
    
    func setupImageView() {
        imageView.image = Images.placeholderRabbit.img
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
    }
    
    func setupNameView() {
        nameView.text = ""
        nameView.font = Style.accentFont
        nameView.backgroundColor = Style.accentBackgroundColor
            .withAlphaComponent(0.7)
        nameView.textColor = Style.accentForegroundColor
        nameView.textAlignment = .center
        nameView.heightAnchor.constraint(equalToConstant: nameView.font.lineHeight + 16)
            .isActive = true
        nameView.roundCorners(.allCorners, radius: Style.cornerRadius)
    }
    
    func setupFavButton() {
        let conf = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let offImage = UIImage(systemName: Images.isNotFavorite.rawValue, withConfiguration: conf)
        let onImage = UIImage(systemName: Images.isFavorite.rawValue, withConfiguration: conf)

        favButton.tintColor = Style.accentSecondaryColor
        favButton.setImage(offImage, for: .normal)
        favButton.setImage(onImage, for: .selected)
        favButton.isSelected = false
        favButton.addTarget(self,
                            action: #selector(Self.toggleFavorite(_:)),
                            for: .touchUpInside)
        
        favButton.widthAnchor
            .constraint(equalToConstant: 44)
            .activate("favWidth")
        favButton.heightAnchor
            .constraint(equalToConstant: 44)
            .activate("favHeight")
    }
                              
    func setupInterface() {
        setupImageView()
        setupNameView()
        setupFavButton()
        
        contentView.addSubViewEdgeToSafeEdge(imageView)
        
        addSubview(nameView)
        nameView.translatesAutoresizingMaskIntoConstraints = false

        let safe = safeAreaLayoutGuide
        
        safe.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: -12).isActive = true
        safe.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: 12).isActive = true
        safe.bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 12).isActive = true
        
        addSubview(favButton)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        safe.trailingAnchor
            .constraint(equalTo: favButton.trailingAnchor, constant: 12)
            .activate("favButtonTrailing")
        safe.topAnchor
            .constraint(equalTo: favButton.topAnchor, constant: -12)
            .activate("favButtonTop")
    }
        
    func configureFor(listItem: ListItem, appEnv: AppEnv) {
        self.appEnv = appEnv
        guard let rabbit = listItem.rabbit(fromStorage: appEnv.storage) else { return }
        self.rabbit = rabbit
        
        nameView.text = rabbit.name
        if let coverImageData = rabbit.coverPhoto?.pngData {
            // Don't overwrite the placeholder with a nil image
            imageView.image = UIImage(data: coverImageData)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rabbit = nil
    }
    
    func updateInterface() {
        guard let rabbit else {
            imageView.image = Images.placeholderRabbit.img
            nameView.text = ""
            return
        }
        
        nameView.text = rabbit.name
        favButton.isSelected = rabbit.isFavorite
    }
        
}
