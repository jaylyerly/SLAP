//
//  AnimalCardVMTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import Testing

@Suite("AnimalCard ViewModel Tests") struct AnimalCardVMTests {
    
    var viewModel: AnimalCard.ViewModel
    var notificationCenter: NotificationCenter
    var service: Service
    var animal: Animal
    var internalId: String
    
    init() throws {
        notificationCenter = NotificationCenter()
        service = .fake(notificationCenter: notificationCenter)
        animal = try #require(service.publishableAnimals.first)
        internalId = animal.internalId
        
        viewModel = .init(internalId: animal.internalId, notificationCenter: notificationCenter)
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
    
    @Test func checkNotifications() throws {
        
    }
    
    @Test func checkRefresh() throws {
        
    }
    
    @Test func checkUpdate() throws {
        
    }
    
}

/*
 import CustomDump
 @testable import GlowWorm
 import GlowWormDevice
 import XCTest

 class GlobalControlsViewVMTests: TestCase {
     typealias ViewModel = GlobalControlsView.ViewModel

     var appEnv: AppEnv!
     var viewModel: ViewModel!

     var library: FakeLibrary { appEnv.library as! FakeLibrary }
     var uiSettings: UiSettings {
         get { appEnv.settings.uiSettings }
         set { appEnv.settings.uiSettings = newValue }
     }
     
     @MainActor
     override func setUpWithError() throws {
         try super.setUpWithError()

         appEnv = .fake()
         viewModel = ViewModel(appEnv: appEnv)
     }

     override func tearDownWithError() throws {
         viewModel = nil
         appEnv = nil
         try super.tearDownWithError()
     }

     @MainActor
     func testAllOn() throws {
         XCTAssertTrue(library.commandHistory.isEmpty)

         viewModel.allOn()

         XCTAssertNoDifference(Set(library.commandHistory), [
             DeviceCommand(address: .global, deviceState: .power(true))
         ])
     }
     
     @MainActor
     func testAllOrr() throws {
         XCTAssertTrue(library.commandHistory.isEmpty)

         viewModel.allOff()

         XCTAssertNoDifference(Set(library.commandHistory), [
             DeviceCommand(address: .global, deviceState: .power(false))
         ])
     }
     
     @MainActor
     func testShowVideoPreview() throws {
         // initial condition
         XCTAssertFalse(uiSettings.showVideoPreview)
         XCTAssertFalse(viewModel.showVideoPreview)
         
         uiSettings.showVideoPreview = true
         XCTAssertTrue(uiSettings.showVideoPreview)
         XCTAssertTrue(viewModel.showVideoPreview)
         
         viewModel.showVideoPreview = false
         XCTAssertFalse(uiSettings.showVideoPreview)
         XCTAssertFalse(viewModel.showVideoPreview)

         viewModel.showVideoPreview = true
         XCTAssertTrue(uiSettings.showVideoPreview)
         XCTAssertTrue(viewModel.showVideoPreview)

         uiSettings.showVideoPreview = false
         XCTAssertFalse(uiSettings.showVideoPreview)
         XCTAssertFalse(viewModel.showVideoPreview)
     }
     
     @MainActor
     func testSyncDevices() throws {
         // initial condition
         XCTAssertFalse(uiSettings.syncDevices)
         XCTAssertFalse(viewModel.syncDevices)
         
         uiSettings.syncDevices = true
         XCTAssertTrue(uiSettings.syncDevices)
         XCTAssertTrue(viewModel.syncDevices)
         
         viewModel.syncDevices = false
         XCTAssertFalse(uiSettings.syncDevices)
         XCTAssertFalse(viewModel.syncDevices)

         viewModel.syncDevices = true
         XCTAssertTrue(uiSettings.syncDevices)
         XCTAssertTrue(viewModel.syncDevices)

         uiSettings.syncDevices = false
         XCTAssertFalse(uiSettings.syncDevices)
         XCTAssertFalse(viewModel.syncDevices)
     }

 }

 */
