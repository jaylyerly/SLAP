//
//  UrlProtocolMock.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/27/24.
//

import Foundation
import XCTest

// NB: This particular implementation was based on a Hacking with Swift article
// https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way

class UrlProtocolMock: URLProtocol {
    static var testURLs = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        self.client?.urlProtocol(
            self,
            didReceive: HTTPURLResponse(),
            cacheStoragePolicy: .notAllowed
        )

        if let url = request.url {
            if let data = Self.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            } else {
                XCTFail("Requested data for unknown URL: \(url)")
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
