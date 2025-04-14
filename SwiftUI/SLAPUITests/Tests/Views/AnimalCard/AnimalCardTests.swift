//
//  AnimalCardTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
import Testing

@testable import SLAPUI

@Suite("AnimalCard Tests") struct AnimalCardTests {
    
    class FakeViewModel: AnimalCard.ViewModel {
        
    }
    
    @Test func parseAnimal() throws {
        
    }
    
}

/*
 import CustomDump
 @testable import GlowWorm
 import SwiftUI
 import ViewInspector
 import XCTest

 class GlobalControlsViewTests: TestCase {

     class FakeViewModel: GlobalControlsView.ViewModel {

         var syncDevicesValue = false
         override var syncDevices: Bool {
             get { syncDevicesValue }
             set { syncDevicesValue = newValue }
         }

         var didCallAllOn = false
         var didCallAllOff = false

         override func allOn() {
             didCallAllOn = true
         }

         override func allOff() {
             didCallAllOff = true
         }

     }

     var appEnv: AppEnv!
     var viewModel: FakeViewModel!
     var view: GlobalControlsView!

     var defaults: Defaults { appEnv.defaults }

     @MainActor
     override func setUpWithError() throws {
         try super.setUpWithError()

         appEnv = .fake()
         viewModel = FakeViewModel(appEnv: appEnv)
         // swiftformat:disable:next redundantSelf
         view = GlobalControlsView(viewModel: self.viewModel)
     }

     override func tearDownWithError() throws {
         view = nil
         viewModel = nil
         appEnv = nil
         try super.tearDownWithError()
     }

     @MainActor
     func testToggleSync() throws {
         let exp = view.inspection.inspect { view in
             let viewModel = try XCTUnwrap(self.viewModel)

             let labelTxt = "Sync"
             let toggle = try view.find(ViewType.Toggle.self)
             XCTAssertNoDifference(try toggle.labelView().text().string(), labelTxt)

             // initial state
             XCTAssertFalse(viewModel.syncDevices)

             try toggle.tap()
             XCTAssertTrue(viewModel.syncDevices)

             try toggle.tap()
             XCTAssertFalse(viewModel.syncDevices)

             try toggle.tap()
             XCTAssertTrue(viewModel.syncDevices)
         }
         ViewHosting.host(view: view)
         wait(for: [exp], timeout: 0.1)
     }

     @MainActor
     func testAllOn() throws {
         let exp = view.inspection.inspect { view in
             let viewModel = try XCTUnwrap(self.viewModel)
             XCTAssertFalse(viewModel.didCallAllOn)
             XCTAssertFalse(viewModel.didCallAllOff)

             let labelTxt = "All On"
             let button = try view.find(button: labelTxt)
             XCTAssertNoDifference(try button.labelView().text().string(), labelTxt)

             try button.tap()

             XCTAssertTrue(viewModel.didCallAllOn)
             XCTAssertFalse(viewModel.didCallAllOff)
         }
         ViewHosting.host(view: view)
         wait(for: [exp], timeout: 0.1)
     }

     @MainActor
     func testAllOff() throws {
         let exp = view.inspection.inspect { view in
             let viewModel = try XCTUnwrap(self.viewModel)
             XCTAssertFalse(viewModel.didCallAllOn)
             XCTAssertFalse(viewModel.didCallAllOff)

             let labelTxt = "All Off"
             let button = try view.find(button: labelTxt)
             XCTAssertNoDifference(try button.labelView().text().string(), labelTxt)

             try button.tap()

             XCTAssertFalse(viewModel.didCallAllOn)
             XCTAssertTrue(viewModel.didCallAllOff)
         }
         ViewHosting.host(view: view)
         wait(for: [exp], timeout: 0.1)
     }

 }

 */
