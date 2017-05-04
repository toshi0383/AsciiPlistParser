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
        XCTAssertEqual(objects["archiveVersion"] as! String, "1")
        guard let dict = objects["objects"] as? PlistObject else {
            XCTFail()
            return
        }
        let obj26 = dict["OBJ_26"]! as! PlistObject
        XCTAssertEqual(obj26["isa"]! as! String, "PBXBuildFile")
        let obj24 = dict["OBJ_24"]! as! PlistObject
        XCTAssertEqual(obj24["isa"]! as! String, "XCBuildConfiguration")
        let buildSettigs = obj24["buildSettings"] as! PlistObject
        XCTAssertEqual(buildSettigs["ENABLE_TESTABILITY"] as! String, "YES")
    }
}
