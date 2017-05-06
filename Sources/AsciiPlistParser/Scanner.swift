import Foundation

enum Type {
    case key, object, array, annotation, string
}

class Scanner {
    func scan(string: String) -> Type {
        let characters = string.characters.map { $0 }
        for (i, c) in characters.enumerated() {
            if characters.count == i + 1 {
                fatalError("Unknown type!: \(string)")
            }
            switch c {
            case "/":
                if characters[i+1] == "*" {
                    return .annotation
                }
            case "(":
                return .array
            case "{":
                return .object
            default:
                return .string
            }
        }
        fatalError()
    }
}
