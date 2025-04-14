//
//  AnimalCardTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
import Foundation
@testable import SLAPUI
import SwiftUI
import Testing
import ViewInspector
import XCTest

class AnimalCardTests: TestCase {

    class FakeViewModel: AnimalCard.ViewModel {
        
        var backingIsFavorite = false
        var didRefresh = false
        var didUpdate = false
        
        override var isFavorite: Bool {
            get { backingIsFavorite }
            set { backingIsFavorite = newValue }
        }
        
        override func refresh() async { didRefresh = true }
        override func update() { didUpdate = true }
        
        override var displayName: String { "Almighty Malachi" }
        override var displayAge: String? { "Age: 99"}
        override var displayWeight: String? { "Weight: 1000 lbs" }
    }

    var viewModel: FakeViewModel!
    var sut: AnimalCard!
    
    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = FakeViewModel(internalId: "123")
        sut = AnimalCard(viewModel: viewModel)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        try super.tearDownWithError()
    }
    
//    @Test func checkToggleFavorite() async throws {
//        try await ViewHosting.host(view) { hostedView in
//            let toggle = hostedView.find(Toggle.self)
//        }
//    }
    
//    @MainActor
//    @Test func checkToggleFavorite() async throws {
//        let sut = Links()
//        
//        try await ViewHosting.host(sut.environment(\.config, .fake()) {
//            try await withThrowingDiscardingTaskGroup { group in
//                group.addTask {
//                    try await sut.inspection.inspect { hostedView in
//                        print("hostedView: \(hostedView)")
//                        let toggle = try hostedView.find(ViewType.Toggle.self)
//                        
//                        // initial state
//                        expectNoDifference(viewModel.isFavorite, false)
//                        
//                        try toggle.tap()
//                        expectNoDifference(viewModel.isFavorite, true)
//                        
//                        try toggle.tap()
//                        expectNoDifference(viewModel.isFavorite, false)
//                        
//                        try toggle.tap()
//                        expectNoDifference(viewModel.isFavorite, true)
//                    }
//                }
//            }
//        }
//    }
    
    @MainActor
    func testToggleSync() throws {
        let exp = sut.inspection.inspect { view in
            let viewModel = try XCTUnwrap(self.viewModel)

            let toggle = try view.find(ViewType.Toggle.self)
            
            // initial state
            expectNoDifference(viewModel.isFavorite, false)
            
            try toggle.tap()
            expectNoDifference(viewModel.isFavorite, true)
            
            try toggle.tap()
            expectNoDifference(viewModel.isFavorite, false)
            
            try toggle.tap()
            expectNoDifference(viewModel.isFavorite, true)
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2.0)
    }
    
    @MainActor
    func testLink() throws {
        let sutView = Links()
        let exp = sutView.inspection.inspect(after: 0.5) { view in
            let link1 = try view.find(ViewType.Link.self)
            expectNoDifference(link1.pathToRoot, "")
        }
        ViewHosting.host(view: sutView.environment(\.config, .fake()))
        wait(for: [exp], timeout: 2.0)
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
