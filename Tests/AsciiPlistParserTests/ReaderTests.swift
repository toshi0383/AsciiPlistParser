import XCTest
@testable import AsciiPlistParser

class ReaderTests: XCTestCase {
    var objects: PlistObject!
    override func setUp() {
        super.setUp()
        let path = pathForFixture(fileName: "test.fixture")
        let parser = try! Reader(path: path)
        try! parser.parse()
        objects = parser.objects
    }

    func testReader() {
        XCTAssertEqual(objects["archiveVersion"] as! String, "1")
        guard let dict = objects["objects"] as? PlistObject else {
            XCTFail()
            return
        }
        XCTAssertTrue(dict.isNewLineNeeded)
        let obj26 = dict["OBJ_26"]! as! PlistObject
        let obj26node = dict.dict["OBJ_26"]! 
        XCTAssertFalse(obj26node.isNewLineNeeded)
        XCTAssertEqual(obj26["isa"]! as! String, "PBXBuildFile")
        let obj24 = dict["OBJ_24"]! as! PlistObject
        XCTAssertEqual(obj24["isa"]! as! String, "XCBuildConfiguration")
        let buildSettigs = obj24["buildSettings"] as! PlistObject
        XCTAssertEqual(buildSettigs["ENABLE_TESTABILITY"] as! String, "YES")
    }
}
