//
//  Waiters.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

import CustomDump
import Foundation
import Testing

func waitUntilTrue(
    _ expression: @autoclosure (() async throws -> Bool),
    timeout: Duration = .milliseconds(200),
    sleepInterval: Duration = .milliseconds(1),
    fileID: String = #fileID,
    filePath: String = #filePath,
    line: Int = #line,
    column: Int = #column
) async {
    
    await waitUntilEqual(
        try await expression(),
        true,
        timeout: timeout,
        sleepInterval: sleepInterval,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
    )
}

func waitUntilEqual<T: Equatable>(
    _ expressionA: @autoclosure (() async throws -> T?),
    _ expressionB: @autoclosure (() async throws -> T?),
    timeout: Duration = .milliseconds(200),
    sleepInterval: Duration = .milliseconds(1),
    fileID: String = #fileID,
    filePath: String = #filePath,
    line: Int = #line,
    column: Int = #column
) async {
    
    let timeout = ContinuousClock.now + timeout
    let sourceLocation = SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)

    do {
        var valueA = try await expressionA()
        var valueB = try await expressionB()
        while valueA != valueB {
            try await Task.sleep(for: sleepInterval)
            if .now >= timeout {
                let diffMsg = "\n" + (diff(valueA, valueB) ??
                                      "\(String(describing: valueA)) != \(String(describing: valueB))")
                Issue.record("Timed out waiting for equality: \(diffMsg)",
                             sourceLocation: sourceLocation)
                break
            }
            valueA = try await expressionA()
            valueB = try await expressionB()
        }
    } catch {
        Issue.record("waitUntilTrue expression threw an error: \(String(describing: error))",
                     sourceLocation: sourceLocation)
    }
}
