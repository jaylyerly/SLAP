//
//  Safari.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/25/25.
//

#if os(iOS)

import SafariServices
import SwiftUI

struct Safari: UIViewControllerRepresentable {
    let destination: URL
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> SFSafariViewController {
        SFSafariViewController(url: destination)
    }
    
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<Self>
    ) {
        // access SwiftUI environment here
    }
}

#endif
