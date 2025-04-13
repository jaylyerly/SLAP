//
//  Math.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/3/25.
//

import Testing

func aboutEqual(_ optA: Double?, _ optB: Double?) -> Bool {
    do {
        let itemA = try #require(optA)
        let itemB = try #require(optB)
        return abs(itemA - itemB) < (itemA * 0.0001)
    } catch {
        Issue.record("Nil value passed to aboutEqual: \(error)")
        return false
    }
}
