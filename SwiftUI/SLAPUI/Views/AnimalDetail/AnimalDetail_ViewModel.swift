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
        }
        
        func refresh() async {
            await service.updateAnimal(withInternalId: internalId)
        }
        
        func update() {
            animal = service.animal(withInternalId: internalId)
        }
    }
}
