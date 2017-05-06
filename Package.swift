// swift-tools-version:3.1

import Foundation
import PackageDescription

var isDevelopment: Bool {
	return ProcessInfo.processInfo.environment["SWIFTPM_DEVELOPMENT_AsciiPlistParser"] == "YES"
}

var isSwiftPackagerManagerTest: Bool {
	return ProcessInfo.processInfo.environment["SWIFTPM_TEST_AsciiPlistParser"] == "YES"
}

let package = Package(
    name: "AsciiPlistParser",
    dependencies: {
        var deps: [Package.Dependency] = []
        if isDevelopment {
            deps += [
                .Package(url: "https://github.com/krzysztofzablocki/Sourcery.git", majorVersion: 0, minor: 6),
            ]
        }
//        if isSwiftPackagerManagerTest {
//            deps += [
//                .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
//                .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1, minor: 1),
//                .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 6, minor: 1),
//            ]
//        }
        return deps
    }(),
    exclude: ["Resources/SourceryTemplates", "Tests/AsciiPlistParserTests/Fixtures"]
)
