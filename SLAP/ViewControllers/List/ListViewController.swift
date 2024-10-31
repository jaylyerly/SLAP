//
//  ListViewController.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import CoreData
import OSLog
import UIKit

private let mainListSection = "main"

class ListViewController: UICollectionViewController, AppEnvConsumer {
    
    var appEnv: AppEnv
    let logger = Logger.defaultLogger()
    let mode: ListMode

    var dataSource: UICollectionViewDiffableDataSource<String, NSManagedObjectID>?
    var fetchResultsController: NSFetchedResultsController<Rabbit>?
    
    let configuration: UICollectionLayoutListConfiguration = {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = .firstItemInSection
        config.backgroundColor = .clear
        return config
    }()
    private let refreshControl = UIRefreshControl()

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
            collectionView.refreshControl = refreshControl // iOS 10+
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
    
    @IBAction func didPullToRefresh(_ sender: Any?) {
        refreshData()
        // Let the spinner hang around for a bit so user sees it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
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
        
        let layout = UICollectionViewCompositionalLayout { _, _ in
            mainSection
        }
        return layout
    }
    
    private func configureDataSource() {

        let cellRegistration = 
        UICollectionView.CellRegistration<ListCell, NSManagedObjectID> { [weak self] cell, _, item in
            guard let self else { return }
            
            cell.configureFor(objectId: item, appEnv: appEnv)
            
            // Cause the cover photo to load if its not cached in the DB.
            if let rabbit = try? storage.rabbit(withId: item),
               let coverPhoto = rabbit.coverPhoto {
                if !coverPhoto.hasImageData {
                    logger.info("Begin Loading cover photo")
                    coverPhoto.load(storage: storage) { [weak self] _ in
                        self?.logger.info("Cover photo loaded, reconfiguring item")
                        self?.reconfigure(withItem: item)
                    }
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, NSManagedObjectID>(collectionView: collectionView) {
            // swiftlint:disable:next closure_parameter_position
            (colView: UICollectionView, indexPath: IndexPath, item: NSManagedObjectID) -> UICollectionViewCell? in
            
            let cell = colView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }
        
    }
    
    private func reconfigure(withItem item: NSManagedObjectID) {
        guard let dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([item])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func loadInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<String, NSManagedObjectID>()
        snapshot.appendSections([mainListSection])
        let items = storage.rabbits
            .compactMap { $0.objectID }
        if items.isEmpty {
            // FIXME -- add some 'empty content' cell here
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
    
//    @IBAction func didPullToRefresh(_ sender: Any?) {
//        refreshData()
//        // Let the spinner hang around for a bit so user sees it
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
//            self?.refreshControl.endRefreshing()
//        }
//    }
}

extension ListViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        let detailVC = ViewControllerFactory.detail(appEnv: appEnv, objectId: item)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}

extension ListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshotRef: NSDiffableDataSourceSnapshotReference) {
        
        let snapshot = snapshotRef as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        
        if mode == .favorites {
            logger.info("Updating favorites list with \(snapshot.numberOfItems) items")
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
