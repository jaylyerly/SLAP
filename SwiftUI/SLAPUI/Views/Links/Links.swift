//
//  Links.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import SwiftUI

struct Links: View {
    
    @Environment(\.config)
    var config: Config
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Links")
                    .font(config.largeTitleFont)
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
                .padding(10)
            }
        }
        .background(.slapBlue)
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
