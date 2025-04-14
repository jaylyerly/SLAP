//
//  Waiters.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/14/25.
//

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

func waitUntilEqual(
    _ expressionA: @autoclosure (() async throws -> Bool),
    _ expressionB: @autoclosure (() async throws -> Bool),
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
        while (try await expressionA()) != (try await expressionB()) {
            try await Task.sleep(for: sleepInterval)
            if .now >= timeout {
                Issue.record("Timed out waiting for condition to become true", sourceLocation: sourceLocation)
                break
            }
        }
    } catch {
        Issue.record("waitUntilTrue expression threw an error: \(String(describing: error))",
                     sourceLocation: sourceLocation)
    }
}
