import Foundation

enum ParserError: Error {
    case fileNotFound(path: String)
    case parseFailed
}
