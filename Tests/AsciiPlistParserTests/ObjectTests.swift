import XCTest
import Foundation
@testable import AsciiPlistParser

class ObjectTests: XCTestCase {
    func testObjectEquatableAgainstStringValue() {
        let o1: Object = ["Key1": "" as StringValue]
        let o2: Object = ["Key1": "" as StringValue]
        XCTAssertEqual(o1, o2)
        let o4: Object = ["Key1": [""] as ArrayValue]
        XCTAssertNotEqual(o1, o4)
        let o5: Object = ["Key1": o1]
        XCTAssertNotEqual(o1, o5)
    }
}
