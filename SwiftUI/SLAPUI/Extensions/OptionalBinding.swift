//
//  OptionalBinding.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/11/25.
//

//import Foundation
//import SwiftUI
//
//func optionalBinding<T>(_ binding: Binding<T?>, _ defaultValue: T) -> Binding<T> {
//    Binding<T>(get: {
//        binding.wrappedValue ?? defaultValue
//    }, set: { newValue in
//        binding.wrappedValue = newValue
//    })
//}
//
//// swiftlint:disable:next operator_whitespace static_operator
//func ??<T> (left: Binding<T?>, right: T) -> Binding<T> {
//    optionalBinding(left, right)
//}
