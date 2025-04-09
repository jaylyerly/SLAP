//
//  Math.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

func aboutEqual(_ a: Double, _ b: Double) -> Bool {
    return abs(a - b) < (a * 0.0001)
}
