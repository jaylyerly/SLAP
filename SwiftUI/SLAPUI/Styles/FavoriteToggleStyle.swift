//
//  FavoriteToggleStyle.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/10/25.
//

import SwiftUI

struct FavoriteToggleStyle: ToggleStyle {

    var onColor: Color = .slapGreen
    var offColor: Color = .gray
    
    var onSymbol = "heart.fill"
    var offSymbol = "heart"
    var padding: CGFloat = 8
    var size: CGFloat = 24

    func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: configuration.isOn ? onSymbol : offSymbol)
            .padding(padding)
            .foregroundStyle(configuration.isOn ? onColor : offColor)
            .font(.system(size: size))
            .onTapGesture {
                withAnimation(.smooth(duration: 0.2)) {
                    configuration.isOn.toggle()
                }
            }
        
    }
}

struct ToggleView: View {
    @State var isOn: Bool = false
    var body: some View {
        VStack {
            Toggle("Example Toggle", isOn: $isOn)
                .toggleStyle(FavoriteToggleStyle(onColor: .yellow, offColor: .indigo, size: 48))
            Toggle("Default Toggle with Tint", isOn: $isOn)
                .tint(.yellow)
        }
        .padding()
    }
}

#Preview {
    ToggleView()
}
