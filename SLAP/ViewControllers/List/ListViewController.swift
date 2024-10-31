//
//  ListViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import CoreData
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
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let mode: ListMode

    var dataSource: UICollectionViewDiffableDataSource<ListSection, ListItem>?
    var fetchResultsController: NSFetchedResultsController<Rabbit>?
    
    let configuration: UICollectionLayoutListConfiguration = {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = .firstItemInSection
        config.backgroundColor = .clear
        return config
    }()
    let refreshControl = UIRefreshControl()

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
        
        // Suppress the title on the back button for sub VCs
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        collectionView.setCollectionViewLayout(getLayout(), animated: false)
        collectionView.backgroundColor = .black
        title = mode.title
        
        if mode == .adoptables {
            refreshControl.tintColor = Style.accentSecondaryColor
            refreshControl.addTarget(self,
                                     action: #selector(Self.didPullToRefresh(_:)),
                                     for: .valueChanged)
            collectionView.refreshControl = refreshControl
        }
        
        configureDataSource()
        
        fetchResultsController = mode.fetchResultsController(storage: storage)
        fetchResultsController?.delegate = self
        do {
            try fetchResultsController?.performFetch()
        } catch {
            logger.error("Failed to perform fetch on FRC: \(error)")
        }
        
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reconfigure all on screen cells.  Otherwise, they seem to miss some updates
        reconfigureOnScreenCells(animatingDifferences: false)
    }
    
    @IBAction func didPullToRefresh(_ sender: Any?) {
        refreshData()
        // Let the spinner hang around for a bit so user sees it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func reconfigureOnScreenCells(animatingDifferences: Bool) {
        guard let dataSource else { return }
        let onScreenItems = collectionView.indexPathsForVisibleItems
            .compactMap { dataSource.itemIdentifier(for: $0) }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(onScreenItems)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getLayout() -> UICollectionViewLayout {
        let mainSection: NSCollectionLayoutSection = {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

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

        let cellRegistration = 
        UICollectionView.CellRegistration<ListCell, ListItem> { [weak self] cell, _, item in
            guard let self else { return }
            
            cell.configureFor(listItem: item, appEnv: appEnv)

            // Cause the cover photo to load if its not cached in the DB.
            if let coverPhoto = item.rabbit(fromStorage: storage)?.coverPhoto {
                if !coverPhoto.hasImageData {
                    logger.info("Begin Loading cover photo")
                    coverPhoto.load(storage: storage) { [weak self] _ in
                        self?.logger.info("Cover photo loaded, reconfiguring item")
                        self?.reconfigure(withItem: item)
                    }
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<ListSection, ListItem>(collectionView: collectionView) {
            // swiftlint:disable:next closure_parameter_position
            (colView: UICollectionView, indexPath: IndexPath, item: ListItem) -> UICollectionViewCell? in
            
            let cell = colView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }
        
    }
    
    private func reconfigure(withItem item: ListItem) {
        guard let dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([item])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func snapshotFromStorage() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let items = storage.rabbits
            .compactMap { $0.internalId }
            .map { ListItem.rabbit($0) }
        if items.isEmpty {
            // FIXME -- add some 'empty content' cell here
        } else {
            snapshot.appendItems(items)
        }
        return snapshot
    }
    
    func loadInitialData() {
        dataSource?.apply(snapshotFromStorage(), animatingDifferences: false)  // don't animated on initial load
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

extension ListViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath), let internalId = item.rabbitInternalId else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        let detailVC = ViewControllerFactory.detail(appEnv: appEnv, internalId: internalId)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}

extension ListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshotRef: NSDiffableDataSourceSnapshotReference) {
        
        // NB: Based on translator described at https://www.avanderlee.com/swift/diffable-data-sources-core-data/
        // TLDR - the FRC snapshot is based on the objectID of the managed object, but that
        // can change from temp to permanent, so it doesn't work well as the primary cell ID.
        // Need to translate the modelID to internalID (aka ListItem)
        
        guard let dataSource else {
            assertionFailure("CollectionView has no dataSource!")
            return
        }
        
        // The snapshot from the FRC is based on the managed object ID changes
        let managedSnapshot = snapshotRef as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        // The real snapshot is based on ListItem identifiers
        var listItemSnapshot = dataSource.snapshot()
        
        let reloadIdentifiers: [ListItem] = managedSnapshot.itemIdentifiers.compactMap { objectId -> ListItem? in
            // get the internalID associated with the managed object for the objectId
            guard let rabbit = try? storage.rabbit(withId: objectId), 
                    let internalId = rabbit.internalId else { return nil }
            let item = ListItem.rabbit(internalId)
            
            // Compare the new and old indices, make sure they match
            guard let currentIndex = listItemSnapshot.indexOfItem(item),
                    let index = managedSnapshot.indexOfItem(objectId),
                    index == currentIndex else {
                return nil
            }
  
            return item
        }
        
        // Force reconfigure on these guys. DiffableDataSource would ignore otherwise b/c their IDs are the same.
        listItemSnapshot.reloadItems(reloadIdentifiers)
        
        // Now just make a new snapshot by translating the managed object IDs into ListItems.
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let items = managedSnapshot.itemIdentifiers
            .compactMap { try? storage.rabbit(withId: $0).internalId }
            .map { ListItem.rabbit($0) }
            
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)        
    }
}
