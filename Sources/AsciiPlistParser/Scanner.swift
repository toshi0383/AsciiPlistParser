import Foundation

enum Type {
    case key, object, array, annotation, string, unknown
}

class Scanner {
    func scan(iterator: IndexingIterator<[Character]>) -> Type {
        let string = String(iterator.prefix(2))
        if string == "" {
            return .unknown
        }
        let characters = string.characters.map { $0 }
        for (i, c) in characters.enumerated() {
            switch c {
            case "/":
                if characters[i+1] == "*" {
                    return .annotation
                }
            case "(":
                return .array
            case "{":
                return .object
            case ("a"..."z"), ("A"..."Z"), ("0"..."9"), "_", "\"":
                return .string
            default:
                return .unknown
            }
        }
        return .unknown
    }
}
