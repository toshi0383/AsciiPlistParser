import Foundation

public enum AsciiPlistParserError: Error {
    case fileNotFound(path: String)
    case parseFailed
}
