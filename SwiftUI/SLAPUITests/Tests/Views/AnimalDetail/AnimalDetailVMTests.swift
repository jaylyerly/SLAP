//
//  AnimalDetailVMTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import Testing

@Suite("AnimalDetail ViewModel Tests") struct AnimalDetailVMTests {
    
    var viewModel: AnimalDetail.ViewModel
    var notificationCenter: NotificationCenter
    var service: FakeService
    var animal: Animal
    var internalId: String
    
    init() throws {
        notificationCenter = NotificationCenter()
        service = .fake(notificationCenter: notificationCenter)
        animal = try #require(service.publishableAnimals.last)
        internalId = animal.internalId
        
        viewModel = .init(internalId: internalId, notificationCenter: notificationCenter)
        viewModel.service = service
        expectNoDifference(service.publishableAnimals.count, 12)
    }
    
    @Test func checkIsFavorite() async throws {
        // Initial state
        expectNoDifference(viewModel.isFavorite, false)
        // Initial data state has no value for isFavorite, so this should be nil
        expectNoDifference(service.animal(withInternalId: internalId)?.isFavorite, nil)

        // NB: The computed property setter dispatches a new Task to do the work, so we need to
        // wait until that task executes -- (can't make a setter async yet)
        viewModel.isFavorite = true
        await waitUntilTrue(viewModel.isFavorite)
        
        expectNoDifference(viewModel.isFavorite, true)
        expectNoDifference(service.animal(withInternalId: internalId)?.isFavorite, true)
        
        viewModel.isFavorite = false
        await waitUntilTrue(!viewModel.isFavorite)
        
        expectNoDifference(viewModel.isFavorite, false)
        expectNoDifference(service.animal(withInternalId: internalId)?.isFavorite, false)

        await service.favorite(animal)
        await waitUntilTrue(viewModel.isFavorite)
        
        expectNoDifference(viewModel.isFavorite, true)
        expectNoDifference(service.animal(withInternalId: internalId)?.isFavorite, true)
        
    }
    
    // Note: these notification center tests seem prone to spurious failures
    // when the test suite is run in parallel. 
    @Test func checkUpdateNotification() async throws {
        // Initial conditions
        service.lastFetchedAnimalWithInternalId = nil
        expectNoDifference(service.lastFetchedAnimalWithInternalId, nil)
        
        let userInfo = [Service.userInfoAnimalInternalIdKey: internalId]
        notificationCenter.post(name: .didUpdateAnimal, object: service, userInfo: userInfo)
        
        await waitUntilEqual(service.lastFetchedAnimalWithInternalId, internalId, timeout: .seconds(1))
    }
    
    @Test func checkFavoriteNotification() async throws {
        // Initial conditions
        service.lastFetchedAnimalWithInternalId = nil
        expectNoDifference(service.lastFetchedAnimalWithInternalId, nil)
        
        let userInfo = [Service.userInfoAnimalInternalIdKey: internalId]
        notificationCenter.post(name: .didUpdateFavorites, object: service, userInfo: userInfo)
        
        await waitUntilEqual(service.lastFetchedAnimalWithInternalId, internalId, timeout: .seconds(1))
    }

    @Test func checkRefresh() async throws {
        service.lastUpdateAnimalWithInternalId = nil
        expectNoDifference(service.lastUpdateAnimalWithInternalId, nil)

        await viewModel.refresh()
        
        expectNoDifference(service.lastUpdateAnimalWithInternalId, internalId)
    }
    
    @Test func checkUpdate() async throws {
        service.lastFetchedAnimalWithInternalId = nil
        expectNoDifference(service.lastFetchedAnimalWithInternalId, nil)

        viewModel.update()
        
        expectNoDifference(service.lastFetchedAnimalWithInternalId, internalId)
    }
    
    @Test func displayStrings() async throws {
        viewModel.update()
        expectNoDifference(viewModel.displayName, "Winnie (Winnifred)")
        expectNoDifference(viewModel.displayAge, "Age: 2 years")
        expectNoDifference(viewModel.displayWeight, "Weight: 4 lbs")
    }
    
}
