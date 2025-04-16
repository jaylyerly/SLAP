//
//  AnimalCard.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/8/25.
//

import SwiftUI

private let insets = EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)

struct AnimalCard: View {
        
    @Environment(\.service)
    var service: Service
    
    @Environment(\.imageCache)
    var imageCache: ImageCache

    @Environment(\.config)
    var config: Config

    @State var viewModel: ViewModel
    var animal: Animal? { viewModel.animal }

    let inspection = Inspection<Self>() // ViewInspector hook

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                Image(data: viewModel.coverPhotoData)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .accessibilityHidden(true)
                Text(viewModel.displayName)
                    .padding(insets)
                    .background(.slapBlue.opacity(0.7))
                    .foregroundStyle(.white)
                    .font(config.titleFont.font)
                    .cornerRadius(10)
                    .offset(y: -insets.top - 5)
            }
            .padding(10)
            Toggle("", isOn: $viewModel.isFavorite)
            .toggleStyle(FavoriteToggleStyle(padding: 30, size: 36))
        }
        .onAppear {
            viewModel.service = service
            viewModel.imageCache = imageCache
        }
        .onReceive(inspection.notice) { inspection.visit(self, $0) } // ViewInspector

    }
    
}

#Preview {
    AnimalCard(viewModel: .init(internalId: Animal.previewAnimal.internalId))
}
#Preview {
    AnimalCard(viewModel: .init(internalId: Animal.previewAnimal.internalId))
}
