//
//  AnimalList.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import SwiftUI

struct AnimalList: View {
    
    enum Mode {
        case all, favorites
    }

    let mode: Mode
    
    @State var viewModel: ViewModel?
    @Environment(\.service)
    var service: Service

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if let viewModel = viewModel {
                    ForEach(viewModel.animals, id: \.self) {
                        AnimalCard(animal: $0)
                    }
                }
            }
        }.refreshable {
            await viewModel?.refresh()
        }.onAppear {
            self.viewModel = ViewModel(mode: mode, service: self.service)
        }.task {
            await viewModel?.refresh()
        }
    }
}
