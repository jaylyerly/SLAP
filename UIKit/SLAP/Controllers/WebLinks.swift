//
//  Safari.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import SafariServices

class WebLinks {
    
    func openWebLinkViewController(
        url: URL?,
        presentingViewController: UIViewController
    ) {
        guard let url else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.isModalInPresentation = true
        presentingViewController.present(safariVC, animated: true)
    }
    
}
