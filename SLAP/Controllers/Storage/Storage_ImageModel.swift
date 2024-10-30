//
//  Storage_ImageModel.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/28/24.
//

import CoreData
import Foundation
import UIKit

typealias ImageModelResult = Result<ImageModel, Error>

extension Storage {
//    func createImageModel(withUrlString urlString: String,
//                          isCover: Bool = false) -> ImageModelResult {
//        let iModel = ImageModel(context: persistentContainer.viewContext)
//        iModel.url = urlString
//        iModel.isCover = isCover
//
//        return ImageModelResult {
//            try save(failureMessage: "Failed to save ImageModel")
//            return iModel
//        }
//    }
    
//    storage.saveImage(uiImage, forImageModelId: objectID)

    func saveImageData(_ data: Data?, forImageModelId objId: NSManagedObjectID) throws {
        guard let data else { return }
        
        let iModel = try object(with: objId, type: ImageModel.self)
        iModel.pngData = data
        try save(failureMessage: "Fail to save image data for ImageModel")
    }
}
