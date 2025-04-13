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
                    update()
                }
            }
            Task {
                for await _ in notificationCenter.notifications(named: .didUpdateFavorites) {
                    update()
                }
            }
        }
        
        func refresh() async {
            switch mode {
                case .all:
                    await service.updateAnimals()
                case .favorites:
                    // Favs are local, so no way to refresh, just update
                    update()
            }
        }
        
        func update() {
            switch mode {
                case .all:
                    animals = service.publishableAnimals
                case .favorites:
                    animals = service.favoriteAnimals
            }
        }
    }
}
