//
//  ImageModel.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/28/24.
//

import CoreData
import OSLog
import UIKit

class ImageModel: NSManagedObject {}

typealias ImageLoadCompletion = (Data?) -> Void

extension ImageModel {
    
    var hasImageData: Bool {
        pngData != nil
    }
    
    func load(storage: Storage, completion: @escaping ImageLoadCompletion) {
        // Bail if there's no url
        guard let url, let realUrl = URL(string: url) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        // If there's an image already cached, just hand that back.
        if let pngData {
            DispatchQueue.main.async {
                completion(pngData)
            }
            return
        }
        
        Task {
            let (data, _) = try await URLSession.shared.data(from: realUrl)
            let image = UIImage(data: data)
            let pngData = image?.pngData()     // save everything as PNG

            // Save the image first, so hasUiImage will reflect the correct state
            do {
                try storage.saveImageData(pngData, forImageModelId: objectID)
            } catch {
                Logger.defaultLogger().error("Failed to save image data: \(error)")
            }

            DispatchQueue.main.async {
                completion(pngData)
            }
                        
        }
        
    }
    
}
