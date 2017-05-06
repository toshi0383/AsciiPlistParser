import XCTest
@testable import AsciiPlistParser

#if Xcode
#else
class ReaderTests: XCTestCase {
    var object: PlistObject!
    override func setUp() {
        super.setUp()
        let path = pathForFixture(fileName: "Xcode/8.3.2/SingleViewApplication/SingleViewApplication.xcodeproj/project.pbxproj")
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
        let obj26 = dict["1F88C5881EB47C3C002A5302"]! as! PlistObject
        XCTAssertEqual((obj26["isa"]! as! StringValue).value, "PBXBuildFile")
        let obj24 = dict["1F88C5AD1EB47C3C002A5302"]! as! PlistObject
        XCTAssertEqual((obj24["isa"]! as! StringValue).value, "XCBuildConfiguration")
        let buildSettigs = obj24["buildSettings"] as! PlistObject
        XCTAssertEqual((buildSettigs["ENABLE_TESTABILITY"] as! StringValue).value, "YES")
    }
}
#endif
