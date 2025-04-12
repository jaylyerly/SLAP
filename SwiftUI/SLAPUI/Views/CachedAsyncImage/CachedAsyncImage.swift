//
//  CachedAsyncImage.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/11/25.
//

import OSLog
import SwiftUI

struct OldCachedAsyncImage: View {
    
    let cache = URLCache.shared
    let url: URL?
    let placeholderAssetName: String
    let logger = Logger.defaultLogger()
    
    var body: some View {
        
        if let url, let response = cache.cachedResponse(for: URLRequest(url: url)) {
            Image(data: response.data)
                .accessibilityHidden(true)
        } else {
            
            AsyncImage(url: url,
                       content: { image in
                cacheAndRender(image: image)
            },
                       placeholder: {
                Image(placeholderAssetName)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Loading...")
            })
        }
    }
    
    private func cacheAndRender(image: Image) -> some View {
        let msg = "Cache miss! -- downloading image from \(String(describing: url))"
        logger.debug("\(msg)")
        if let url, let data = image.pngData() {
            let resp = URLResponse(url: url, mimeType: "image/png", expectedContentLength: 0, textEncodingName: nil)
            let cachedResp = CachedURLResponse(response: resp, data: data)
            cache.storeCachedResponse(cachedResp, for: URLRequest(url: url))
        }

        return image
            .resizable()
            .scaledToFit()
    }
    
}
