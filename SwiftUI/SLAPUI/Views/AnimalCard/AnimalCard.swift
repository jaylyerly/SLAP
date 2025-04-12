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
    
    let animal: Animal
    
    @Environment(\.service)
    var service: Service
    
    @State var viewModel: ViewModel?
    
    var isFavorite: Binding<Bool> {
        Binding<Bool>(get: {
            viewModel?.isFavorite ?? false
        }, set: { newValue in
            viewModel?.isFavorite = newValue
        })
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                
                CachedAsyncImage(url: animal.coverPhoto,
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
                Text(animal.name)
                    .padding(insets)
                    .background(.slapBlue.opacity(0.7))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .offset(y: -insets.top - 5)
            }
            .padding(10)
            Toggle("", isOn: isFavorite)
            .toggleStyle(FavoriteToggleStyle(padding: 30, size: 36))
        }
        .onAppear {
            self.viewModel = ViewModel(internalId: animal.internalId, service: service)
        }
    }
    
}

#Preview {
    AnimalCard(animal: .previewAnimal)
}
#Preview {
    AnimalCard(animal: .previewAnimal)
}
