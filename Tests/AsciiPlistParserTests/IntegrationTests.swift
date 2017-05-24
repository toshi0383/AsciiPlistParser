import XCTest
@testable import AsciiPlistParser

class IntegrationTests: XCTestCase {
    func testSuccessfullyParseFixtures() {
        let paths = _xcodeprojFixturePaths()
        for path in paths {
            print(path)
            let parser = Reader(path: path)
            do {
                try parser.parse()
                _ = parser.object
            } catch {
                XCTFail("Parse failed: \(path)")
            }
        }
    }
}
