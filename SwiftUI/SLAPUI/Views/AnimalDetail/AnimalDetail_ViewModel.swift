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
        
        let service: Service
        let notificationCenter: NotificationCenter
        
        let internalId: String
        var animal: Animal?
        
        var isFavorite: Bool {
            get { animal?.isFavorite ?? false }
            set {
                guard let animal else { return }
                Task {
                    if newValue {
                        await service.favorite(animal)
                    } else {
                        await service.unFavorite(animal)
                    }
                }
            }
        }
        
        init(internalId: String, service: Service, notificationCenter: NotificationCenter = .default) {
            self.service = service
            self.notificationCenter = notificationCenter
            self.internalId = internalId
            
            listenForNotifications()
            update()
        }
        
        private func listenForNotifications() {
            Task {
                for await notification in notificationCenter.notifications(named: .didUpdateAnimal) {
                    logger.debug("didUpdateAnimal received!")
                    if notification.userInfo?[Service.userInfoAnimalInternalIdKey] as? String == internalId {
                        // Update if the notification is for this Animal
                        update()
                    }
                }
            }
            Task {
                for await notification in notificationCenter.notifications(named: .didUpdateFavorites) {
                    logger.debug("didUpdateFavorites received!")
                    if notification.userInfo?[Service.userInfoAnimalInternalIdKey] as? String == internalId {
                        // Update if the notification is for this Animal
                        update()
                    }
                }

            }
        }
        
        func refresh() async {
            await service.updateAnimal(withInternalId: internalId)
        }
        
        func update() {
            animal = service.animal(withInternalId: internalId)
        }
    }
}
