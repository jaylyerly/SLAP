//
//  AnimalDetail.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/9/25.
//

import SwiftUI

private let insets = EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)

struct AnimalDetail: View {
    
    let animal: Animal
    @State var isOn: Bool = false // placeholder for fav
    
    var infoStack: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(animal.name)
                .font(.largeTitle)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.accent)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 2)
                }
            VStack {
                
                HStack(alignment: .center, spacing: 15) {
                    Text(animal.sex.rawValue.capitalized)
                    if let weight = animal.weight {
                        Text("Weight: \(Int(round(weight))) lbs")
                    }
                    if let age = animal.age {
                        Text("Age: \(Int(round(age))) years")
                    }
                }
                Divider()
                if let desc = animal.animalDescription {
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
            ForEach(animal.photos, id: \.self) { url in
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
        .background(Color.accentColor)
    }
    
}

#Preview {
    AnimalDetail(animal: .previewAnimal)
}
