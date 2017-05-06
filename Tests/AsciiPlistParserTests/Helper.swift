import Foundation
import AsciiPlistParser

func pathForFixture(fileName: String) -> String {
    #if Xcode
        return Bundle(for: ReaderTests.self).path(forResource: fileName, ofType: nil)!
    #else
        return "Tests/AsciiPlistParserTests/Fixtures/\(fileName)"
    #endif
}
