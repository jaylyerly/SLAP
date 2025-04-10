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
    }

    let mode: Mode
    
    @State var viewModel: ViewModel?
    @Environment(\.service)
    var service: Service

    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    if let viewModel {
                        ForEach(viewModel.animals, id: \.self) { animal in
                            NavigationLink(value: animal) {
                                AnimalCard(animal: animal)
                            }
                        }
                    } else {
                        Text("No animals found.")
                    }
                }
            }
            .navigationDestination(for: Animal.self) { animal in
                AnimalDetail(animal: animal)
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
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .background(Color.accentColor)
            .tint(.white)
        }
    }
}

#Preview {
    AnimalList(mode: .all, viewModel: nil)
        .environment(\.service, .preview)
}
