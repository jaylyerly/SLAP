//
//  AnimalCard.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/8/25.
//

import CachedAsyncImage
import SwiftUI

private let insets = EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)

struct AnimalCard: View {
        
    @Environment(\.service)
    var service: Service
    
    @State var viewModel: ViewModel
    var animal: Animal? { viewModel.animal }
            
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                
                CachedAsyncImage(url: animal?.coverPhoto,
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
                .cornerRadius(10)
                Text(viewModel.displayName)
                    .padding(insets)
                    .background(.slapBlue.opacity(0.7))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .offset(y: -insets.top - 5)
            }
            .padding(10)
            Toggle("", isOn: $viewModel.isFavorite)
            .toggleStyle(FavoriteToggleStyle(padding: 30, size: 36))
        }
        .onAppear {
            viewModel.service = service
        }
    }
    
}

#Preview {
    AnimalCard(viewModel: .init(internalId: Animal.previewAnimal.internalId))
}
#Preview {
    AnimalCard(viewModel: .init(internalId: Animal.previewAnimal.internalId))
}
