import Foundation

public class Reader {
    private let path: String
    public var object: PlistObject = [:]
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
        self.object = _parse() as! PlistObject
    }

    private func _parse() -> Any {
        eatBeginEndAnnotation()
        eatWhiteSpaceAndNewLine()
        let prefix = String(iterator.prefix(2))
        let type = scanner.scan(string: prefix)
        switch type {
        case .object:
            return getObject()!
        case .array:
            return getArray()!
        case .string:
            return getStringValue()!
        default:
            fatalError()
        }
    }

    private func getArray() -> ArrayValue? {
        var result: ArrayValue = []
        var characters: [Character] = []
        while let next = iterator.next() {
            switch next {
            case "(" where characters.isEmpty:
                eatWhiteSpaceAndNewLine()
                if String(iterator.prefix(1)) == ")" {
                    return []
                }
            case ",":
                if characters.isEmpty {
                    continue
                }
                result.value.append(StringValue(value: String(characters), annotation: getAnnotation()))
                characters = []
            case " ":
                if characters.isEmpty {
                    continue
                }
                result.value.append(StringValue(value: String(characters), annotation: getAnnotation()))
                characters = []
            case ")":
                if String(iterator.prefix(1)) == ";" {
                    eat(1)
                    return result
                } else {
                    characters.append(next)
                }
            default:
                characters.append(next)
            }
            eatWhiteSpaceAndNewLine()
        }
        return nil
    }

    private func getObject() -> PlistObject? {
        var result: PlistObject = [:]
        var keyref: KeyRef!
        while let next = iterator.next() {
            if next == "}" && String(iterator.prefix(4)) == "\n" {
                break
            }
            eatWhiteSpaceAndNewLine()
            eatBeginEndAnnotation()
            switch next {
            case "{" where keyref == nil:
                eatWhiteSpaceAndNewLine()
                if String(iterator.prefix(1)) == "}" {
                    eat(1)
                    return [:]
                }
                continue
            case ("a"..."z"), ("A"..."Z"), ("0"..."9"), "_":
                if keyref == nil {
                    keyref = getKeyRef(prefix: next)
                    continue
                }
            case "=" where keyref != nil:
                eatWhiteSpaceAndNewLine()
                result[keyref.id] = _parse()
                keyref = nil
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
        }
        return result
    }

    private func getKeyRef(prefix: Character) -> KeyRef? {
        eatWhiteSpaceAndNewLine()
        guard let value = getStringValue() else {
            return nil
        }
        return KeyRef(id: String(prefix) + value.value, annotation: value.annotation)
    }

    private func getAnnotation() -> String? {
        eatWhiteSpaceAndNewLine()
        let prefix = String(iterator.prefix(8))
        guard prefix.characters.starts(with: "/* ".characters) && prefix != "/* Begin" else {
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

    private func getStringValue() -> StringValue? {
        guard let string = getBefore([";", " "]) else {
            return nil
        }
        return StringValue(value: string, annotation: getAnnotation())
    }

    private func getBefore(_ strings: [String]) -> String? {
        var result = ""
        while let next = iterator.next() {
            if strings.contains(String(next)) {
                return result
            }
            result += String(next)
        }
        return nil
    }

    private func eatWhiteSpaceAndNewLine() {
        while [" ", "\t", "\n",].contains(String(iterator.prefix(1))) {
            eat(1)
        }
    }

    private func eat(_ count: Int) {
        for _ in (0..<count) {
            _ = iterator.next()
        }
    }

    private func eatBeginEndAnnotation() {
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
