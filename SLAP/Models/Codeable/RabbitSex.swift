//
//  RabbitSex.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation

enum RabbitSex: String {
    case male
    case female
    case unknown
}

extension RabbitSex {
    
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
