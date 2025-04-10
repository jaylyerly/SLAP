//
//  AnimalCard.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/8/25.
//

import SwiftUI

private let insets = EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)

struct AnimalCard: View {
    
    let animal: Animal
    @State var isOn: Bool = false // placeholder for fav
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                
                AsyncImage(url: animal.coverPhoto,
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
                    .background(.accent.opacity(0.7))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .offset(y: -insets.top - 5)
            }
            .padding(10)
            Toggle("", isOn: $isOn)
            .toggleStyle(FavoriteToggleStyle(padding: 30, size: 36))
        }
    }
    
}

#Preview {
    AnimalCard(animal: .previewAnimal)
}
#Preview {
    AnimalCard(animal: .previewAnimal)
}
