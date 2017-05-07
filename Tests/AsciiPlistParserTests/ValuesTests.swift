import XCTest
import Foundation
@testable import AsciiPlistParser

class ValuesTests: XCTestCase {
    func testStringValueCanBeExpressedByStringLiteral() {
        let v1: StringValue = "Hello1234"
        XCTAssertEqual(v1, StringValue(value: "Hello1234", annotation: nil))
        let v2: StringValue = ""
        XCTAssertEqual(v2, StringValue(value: "", annotation: nil))
    }
    func testArrayValueCanBeExpressedByArrayLiteral() {
        let v1: ArrayValue = ["Hello1234", "ABCD"]
        XCTAssertEqual(v1, ArrayValue(value: [
            StringValue(value: "Hello1234", annotation: nil),
            StringValue(value: "ABCD", annotation: nil),
            ]))
        let v2: ArrayValue = [""]
        XCTAssertEqual(v2, ArrayValue(value: [StringValue(value: "", annotation: nil)]))
    }
}
