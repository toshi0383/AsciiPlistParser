//
//  IntegrationTests.swift
//  AsciiPlistParser
//
//  Created by Toshihiro suzuki on 2017/05/24.
//
//

import XCTest
@testable import AsciiPlistParser

class IntegrationTests: XCTestCase {
    func testSuccessfullyParseFixtures() {
        let paths = _xcodeprojFixturePaths()
        for path in paths {
            print(path)
            let parser = Reader(path: path)
            do {
                try parser.parse()
                let object = parser.object
            } catch {
                XCTFail("Parse failed: \(path)")
            }
        }
    }
}
