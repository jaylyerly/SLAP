//
//  Sex.swift
//  SLAP
//
//  Created by Jay Lyerly on 4/3/25.
//

import Foundation

enum Sex: String {
    case male
    case female
    case unknown
}

extension Sex {
    
    init(str: String?) {
        guard let str else {
            self = .unknown
            return
        }
        let input = str.lowercased()
        if input.starts(with: "m") {
            self = .male
        } else if input.starts(with: "f") {
            self = .female
        } else {
            self = .unknown
        }
    }
    
}
