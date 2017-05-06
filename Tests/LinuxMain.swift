// Generated using Sourcery 0.5.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import XCTest
extension PlistStringConvertibleTests {
  static var allTests: [(String, (PlistStringConvertibleTests) -> () throws -> Void)] = [
    ("testSorted", testSorted),
    ("testStringStringValue", testStringStringValue),
    ("testArrayStringValue", testArrayStringValue),
    ("testPlistObject", testPlistObject),
  ]
}
extension ReaderTests {
  static var allTests: [(String, (ReaderTests) -> () throws -> Void)] = [
    ("testReader", testReader),
  ]
}

XCTMain([
  testCase(PlistStringConvertibleTests.allTests),
  testCase(ReaderTests.allTests),
])

