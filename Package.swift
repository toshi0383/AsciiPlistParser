// swift-tools-version:3.1

import Foundation
import PackageDescription

var isDevelopment: Bool {
	return ProcessInfo.processInfo.environment["SWIFTPM_DEVELOPMENT"] == "YES"
}

let package = Package(
    name: "AsciiPlistParser",
    dependencies: {
        var deps: [Package.Dependency] = [
            .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0),
        ]
        if isDevelopment {
            deps += [
                .Package(url: "https://github.com/krzysztofzablocki/Sourcery.git", majorVersion: 0, minor: 6),
            ]
        }
        return deps
    }(),
    exclude: ["Resources/SourceryTemplates", "Tests/AsciiPlistParserTests/Fixtures"]
)
