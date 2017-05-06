import XCTest
import Foundation

@testable import AsciiPlistParser

class PlistStringConvertibleTests: XCTestCase {
    func testSorted() {
        super.setUp()
        let parser = try! Reader(path: pathForFixture(fileName: "unsorted.fixture"))
        try! parser.parse()
        let objects = parser.object
        let url = URL(fileURLWithPath: pathForFixture(fileName: "sorted.fixture"))
        let expected = NSString(data: try! Data(contentsOf: url), encoding: String.Encoding.utf8.rawValue)!
        XCTAssertEqual(objects.string(), expected as String)
    }

    func testStringStringValue() {
        let value = StringValue(value: "Hello", annotation: "Hello.swift in Sources")
        let expected = "Hello /* Hello.swift in Sources */"
        XCTAssertEqual(value.string(0), expected)
        XCTAssertEqual(StringValue(value: "Hello", annotation: nil).string(0), "Hello")
    }

    func testArrayStringValue() {
        let hello = StringValue(value: "Hello", annotation: "Hello.swift in Sources")
        let world = StringValue(value: "World", annotation: "World.swift in Sources")
        let value = ArrayValue(value: [hello, world])
        let expected = [
            "(",
            "\tHello /* Hello.swift in Sources */,",
            "\tWorld /* World.swift in Sources */,",
            ")",
        ].joined(separator: "\n")
        XCTAssertEqual(value.string(0), expected)
    }

    func testPlistObject() {
        let keyref = KeyRef(id: "1232143145344569590", annotation: "Annotation")
        let value = StringValue(value: "Hello", annotation: nil)
        let object = PlistObject(dictionaryLiteral: (keyref, value))
        let expected = [
            "{",
            "\t\t1232143145344569590 /* Annotation */ = Hello;",
            "\t}",
        ].joined(separator: "\n")
        XCTAssertEqual(object.string(1), expected)
    }
}
