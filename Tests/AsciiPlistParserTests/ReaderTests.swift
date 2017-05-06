import XCTest
import Foundation
@testable import AsciiPlistParser

class ReaderTests: XCTestCase {
#if Xcode
#else
    func testReader() {
        let path = pathForFixture(fileName: "Xcode/8.3.2/SingleViewApplication/SingleViewApplication.xcodeproj/project.pbxproj")
        let parser = try! Reader(path: path)
        try! parser.parse()
        let object = parser.object

        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let content = String(data: data, encoding: String.Encoding.utf8)!
        XCTAssertEqual(object.string(), content)

        XCTAssertEqual((object["archiveVersion"] as! StringValue).value, "1")
        guard let dict = object["objects"] as? Object else {
            XCTFail()
            return
        }
        let obj1 = dict["1F88C5881EB47C3C002A5302"]! as! Object
        XCTAssertEqual((obj1["isa"]! as! StringValue).value, "PBXBuildFile")
        let obj2 = dict["1F88C5AD1EB47C3C002A5302"]! as! Object
        XCTAssertEqual((obj2["isa"]! as! StringValue).value, "XCBuildConfiguration")
        let buildSettigs = obj2["buildSettings"] as! Object
        XCTAssertEqual((buildSettigs["ENABLE_TESTABILITY"] as! StringValue).value, "YES")
    }
#endif

    func testModification() {
        let path = pathForFixture(fileName: "Behavior/unsorted.fixture")
        let parser = try! Reader(path: path)
        try! parser.parse()
        let object = parser.object
        // Update object
        XCTAssert(object.string().contains("archiveVersion = 2") == false)
        object["archiveVersion"] = "2"
        XCTAssert(object.string().contains("archiveVersion = 2") == true)
        // Update nested object
        XCTAssert(object.string().contains("newObject = hello") == false)
        let obj = object["objects"] as! Object
        let obj31 = obj["OBJ_31"] as! Object
        obj31["newObject"] = StringValue(value: "hello", annotation: nil)
        XCTAssert(object.string().contains("newObject = hello") == true)
    }
}
