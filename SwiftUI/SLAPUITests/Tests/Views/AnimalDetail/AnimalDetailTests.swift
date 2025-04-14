//
//  AnimalDetailTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CachedAsyncImage
import CustomDump
import Foundation
@testable import SLAPUI
import SwiftUI
import Testing
import ViewInspector

@Suite("Animal Detail Tests") struct AnimalDetailTests {

    class FakeViewModel: AnimalDetail.ViewModel {
        
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
        override var displayDescription: String? { "A very powerful dragon." }
        override var displayPhotoUrls: [URL] {[
            URL(string: "https://www.example.com/photos/1")!,
            URL(string: "https://www.example.com/photos/2")!,
            URL(string: "https://www.example.com/photos/3")!,
        ]}
    }

    var viewModel: FakeViewModel
    var view: AnimalDetail
    
    init() throws {
        viewModel = FakeViewModel(internalId: "123")
        view = AnimalDetail(viewModel: viewModel)
    }
        
    @MainActor
    @Test func checkToggleFavorite() async throws {
        try await ViewHosting.host(view) {
            try await view.inspection.inspect { hostedView in
                let toggle = try hostedView.find(ViewType.Toggle.self)
                
                // initial state
                expectNoDifference(viewModel.isFavorite, false)
                
                try toggle.tap()
                expectNoDifference(viewModel.isFavorite, true)
                
                try toggle.tap()
                expectNoDifference(viewModel.isFavorite, false)
                
                try toggle.tap()
                expectNoDifference(viewModel.isFavorite, true)
            }
        }
    }
    
    @MainActor
    @Test func checkDisplayStrings() async throws {
        try await ViewHosting.host(view) {
            try await view.inspection.inspect { hostedView in
                
                let labels = hostedView.findAll(ViewType.Text.self)
                expectNoDifference(labels.count, 6)
                expectNoDifference(try labels[1].string(), "Weight: 1000 lbs")
                expectNoDifference(try labels[2].string(), "Age: 99")
                expectNoDifference(try labels[3].string(), "A very powerful dragon.")
                expectNoDifference(try labels[4].string(), "Almighty Malachi")
            }
        }
    }
    
// Note -- ViewInspector doesn't want to find CachedAsyncImages, so the photo test is currently disabled.
//    @MainActor
//    @Test func checkPhotos() async throws {
//        try await ViewHosting.host(view) {
//            try await view.inspection.inspect { hostedView in
//                
//                let photos = hostedView.findAll(CachedAsyncImage.self)
//                expectNoDifference(photos.count, 3)
//            }
//        }
//    }

}
