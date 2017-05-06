import XCTest
@testable import AsciiPlistParser

class ReaderTests: XCTestCase {
#if Xcode
#else
    func testReader() {
        let path = pathForFixture(fileName: "Xcode/8.3.2/SingleViewApplication/SingleViewApplication.xcodeproj/project.pbxproj")
        let parser = try! Reader(path: path)
        try! parser.parse()
        let object = parser.object
        XCTAssertEqual((object["archiveVersion"] as! StringValue).value, "1")
        guard let dict = object["objects"] as? PlistObject else {
            XCTFail()
            return
        }
        let obj1 = dict["1F88C5881EB47C3C002A5302"]! as! PlistObject
        XCTAssertEqual((obj1["isa"]! as! StringValue).value, "PBXBuildFile")
        let obj2 = dict["1F88C5AD1EB47C3C002A5302"]! as! PlistObject
        XCTAssertEqual((obj2["isa"]! as! StringValue).value, "XCBuildConfiguration")
        let buildSettigs = obj2["buildSettings"] as! PlistObject
        XCTAssertEqual((buildSettigs["ENABLE_TESTABILITY"] as! StringValue).value, "YES")
    }
#endif

    func testModification() {
        let path = pathForFixture(fileName: "Behavior/unsorted.fixture")
        let parser = try! Reader(path: path)
        try! parser.parse()
        let object = parser.object
        XCTAssert(object.string().contains("archiveVersion = 2") == false)
        object["archiveVersion"] = "2"
        XCTAssert(object.string().contains("archiveVersion = 2") == true)
        XCTAssert(object.string().contains("newObject = hello") == false)
        let obj = object["objects"] as! PlistObject
        let obj31 = obj["OBJ_31"] as! PlistObject
        obj31["newObject"] = StringValue(value: "hello", annotation: nil)
        XCTAssert(object.string().contains("newObject = hello") == true)
    }
}
