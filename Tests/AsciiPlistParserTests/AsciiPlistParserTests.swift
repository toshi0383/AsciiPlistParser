import XCTest
@testable import AsciiPlistParser

class AsciiPlistParserTests: XCTestCase {
    func testReader() {
        let path = "test.pbxproj"
        let parser = try! Reader(path: path)
        try! parser.parse()
        let objects = parser.objects
        print(objects[3].asDictionary())
    }

    static var allTests = [
        ("testReader", testReader),
    ]
}
