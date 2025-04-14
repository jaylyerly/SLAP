//
//  AnimalDetail.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/9/25.
//

import CachedAsyncImage
import SwiftUI

private let insets = EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)

struct AnimalDetail: View {
        
    @State var viewModel: ViewModel

    @Environment(\.service)
    var service: Service
    @Environment(\.config)
    var config: Config
    
    var animal: Animal? { viewModel.animal }

    var infoStack: some View {
        VStack(alignment: .center, spacing: 10) {
            VStack {
                HStack(alignment: .center, spacing: 15) {
                    Text(animal?.sex.rawValue.capitalized ?? "")
                    if let displayWeight = viewModel.displayWeight {
                        Text(displayWeight)
                    }
                    if let displayAge = viewModel.displayAge {
                        Text(displayAge)
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
                CachedAsyncImage(url: url,
                                 urlCache: .imageCache,
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
            await viewModel.refresh()
        }
        .onAppear {
            viewModel.service = service
        }
        .task {
            await viewModel.refresh()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.displayName)
                    .font(config.titleFont.font)
                    .foregroundStyle(.white)
                    
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Toggle("", isOn: $viewModel.isFavorite)
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
        AnimalDetail(viewModel: .init(internalId: Animal.previewAnimal.internalId))
    }
}
