//
//  AnimalDetail_ViewModel.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/10/25.
//

import OSLog
import SwiftUI

extension AnimalDetail {
    
    @Observable
    class ViewModel {
        private let logger = Logger.defaultLogger()
        
        var service: Service? {
            didSet {
                update()
            }
        }
        var imageCache: ImageCache? {
            didSet {
                loadImages()
            }
        }
        
        var coverPhotoData: Data?
        var photosData: [Data] = []
        
        let notificationCenter: NotificationCenter
        
        let internalId: String
        var animal: Animal? {
            didSet {
                loadImages()
            }
        }
        private var hasLoadedImages = false
        
        var isFavorite: Bool {
            get { animal?.isFavorite ?? false }
            set {
                guard let animal else { return }
                Task {
                    if newValue {
                        await service?.favorite(animal)
                    } else {
                        await service?.unFavorite(animal)
                    }
                }
            }
        }
        
        init(internalId: String, notificationCenter: NotificationCenter = .default) {
            self.notificationCenter = notificationCenter
            self.internalId = internalId
            
            listenForNotifications()
        }
        
        private func listenForNotifications() {
            Task {
                for await notification in notificationCenter.notifications(named: .didUpdateAnimal) where
                notification.userInfo?[Service.userInfoAnimalInternalIdKey] as? String == internalId {
                    // Update if the notification is for this Animal
                    update()
                }
                
            }
            Task {
                for await notification in notificationCenter.notifications(named: .didUpdateFavorites)
                where notification.userInfo?[Service.userInfoAnimalInternalIdKey] as? String == internalId {
                    // Update if the notification is for this Animal
                    update()
                }
            }
        }
        
        func refresh() async {
            await service?.updateAnimal(withInternalId: internalId)
            hasLoadedImages = false
            photosData = []
            loadImages()
        }
        
        func update() {
            animal = service?.animal(withInternalId: internalId)
        }
                
        private func loadImages() {
            // Make sure to only run this once, but only after the animal has loaded and imageCache is ready
            guard let animal, let imageCache else { return }
            if hasLoadedImages { return }
            hasLoadedImages = true
            
            // Get cover photo
            if let coverUrl = animal.coverPhoto {
                if let data = imageCache.imageDataFromCache(for: coverUrl) {
                    coverPhotoData = data
                    photosData.insert(data, at: 0)  // always make cover photo first
                } else {
                    coverPhotoData = ImageCache.placeholderData
                    Task {
                        coverPhotoData = try? await imageCache.imageDataFromCacheOrDownload(for: coverUrl)
                        if let coverPhotoData {
                            photosData.insert(coverPhotoData, at: 0)  // always make cover photo first
                        }
                    }
                }
                
            } else {
                coverPhotoData = ImageCache.placeholderData
            }
            
            // Get other photos
            // Note:  Cover photo is usually in the list of photos, but we don't want to trigger two downloads
            // so make sure to remove it.
            var urls = Set(animal.photos)
            if let coverUrl = animal.coverPhoto {
                urls.remove(coverUrl)
            }
            
            for url in urls {
                Task {
                    if let data = try? await imageCache.imageDataFromCacheOrDownload(for: url) {
                        photosData.append(data)
                    }
                }
            }
            
        }
        
    }
}

@objc
extension AnimalDetail.ViewModel {
    
    var displayName: String {
        animal?.name ?? "<Missing Name>"
    }
    
    var displaySex: String? {
        animal?.sex.rawValue.capitalized
    }
    
    var displayWeight: String? {
        guard let weight = animal?.weight else { return nil }
        return "Weight: \(Int(round(weight))) lbs"
    }
    
    var displayAge: String? {
        guard let age = animal?.age else { return nil }
        return "Age: \(Int(round(age))) years"
    }
    
    var displayDescription: String {
        let name = animal?.name ?? "this rabbit"
        let defaultDescription = "More about \(name) coming soon!"
        guard let animalDescription = animal?.animalDescription else { return defaultDescription }
        if animalDescription.isEmpty { return defaultDescription }
        return animalDescription
    }
    
    var displayPhotoUrls: [URL] {
        animal?.photos ?? []
    }
    
}
