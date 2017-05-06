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
        let result = ArrayValue(value: [])
        while let next = iterator.next() {
            switch next {
            case "(":
                eatWhiteSpaceAndNewLine()
                if String(iterator.prefix(1)) == ")" {
                    return result
                }
                result.value.append(getStringValue()!)
            case ",":
                eatWhiteSpaceAndNewLine()
                if String(iterator.prefix(2)) == ");" {
                    eat(2)
                    return result
                }
                result.value.append(getStringValue()!)
            default:
                fatalError()
            }
            eatWhiteSpaceAndNewLine()
        }
        return nil
    }

    private func getObject() -> PlistObject? {
        let result: PlistObject = [:]
        var keyref: KeyRef!
        while let next = iterator.next() {
            if next == "}" && String(iterator.prefix(4)) == "\n" {
                break
            }
            switch next {
            case "{" where keyref == nil:
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                eatWhiteSpaceAndNewLine()
                if String(iterator.prefix(2)) == "};" {
                    eat(1)
                    return [:]
                }
                keyref = getKeyRef()
            case ";" where keyref == nil:
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                if scanner.scan(string: String(iterator.prefix(2))) == .string {
                    keyref = getKeyRef()
                }
            case "=" where keyref != nil:
                eatWhiteSpaceAndNewLine()
                result[keyref] = _parse()
                keyref = nil
            case "}":
                switch String(iterator.prefix(1)) {
                    case ";":
                        return result
                    default:
                        break
                }
            case "/":
                if String(iterator.prefix(1)) == "*" {

                }
            default:
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                if scanner.scan(string: String(iterator.prefix(2))) == .string {
                    keyref = getKeyRef()
                }
                break
            }
        }
        return result
    }

    private func getKeyRef() -> KeyRef? {
        return getStringValue()
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
        guard let string = getBefore([",", ";", " "]) else {
            return nil
        }
        return StringValue(value: string, annotation: getAnnotation())
    }

    private func getBefore(_ strings: [String]) -> String? {
        var result = ""
        while let next = iterator.next() {
            result += String(next)
            if strings.contains(String(iterator.prefix(1))) {
                return result
            }
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
        let prefix = String(iterator.prefix(4))
        if prefix == "" {
            return
        }
        guard scanner.scan(string: prefix) == .annotation else {
            return
        }
        while let next = iterator.next() {
            switch next {
            case "*":
                if String(iterator.prefix(1)) == "/" {
                    eat(1)
                    return
                }
            default:
                continue
            }
        }
        fatalError()
    }

}
