//
//  MainTab.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import SwiftUI

struct MainTab: View {
    @SceneStorage("selectedTab")
    private var selectedTab: Int = 0
    
    let inspection = Inspection<Self>() // ViewInspector hook

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Adoptables",
                systemImage: "hare",
                value: 0
            ) {
                AnimalList(mode: .all)
            }
            Tab(
                "Favorites",
                systemImage: "heart",
                value: 1
            ) {
                AnimalList(mode: .favorites)
            }
            Tab(
                "Links",
                systemImage: "link",
                value: 2
            ) {
                Links()
            }
        }
        .onReceive(inspection.notice) { inspection.visit(self, $0) } // ViewInspector

    }
}
