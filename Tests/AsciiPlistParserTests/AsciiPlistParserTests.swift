import XCTest
@testable import AsciiPlistParser

class AsciiPlistParserTests: XCTestCase {
    func testReader() {
        let path = Bundle(for: AsciiPlistParserTests.self).path(forResource: "test.pbxproj", ofType: nil)!
        let parser = try! Reader(path: path)
        let objects = try! parser.read()
        print(objects[3])
    }

    static var allTests = [
        ("testReader", testReader),
    ]
}
