//
//  AnimalCard.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/8/25.
//

import SwiftUI

struct AnimalCard: View {
    
    let animal: Animal

    var body: some View {
        Text("Animal Card: \(animal.name)").border(Color.cyan)
    }
    
}
