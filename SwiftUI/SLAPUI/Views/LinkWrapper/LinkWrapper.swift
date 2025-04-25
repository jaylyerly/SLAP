//
//  LinkWrapper.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/25/25.
//

import SwiftUI

#if os(macOS)

typealias LinkWrapper = Link

#elseif os(iOS)

struct LinkWrapper<Content: View>: View {
    let content: Content
    let destination: URL
    @State private var showSafari = false
    
//    var body2: some View {
//        Button {
//            showSafari.toggle()
//        } label: {
//            content
//        }.popover(isPresented: $showSafari) {
//            Safari(destination: destination)
//        }
//    }

    var body: some View {
        content
            .accessibilityHidden(true)
            .onTapGesture { showSafari = true }
            .popover(isPresented: $showSafari) {
                Safari(destination: destination)
            }
            .foregroundStyle(.white)
    }
    
    init(destination: URL, @ViewBuilder content: () -> Content) {
        self.destination = destination
        self.content = content()
    }
    
}

#endif
