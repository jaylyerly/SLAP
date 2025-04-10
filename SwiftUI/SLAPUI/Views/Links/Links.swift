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
                    Link(destination: config.homeUrl) {
                        VStack {
                            Image(systemName: "house")
                                .font(.system(size: 96))
                                .accessibilityHidden(true)
                            Spacer()
                            Text("WebSite")
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Link(destination: config.storeUrl) {
                        VStack {
                            Image(systemName: "storefront")
                                .font(.system(size: 96))
                                .accessibilityHidden(true)
                            Spacer()
                            Text("Store")
                                .foregroundStyle(.white)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                .padding(10)
            }
        }
        .background(.slapBlue)
    }
}

#Preview {
    Links()
        .environment(\.config, Config())
}
