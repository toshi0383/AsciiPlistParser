import XCTest
@testable import AsciiPlistParser

class AsciiPlistParserTests: XCTestCase {
    func testReader() {
        #if Xcode
            let path = Bundle(for: AsciiPlistParserTests.self).path(forResource: "test.fixture", ofType: nil)!
        #else
            let path = "Tests/AsciiPlistParserTests/Fixtures/test.fixture"
        #endif
        let parser = try! Reader(path: path)
        try! parser.parse()
        let objects = parser.objects
        XCTAssertEqual(objects["archiveVersion"]?.value.value as! String, "1")
        XCTAssertEqual(objects["objects"]?.key.id, "objects")
        XCTAssertEqual(objects["objects"]?.key.id, "objects")
    }

    static var allTests = [
        ("testReader", testReader),
    ]
}
