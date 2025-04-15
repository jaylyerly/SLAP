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
        let notificationCenter: NotificationCenter
        
        let internalId: String
        var animal: Animal?
        
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
                print("Awaiting notifications for didUpdateAnimal")
                for await notification in notificationCenter.notifications(named: .didUpdateAnimal) where
                notification.userInfo?[Service.userInfoAnimalInternalIdKey] as? String == internalId {
                    // Update if the notification is for this Animal
                    print("Received update animal notification, service: \(service)")
                    
                    update()
                }
                
            }
            Task {
                print("Awaiting notifications for didUpdateFavorites")
                for await notification in notificationCenter.notifications(named: .didUpdateFavorites)
                where notification.userInfo?[Service.userInfoAnimalInternalIdKey] as? String == internalId {
                    // Update if the notification is for this Animal
                    print("Received update favorit notification, service: \(service)")
                    update()
                }
            }
        }
        
        func refresh() async {
            await service?.updateAnimal(withInternalId: internalId)
        }
        
        func update() {
            animal = service?.animal(withInternalId: internalId)
        }
    }
}

@objc
extension AnimalDetail.ViewModel {
    
    var displayName: String {
        animal?.name ?? "<Missing Name>"
    }
    
    var displayWeight: String? {
        guard let weight = animal?.weight else { return nil }
        return "Weight: \(Int(round(weight))) lbs"
    }
    
    var displayAge: String? {
        guard let age = animal?.age else { return nil }
        return "Age: \(Int(round(age))) years"
    }
    
    var displayDescription: String? {
        guard let animalDescription = animal?.animalDescription else { return nil }
        return animalDescription
    }
    
    var displayPhotoUrls: [URL] {
        animal?.photos ?? []
    }
    
}
