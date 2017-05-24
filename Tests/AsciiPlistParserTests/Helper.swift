import Foundation
import PathKit
import AsciiPlistParser

enum Const {
    fileprivate static let fixturesPath = "Tests/AsciiPlistParserTests/Fixtures"
}

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

func _xcodeprojFixturePaths() -> [String] {
    #if Xcode
        return [pathForFixture(fileName: "test.pbxproj")]
    #else
        return try! Path(Const.fixturesPath).recursiveChildren()
            .filter { $0.lastComponent.hasSuffix(".pbxproj") }
            .map { $0.string }
    #endif
}

func fileRef(with keyrefValue: String) -> (KeyRef, Any) {
    return (
        KeyRef(value: keyrefValue, annotation: nil),
        Object(dictionaryLiteral:
            (KeyRef(value: "isa", annotation: nil), StringValue(value: "PBXFileReference", annotation: nil))
        )
    )
}
