//
//  Links.swift
//  SLAP
//
//  Created by Jay Lyerly on 4/25/25.
//

import SwiftUI

struct Links: View {
    
    @Environment(\.config)
    var config: Config
    let largeTitleFont = Font.custom("Marker Felt", size: 48, relativeTo: .largeTitle)
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Links")
                    .font(largeTitleFont)
                    .foregroundStyle(.white)
                HStack {
                    Image("Banner")
                        .resizable()
                        .scaledToFit()
                        .accessibilityHidden(true)
                }
                .background(.white)
                .cornerRadius(10)
                .padding(10)
                Spacer()
                HStack {
                    linkButton(title: "WebSite", symbol: "house", url: config.homeUrl)
                    linkButton(title: "Store", symbol: "storefront", url: config.storeUrl)
                }
                .foregroundStyle(.white)
                .padding(10)
            }
        }
        .background(Color.accentColor)
        .toolbarBackground(Color.accentColor, for: .navigationBar)
        .toolbarBackground(Color.accentColor, for: .tabBar)
//        .onReceive(inspection.notice) { inspection.visit(self, $0) } // ViewInspector

    }
    
    func linkButton(title: String, symbol: String, url: URL) -> some View {
        Link(destination: url) {
            VStack {
                Image(systemName: symbol)
                    .font(.system(size: 96))
                    .accessibilityHidden(true)
                Spacer()
                Text(title)
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Links()
        .environment(\.config, Config())
}
