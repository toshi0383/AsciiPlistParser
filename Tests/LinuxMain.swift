// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import XCTest
extension ObjectTests {
  static var allTests: [(String, (ObjectTests) -> () throws -> Void)] = [
    ("testObjectEquatableAgainstStringValue", testObjectEquatableAgainstStringValue),
    ("testDictionary", testDictionary),
  ]
}
extension PlistStringConvertibleTests {
  static var allTests: [(String, (PlistStringConvertibleTests) -> () throws -> Void)] = [
    ("testSorted", testSorted),
    ("testSorted002", testSorted002),
    ("testStringValue", testStringValue),
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
extension ValuesTests {
  static var allTests: [(String, (ValuesTests) -> () throws -> Void)] = [
    ("testStringValueCanBeExpressedByStringLiteral", testStringValueCanBeExpressedByStringLiteral),
    ("testArrayValueCanBeExpressedByArrayLiteral", testArrayValueCanBeExpressedByArrayLiteral),
  ]
}
extension libraryTests {
  static var allTests: [(String, (libraryTests) -> () throws -> Void)] = [
    ("testExample", testExample),
  ]
}

XCTMain([
  testCase(ObjectTests.allTests),
  testCase(PlistStringConvertibleTests.allTests),
  testCase(ReaderTests.allTests),
  testCase(SingleViewApplicationTests.allTests),
  testCase(SingleViewApplicationUITests.allTests),
  testCase(ValuesTests.allTests),
  testCase(libraryTests.allTests),
])

