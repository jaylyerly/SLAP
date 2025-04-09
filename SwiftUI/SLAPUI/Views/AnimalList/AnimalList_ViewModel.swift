//
//  AnimalList_ViewModel.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import OSLog
import SwiftUI

extension AnimalList {
    
    @Observable
    class ViewModel {
        private let logger = Logger.defaultLogger()
        
        let service: Service
        let notificationCenter: NotificationCenter
        let mode: Mode
        
        var animals: [Animal] = []
        
        init(mode: Mode, service: Service, notificationCenter: NotificationCenter = .default) {
            self.service = service
            self.notificationCenter = notificationCenter
            self.mode = mode
            
            listenForNotifications()
        }
        
        private func listenForNotifications() {
            Task {
                for await _ in notificationCenter.notifications(named: .didUpdateAnimals) {
                    logger.debug("didUpdateAnimals received!")
                    update()
                }
            }
            Task {
                for await _ in notificationCenter.notifications(named: .didUpdateFavorites) {
                    logger.debug("didUpdateFavorites received!")
                    update()
                }
            }
        }
        
        func refresh() async {
            switch mode {
                case .all:
                    await service.updateAnimals()
                case .favorites:
                    break
                    // Favs are local, so no way to refresh
//                    await service.updateFavorites()
            }
        }
        
        func update() {
            switch mode {
                case .all:
                    animals = service.animals
                case .favorites:
                    animals = service.favorites
            }
        }
    }
}
