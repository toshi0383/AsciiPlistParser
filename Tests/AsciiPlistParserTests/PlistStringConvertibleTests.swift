import XCTest
import Foundation

@testable import AsciiPlistParser

class PlistStringConvertibleTests: XCTestCase {
    var objects: PlistObject!
    override func setUp() {
        super.setUp()
        let path = pathForFixture(fileName: "unsorted.fixture")
        let parser = try! Reader(path: path)
        try! parser.parse()
        objects = parser.objects
    }

    func testSorted() {
        let path = pathForFixture(fileName: "sorted.fixture")
        let url = URL(fileURLWithPath: path)
        let expected = NSString(data: try! Data(contentsOf: url), encoding: String.Encoding.utf8.rawValue)!
        XCTAssertEqual(objects.string(), expected as String)
    }
}
