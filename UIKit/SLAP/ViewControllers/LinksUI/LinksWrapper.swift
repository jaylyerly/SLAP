//
//  LinksWrapper.swift
//  SLAP
//
//  Created by Jay Lyerly on 4/25/25.
//

import SwiftUI

struct LinksWrapper<Content: View>: View {
    var content: Content
    let config: Config
    
    var body: some View {
        content
            .environment(\.config, config)
    }
}

extension EnvironmentValues {
    @Entry var config = Config()
}
