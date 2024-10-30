//
//  ListCell.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/29/24.
//

import CoreData
import UIKit

class ListCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameView = UILabel()
//
//    private var validLayoutBounds: CGRect? = nil
//    private var validSizeThatFits: CGSize? = nil

    var rabbit: Rabbit? {
        didSet { updateInterface() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .secondarySystemBackground
//        imageView.clipsToBounds = true
        
//        contentView.addSubview(imageView)
//        contentView.addSubview(propertiesView)
//        
//        contentView.layer.cornerCurve = .continuous
//        contentView.layer.cornerRadius = 12.0
//        self.pushCornerPropertiesToChildren()
//        
//        layer.shadowOpacity = 0.2
//        layer.shadowRadius = 6.0
        setupInterface()
    }
    
    func setupInterface() {
        imageView.image = Images.placeholderRabbit.img
//        imageView.image = Images.store.img
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        
        nameView.text = ""
        nameView.font = Style.accentFont
        nameView.backgroundColor = Style.accentBackgroundColor
        nameView.textColor = Style.accentForegroundColor
        nameView.textAlignment = .center
        nameView.heightAnchor.constraint(equalToConstant: nameView.font.lineHeight + 16)
            .isActive = true
        nameView.roundCorners(.allCorners, radius: 8)
        
        contentView.addSubViewEdgeToSafeEdge(imageView)
        
        addSubview(nameView)
        nameView.translatesAutoresizingMaskIntoConstraints = false

        let safe = safeAreaLayoutGuide
        
        safe.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: -12).isActive = true
        safe.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: 12).isActive = true
        safe.bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 12).isActive = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureFor(objectId: NSManagedObjectID, appEnv: AppEnv) {
        guard let rabbit = try? appEnv.storage.rabbit(withId: objectId) else { return }
        
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
        
    }
    
}
