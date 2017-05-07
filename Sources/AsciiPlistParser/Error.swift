import Foundation

enum AsciiPlistParserError: Error {
    case fileNotFound(path: String)
    case parseFailed
}
