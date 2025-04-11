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
        
        var title: String {
            switch self {
                case .all:
                    return "Adoptables"
                case .favorites:
                    return "Favorites"
            }
        }
        
        var emptyListMessage: String {
            switch self {
                case .all:
                    return "No adoptable animals found."
                case .favorites:
                    return "No favorite animals found."
            }
        }
    }

    let mode: Mode
    
    @State var viewModel: ViewModel?
    
    @Environment(\.service)
    var service: Service
    
    @Environment(\.config)
    var config: Config
    
    var scrollContent: some View {
        LazyVStack(alignment: .leading) {
            if let viewModel {
                ForEach(viewModel.animals, id: \.self) { animal in
                    NavigationLink(value: animal) {
                        AnimalCard(animal: animal)
                    }
                }
                if viewModel.animals.isEmpty {
                    Text(mode.emptyListMessage)
                        .frame(maxWidth: .infinity)
                        .padding(30)
                        .foregroundStyle(.white)
                        .font(config.bodyFont)
                }
            } else {
                Text(mode.emptyListMessage)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                scrollContent
            }
            .navigationDestination(for: Animal.self) { animal in
                AnimalDetail(internalId: animal.internalId)
            }
            .refreshable {
                await viewModel?.refresh()
            }
            .onAppear {
                self.viewModel = ViewModel(mode: mode, service: self.service)
            }
            .task {
                await viewModel?.refresh()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(mode.title)
                        .font(config.largeTitleFont)
                        .foregroundStyle(.white)
                }
            }
            .navigationTitle("")
            .background(Color.slapBlue)
            .tint(.white)
            .toolbarBackground(Color.slapBlue, for: .navigationBar)
            .toolbarBackground(Color.slapBlue, for: .tabBar)
        }
    }
}

#Preview {
    AnimalList(mode: .all, viewModel: nil)
        .environment(\.service, .preview)
}

#Preview {
    AnimalList(mode: .favorites, viewModel: nil)
        .environment(\.service, .preview)
}
