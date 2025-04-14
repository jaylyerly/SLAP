//
//  AnimalCardAsyncTests.swift
//  SLAPUI
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

@Suite("Animal Card Async Tests") struct AnimalCardAsyncTests {

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
    var sut: AnimalCard
    
    init() throws {
        viewModel = FakeViewModel(internalId: "123")
        sut = AnimalCard(viewModel: viewModel)
    }
        
    @MainActor
    @Test func checkToggleFavorite() async throws {
        try await ViewHosting.host(sut) {
            try await sut.inspection.inspect { hostedView in
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
    
}
