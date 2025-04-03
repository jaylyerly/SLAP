//
//  Alert.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import UIKit

class Alert {
    
    func displayErrorWithMessage(_ msg: String,
                                 title: String = "Alert",
                                 presentingViewController parentVC: UIViewController,
                                 completion: Completion? = nil ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
            completion?()
        }
        alert.addAction(okAction)
        parentVC.present(alert, animated: true, completion: nil)
    }
    
    func display(_ error: Error, presenter: UIViewController) {
        let msg = error.localizedDescription
        let title = "Error"
        displayErrorWithMessage(msg,
                                title: title,
                                presentingViewController: presenter)
        
    }
}
