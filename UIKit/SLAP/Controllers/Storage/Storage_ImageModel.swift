//
//  Storage_ImageModel.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/28/24.
//

import CoreData
import Foundation
import UIKit

extension Storage {

    func saveImageData(_ data: Data?, forImageModelId objId: NSManagedObjectID) throws {
        guard let data else { return }
        
        let iModel = try object(with: objId, type: ImageModel.self)
        iModel.pngData = data
        try save(failureMessage: "Fail to save image data for ImageModel")
    }
    
}
