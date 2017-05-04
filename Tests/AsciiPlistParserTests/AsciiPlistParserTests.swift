import XCTest
@testable import AsciiPlistParser

class AsciiPlistParserTests: XCTestCase {
    func testReader() {
        let path = Bundle(for: AsciiPlistParserTests.self).path(forResource: "test.pbxproj", ofType: nil)!
        let parser = try! Reader(path: path)
        try! parser.parse()
        let objects = parser.dictionary
        print(objects["objects"]!)
    }

    static var allTests = [
        ("testReader", testReader),
    ]
}
