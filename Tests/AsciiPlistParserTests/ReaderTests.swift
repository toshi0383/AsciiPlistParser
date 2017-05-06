import XCTest
@testable import AsciiPlistParser

class ReaderTests: XCTestCase {
    var object: PlistObject!
    override func setUp() {
        super.setUp()
        let path = pathForFixture(fileName: "test.fixture")
        let parser = try! Reader(path: path)
        try! parser.parse()
        object = parser.object
    }

    func testReader() {
        XCTAssertEqual((object["archiveVersion"] as! StringValue).value, "1")
        guard let dict = object["objects"] as? PlistObject else {
            XCTFail()
            return
        }
        let obj26 = dict["OBJ_26"]! as! PlistObject
        XCTAssertEqual((obj26["isa"]! as! StringValue).value, "PBXBuildFile")
        let obj24 = dict["OBJ_24"]! as! PlistObject
        XCTAssertEqual((obj24["isa"]! as! StringValue).value, "XCBuildConfiguration")
        let buildSettigs = obj24["buildSettings"] as! PlistObject
        XCTAssertEqual((buildSettigs["ENABLE_TESTABILITY"] as! StringValue).value, "YES")
    }
}
