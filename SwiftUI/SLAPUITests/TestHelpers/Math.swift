//
//  Math.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/3/25.
//

func aboutEqual(_ itemA: Double, _ itemB: Double) -> Bool {
    abs(itemA - itemB) < (itemA * 0.0001)
}
