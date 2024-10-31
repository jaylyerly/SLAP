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
    let internalId: String
    var favoritesButtonItem: UIBarButtonItem?
    var fetchController: NSFetchedResultsController<Rabbit>?
    var refreshControl = UIRefreshControl()
    
    var rabbit: Rabbit? {
        try? storage.rabbit(withInternalId: internalId)
    }

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
            return String(format: "Weight: %.0f lbs", rabbit.weight)
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
    @IBOutlet weak var scrollView: UIScrollView!

    required init?(coder: NSCoder,
                   appEnv: AppEnv,
                   internalId: String) {
        self.appEnv = appEnv
        self.internalId = internalId

        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()

        setupInterface()
        updateInterface()
        
        // watch for updates
        setupFetchController()
    }
    
    @IBAction func toggleFavorite(_ sender: Any?) {
        do {
            try storage.toggle(favoriteRabbit: rabbit)
        } catch {
            logger.error("Failed to toggle favorite: \(error)")
        }
        updateInterface()
    }
    
    @IBAction func didPullToRefresh(_ sender: Any?) {
        refreshData()
        // Let the spinner hang around for a bit so user sees it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func setupFetchController() {
        let fetchRequest: NSFetchRequest<Rabbit> = Rabbit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K like %@", #keyPath(Rabbit.internalId), internalId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: storage.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            logger.error("Failed to start FRC to monitor changes in detail controller: \(error)")
        }
        fetchController = frc
    }
    
    func refreshData() {
        Task {
            try await api.refresh(withInternalId: internalId)
        }
    }
    
    func buildImageView() -> UIImageView {
        let view = UIImageView()
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).activate("imageAspect1")
        return view
    }
    
    func setupInterface() {
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = Style.accentSecondaryColor
        refreshControl.addTarget(self,
                                 action: #selector(Self.didPullToRefresh(_:)),
                                 for: .valueChanged)
        
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

extension DetailViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        updateInterface()
    }
    
}
