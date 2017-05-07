import XCTest
import Foundation
@testable import AsciiPlistParser

class ObjectTests: XCTestCase {
    func testObjectEquatableAgainstStringValue() {
        let o1: Object = ["Key1": "" as StringValue]
        let o2: Object = ["Key1": "" as StringValue]
        XCTAssertEqual(o1, o2)
        let o3: Object = ["Key1": "" as String]
        XCTAssertNotEqual(o1, o3)
        let o4: Object = ["Key1": [""] as ArrayValue]
        XCTAssertNotEqual(o1, o4)
        let o5: Object = ["Key1": o1]
        XCTAssertNotEqual(o1, o5)
    }

    func testObjectEquatableAgainstOtherTypes() {
        let o1: Object = ["Key1": "1" as String]
        let o2: Object = ["Key1": 1 as Int]
        let o3: Object = ["Key1": (1, 2)]
        let o4: Object = ["Key1": ["1"]]
        let o5: Object = ["Key1": ["String": "Value"]]
        let o6: Object = ["Key1": "1" as String]
        let o7: Object = ["Key1": 1 as Int]
        let o8: Object = ["Key1": (1, 2)]
        let o9: Object = ["Key1": ["1"]]
        let o10: Object = ["Key1": ["String": "Value"]]
        XCTAssertNotEqual(o1, o2)
        XCTAssertNotEqual(o1, o3)
        XCTAssertNotEqual(o1, o4)
        XCTAssertNotEqual(o1, o5)
        XCTAssertNotEqual(o1, o6)
        XCTAssertNotEqual(o2, o7)
        XCTAssertNotEqual(o3, o8)
        XCTAssertNotEqual(o4, o9)
        XCTAssertNotEqual(o5, o10)
    }
}
