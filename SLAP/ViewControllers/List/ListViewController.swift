//
//  ListViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import OSLog
import UIKit

enum ListSection: Int {
    case main = 0
}

enum ListItem: Hashable {
    
    case rabbit(String) // uniqueId
    
    var rabbitInternalId: String? {
        switch self {
            case .rabbit(let internalId):
                return internalId
        }
    }
    
    func rabbit(fromStorage storage: Storage) -> Rabbit? {
        guard let internalId = rabbitInternalId else { return nil }
        return try? storage.rabbit(withInternalId: internalId)
    }
}

class ListViewController: UICollectionViewController, AppEnvConsumer {
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let mode: ListMode

    var dataSource: UICollectionViewDiffableDataSource<ListSection, ListItem>?

    let configuration: UICollectionLayoutListConfiguration = {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = .firstItemInSection
        config.backgroundColor = .clear
        return config
    }()
    
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

        collectionView.setCollectionViewLayout(getLayout(), animated: false)
        title = mode.title
        
        configureDataSource()

        loadInitialData()
        refreshData()
    }
    
    private func getLayout() -> UICollectionViewLayout {
        let mainSection: NSCollectionLayoutSection = {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 1)
            group.edgeSpacing = .init(leading: nil, top: .fixed(12), trailing: nil, bottom: nil)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }()
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = ListSection(rawValue: sectionIndex) else {
                return mainSection
            }
            
            switch section {
                case .main:
                    return mainSection
            }
        }
        return layout
    }
    
    private func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<ListCell, ListItem> {
            [weak self] cell, _, item in
            guard let self else { return }
            
            cell.configureFor(listItem: item, appEnv: appEnv)
            
            // Cause the cover photo to load if its not cached in the DB.
            if let coverPhoto = item.rabbit(fromStorage: storage)?.coverPhoto {
                if !coverPhoto.hasImageData {
                    logger.info("Loading cover photo")
                    coverPhoto.load(storage: storage) { [weak self] _ in
                        self?.logger.info("Cover photo loaded, reconfiguring item")
                        self?.reconfigure(withItem: item)
                    }
                }
            }
        }
    
        dataSource = UICollectionViewDiffableDataSource<ListSection, ListItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ListItem) -> UICollectionViewCell? in
            
            let cell = collectionView
                .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }
        
    }
    
    private func reconfigure(withItem item: ListItem) {
        guard let dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([item])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func loadInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>()
        snapshot.appendSections([.main])
        let items = storage.rabbits
            .compactMap { $0.internalId }
            .map { ListItem.rabbit($0) }
        if items.isEmpty {
            // FIXEM -- add some 'empty content' cell here
        } else {
            snapshot.appendItems(items)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)  // don't animated on initial load
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
