import Foundation

public class Reader {
    private let path: String
    public var objects: PlistDictionary = [:]
    private var iterator: IndexingIterator<[Character]>!
    private let scanner = Scanner()
    public init(path: String) throws {
        self.path = path
    }
    public func parse() throws  {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let characters = String(data: data, encoding: String.Encoding.utf8)!.characters.map { $0 }
        iterator = characters.makeIterator()
        if String(iterator.prefix(Const.header.characters.count)) == Const.header {
            for _ in (0..<Const.header.characters.count) {
                _ = iterator.next()
            }
        }
        self.objects = _parse() as! PlistDictionary
    }

    private func _parse() -> Any {
        eatBeginEndAnnotation()
        eatWhiteSpace()
        let prefix = String(iterator.prefix(4))
        let type = scanner.scan(string: prefix)
        switch type {
        case .objects:
            return getObjects()!
        case .array:
            return getArray()!
        case .string:
            return getString()!
        default:
            fatalError()
        }
    }

    private func getArray() -> [Value]? {
        var result: [Value] = []
        var characters: [Character] = []
        while let next = iterator.next() {
            switch next {
            case "(":
                eatWhiteSpace()
                if String(iterator.prefix(1)) == ")" {
                    return []
                }
            case ("a"..."z"), ("A"..."Z"), ("0"..."9"), "_":
                characters.append(next)
            case ",":
                if characters.isEmpty {
                    continue
                }
                result.append(Value(value: String(characters), annotation: getAnnotation()))
                characters = []
            case " ":
                if characters.isEmpty {
                    continue
                }
                result.append(Value(value: String(characters), annotation: getAnnotation()))
                characters = []
            case ")":
                if String(iterator.prefix(1)) == ";" {
                    eat(1)
                    return result
                }
            default:
                continue
            }
        }
        return nil
    }

    private func getObjects() -> PlistDictionary? {
        eatBeginEndAnnotation()
        eatWhiteSpace()
        var result: PlistDictionary = [:]
        var key: KeyRef!
        while let next = iterator.next() {
            if next == "}" && String(iterator.prefix(4)) == "\n" {
                break
            }
            eatBeginEndAnnotation()
            eatWhiteSpace()
            switch next {
            case "{" where key == nil:
                eatWhiteSpace()
                if String(iterator.prefix(1)) == "}" {
                    eat(1)
                    return [:]
                }
                continue
            case ("a"..."z"), ("A"..."Z"), ("0"..."9"), "_":
                if key == nil {
                    key = getKeyRef(prefix: next)
                    continue
                }
            case "=" where key != nil:
                let value = Value(value: _parse(), annotation: getAnnotation())
                result[key.id] = Object(key: key, value: value)
                key = nil
                continue
            case "}":
                switch String(iterator.prefix(1)) {
                    case ";":
                        return result
                    default:
                        break
                }
            default:
                break
            }
            eatBeginEndAnnotation()
            eatWhiteSpace()
        }
        return result
    }

    private func getKeyRef(prefix: Character) -> KeyRef? {
        eatBeginEndAnnotation()
        eatWhiteSpace()
        guard let string = getString() else {
            return nil
        }
        return KeyRef(id: String(prefix) + string, annotation: getAnnotation())
    }

    private func getAnnotation() -> String? {
        eatWhiteSpace()
        guard String(iterator.prefix(3)) == "/* " else {
            return nil
        }
        eat(3)
        var result: [Character] = []
        while let next = iterator.next() {
            switch next {
            case " ":
                if String(iterator.prefix(2)) == "*/" {
                    eat(2)
                    return String(result)
                } else {
                    result.append(next)
                }
            default:
                result.append(next)
            }
        }
        return nil
    }

    private func getString() -> String? {
        eatWhiteSpace()
        if "};" == String(iterator.prefix(2)) {
            // This would be an empty string
            eat(2)
            return nil
        }
        var result: [Character] = []
        while let next = iterator.next() {
            result.append(next)
            switch String(iterator.prefix(1)) {
            case ";", " ":
                eat(1)
                return String(result)
            default:
                continue
            }
        }
        return nil
    }

    private func getBefore(_ string: String) -> String {
        var result = ""
        while let next = iterator.next() {
            result += String(next)
            switch String(iterator.prefix(string.characters.count)) {
            case string:
                return result
            default:
                continue
            }
        }
        return result
    }

    private func eatWhiteSpace() {
        while [" ", "\t", "\n"].contains(String(iterator.prefix(1))) {
            eat(1)
        }
    }

    private func eat(_ count: Int) {
        for _ in (0..<count) {
            _ = iterator.next()
        }
    }

    private func eatBeginEndAnnotation() {
        eatWhiteSpace()
        guard scanner.scan(string: String(iterator.prefix(4))) == .annotation else {
            return
        }
        while let next = iterator.next() {
            switch next {
            case "*":
                if String(iterator.prefix(2)) == "/\n" {
                    eat(2)
                    return
                }
            default:
                continue
            }
        }
    }

}
