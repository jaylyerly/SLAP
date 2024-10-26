//
//  ViewControllerFactory.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

private func vcFactory<T: UIViewController>(_ storyboardName: String,
                                            appEnv: AppEnv) -> T {
    let sBoard = UIStoryboard(name: storyboardName, bundle: nil)
    
    let viewController: T?
    
    // If the class is a AppVC, inject the AppEnv during instantiation
    if let U = T.self as? AppViewController.Type {                   // swiftlint:disable:this identifier_name
        viewController = sBoard.instantiateInitialViewController { coder  in
            U.init(coder: coder, appEnv: appEnv)                   // swiftlint:disable:this explicit_init
        } as? T
    } else {
        viewController = sBoard.instantiateInitialViewController() as? T
    }
    
    return viewController!          // swiftlint:disable:this force_unwrapping
}

private func vcFactory<T: UIViewController>(_ storyboardName: String,
                                            vcGenerator: @escaping ( (NSCoder) -> T? )) -> T {
    let sBoard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = sBoard.instantiateInitialViewController { coder -> T? in
        vcGenerator(coder)
    }
    return viewController!          // swiftlint:disable:this force_unwrapping
    
}

enum ViewControllerFactory {
    
    static func main(appEnv: AppEnv) -> MainViewController {
        vcFactory("Main", appEnv: appEnv)
    }
    
    static func list(appEnv: AppEnv, mode: ListMode) -> ListViewController {
        vcFactory("List") { coder in
            ListViewController(coder: coder, appEnv: appEnv, mode: mode)
        }
    }
    
    static func detail(appEnv: AppEnv, detailId: String) -> DetailViewController {
        vcFactory("Detail") { coder in
            DetailViewController(coder: coder, appEnv: appEnv, detailId: detailId)
        }
    }
    
    static func links(appEnv: AppEnv) -> LinksViewController {
        LinksViewController(appEnv: appEnv)
    }

}
