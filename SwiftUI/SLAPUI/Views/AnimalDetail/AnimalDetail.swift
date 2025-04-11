//
//  AnimalDetail.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/9/25.
//

import SwiftUI

private let insets = EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)

struct AnimalDetail: View {
    
    let internalId: String
    
    @State var viewModel: ViewModel?

    @Environment(\.service)
    var service: Service
    @Environment(\.config)
    var config: Config
    
    var animal: Animal? { viewModel?.animal }

    var isFavorite: Binding<Bool> {
        Binding<Bool>(get: {
            viewModel?.isFavorite ?? false
        }, set: { newValue in
            viewModel?.isFavorite = newValue
        })
    }
    
    var infoStack: some View {
        VStack(alignment: .center, spacing: 10) {
            VStack {
                
                HStack(alignment: .center, spacing: 15) {
                    Text(animal?.sex.rawValue.capitalized ?? "")
                    if let weight = animal?.weight {
                        Text("Weight: \(Int(round(weight))) lbs")
                    }
                    if let age = animal?.age {
                        Text("Age: \(Int(round(age))) years")
                    }
                }
                Divider()
                if let desc = animal?.animalDescription {
                    Text(desc)
                }
            }
            .padding(10)
            .background(.white)
            .cornerRadius(10)
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    
    }
    
    var photoStack: some View {
        LazyVStack {
            ForEach(animal?.photos ?? [], id: \.self) { url in
                AsyncImage(url: url,
                           content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                },
                           placeholder: {
                    Image("PlaceholderRabbit")
                        .resizable()
                        .scaledToFit()
                        .accessibilityLabel("Loading...")
                })
            }
        }
    }
    
    var body: some View {
        ScrollView {
            infoStack
            photoStack
        }
        .background(Color.slapBlue)
        .refreshable {
            await viewModel?.refresh()
        }
        .onAppear {
            self.viewModel = ViewModel(internalId: internalId, service: service)
        }
        .task {
            await viewModel?.refresh()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel?.animal?.name ?? "Details")
                    .font(config.titleFont)
                    .foregroundStyle(.white)
                    
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Toggle("", isOn: isFavorite)
                .toggleStyle(FavoriteToggleStyle(padding: 0, size: 18))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.slapBlue, for: .navigationBar)
        .toolbarBackground(Color.slapBlue, for: .tabBar)
        .tint(.white)
    }
    
}

#Preview {
    NavigationStack {
        AnimalDetail(internalId: Animal.previewAnimal.internalId)
    }
}
