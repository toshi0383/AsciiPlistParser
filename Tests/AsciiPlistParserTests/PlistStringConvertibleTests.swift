import XCTest
import Foundation

@testable import AsciiPlistParser

class PlistStringConvertibleTests: XCTestCase {
    func testSorted() {
        let parser = Reader(path: pathForFixture(fileName: "Behavior/unsorted.fixture"))
        try! parser.parse()
        let objects = parser.object
        let url = URL(fileURLWithPath: pathForFixture(fileName: "Behavior/sorted.fixture"))
        let expected = NSString(data: try! Data(contentsOf: url), encoding: String.Encoding.utf8.rawValue)!
        XCTAssertEqual(objects.string(), expected as String)
    }

    func testSorted002() {
        let object = Object(dictionaryLiteral:
            fileRef(with: "A12345"),
            buildFile(with: "B1234"),
            buildFile(with: "B1233"),
            buildFile(with: "\"C1233\""),
            fileRef(with: "A12346"),
            buildFile(with: "B1231")
        )
        let keyrefs = object._sorted().map{$0.0.value}
        XCTAssertEqual(keyrefs, [
            "B1231",
            "B1233",
            "B1234",
            "C1233",
            "A12345",
            "A12346",
        ])
    }

    func testStringValue() {
        let value: StringValue = .raw(value: "Hello", annotation: "Hello.swift in Sources")
        let expected = "Hello /* Hello.swift in Sources */"
        XCTAssertEqual(value.string(0), expected)
        XCTAssertEqual(StringValue(value: "Hello", annotation: nil).string(0), "Hello")
    }

    func testQuotedStringValue() {
        let value: StringValue = .quoted(value: "Hello", annotation: "Hello.swift in Sources")
        let expected = "\"Hello\" /* Hello.swift in Sources */"
        XCTAssertEqual(value.string(0), expected)
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

    func testObject() {
        let keyref = KeyRef(value: "1232143145344569590", annotation: "Annotation")
        let value = StringValue(value: "Hello", annotation: nil)
        let object = Object(dictionaryLiteral: (keyref, value))
        let expected = [
            "{",
            "\t\t1232143145344569590 /* Annotation */ = Hello;",
            "\t}",
        ].joined(separator: "\n")
        XCTAssertEqual(object.string(1), expected)
    }

    func testPbxprojCompatibility() {
        let buildfile = Object(dictionaryLiteral: 
            buildFile(with: "1111111111")
        )
        XCTAssertEqual(buildfile.string(1), [
            "{",
            "",
            "/* Begin PBXBuildFile section */",
            "\t\t1111111111 = {isa = PBXBuildFile; };",
            "/* End PBXBuildFile section */",
            "\t}",
            ].joined(separator: "\n")
        )
        let fileref = Object(dictionaryLiteral: 
            fileRef(with: "1111111111")
        )
        XCTAssertEqual(fileref.string(1), [
            "{",
            "",
            "/* Begin PBXFileReference section */",
            "\t\t1111111111 = {isa = PBXFileReference; };",
            "/* End PBXFileReference section */",
            "\t}",
            ].joined(separator: "\n")
        )
    }
}
