import Foundation
import AsciiPlistParser

func pathForFixture(fileName: String) -> String {
    #if Xcode
        let name = fileName.components(separatedBy: "/").last!
        return Bundle(for: PlistStringConvertibleTests.self).path(forResource: name, ofType: nil)!
    #else
        return "Tests/AsciiPlistParserTests/Fixtures/\(fileName)"
    #endif
}

func buildFile(with keyrefValue: String) -> (KeyRef, Any) {
    return (
        KeyRef(value: keyrefValue, annotation: nil),
        Object(dictionaryLiteral:
            (KeyRef(value: "isa", annotation: nil), StringValue(value: "PBXBuildFile", annotation: nil))
        )
    )
}

func fileRef(with keyrefValue: String) -> (KeyRef, Any) {
    return (
        KeyRef(value: keyrefValue, annotation: nil),
        Object(dictionaryLiteral:
            (KeyRef(value: "isa", annotation: nil), StringValue(value: "PBXFileReference", annotation: nil))
        )
    )
}
