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

@Suite("Animal Card Tests") struct AnimalCardTests {

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

    var viewModel: FakeViewModel
    var view: AnimalCard
    
    init() throws {
        viewModel = FakeViewModel(internalId: "123")
        view = AnimalCard(viewModel: viewModel)
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
                
                let label = try hostedView.find(ViewType.Text.self)
                expectNoDifference(try label.string(), "Almighty Malachi")
            }
        }
    }
}
