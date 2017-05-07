// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import XCTest
extension PlistStringConvertibleTests {
  static var allTests: [(String, (PlistStringConvertibleTests) -> () throws -> Void)] = [
    ("testSorted", testSorted),
    ("testSorted002", testSorted002),
    ("testStringStringValue", testStringStringValue),
    ("testArrayStringValue", testArrayStringValue),
    ("testObject", testObject),
    ("testPbxprojCompatibility", testPbxprojCompatibility),
  ]
}
extension ReaderTests {
  static var allTests: [(String, (ReaderTests) -> () throws -> Void)] = [
    ("testReader", testReader),
    ("testModification", testModification),
  ]
}
extension SingleViewApplicationTests {
  static var allTests: [(String, (SingleViewApplicationTests) -> () throws -> Void)] = [
    ("testExample", testExample),
    ("testPerformanceExample", testPerformanceExample),
  ]
}
extension SingleViewApplicationUITests {
  static var allTests: [(String, (SingleViewApplicationUITests) -> () throws -> Void)] = [
    ("testExample", testExample),
  ]
}
extension libraryTests {
  static var allTests: [(String, (libraryTests) -> () throws -> Void)] = [
    ("testExample", testExample),
  ]
}

XCTMain([
  testCase(PlistStringConvertibleTests.allTests),
  testCase(ReaderTests.allTests),
  testCase(SingleViewApplicationTests.allTests),
  testCase(SingleViewApplicationUITests.allTests),
  testCase(libraryTests.allTests),
])

