import Foundation

public class Reader {
    public var object: Object = [:]
    public init(path: String) {
        self.path = path
    }
    public func parse() throws  {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let characters = String(data: data, encoding: .utf8)!.characters.map { $0 }
        iterator = characters.makeIterator()
        if String(iterator.prefix(Const.header.characters.count)) == Const.header {
            for _ in (0..<Const.header.characters.count) {
                _ = iterator.next()
            }
        }
        self.object = try _parse() as! Object
    }

    private let path: String
    private var iterator: IndexingIterator<[Character]>!
    private let scanner = Scanner()
    private func _parse() throws -> Any {
        eatBeginEndAnnotation()
        eatWhiteSpaceAndNewLine()
        let type = scanner.scan(iterator: iterator)
        switch type {
        case .object:
            return try getObject()!
        case .array:
            return getArray()!
        case .string:
            return getStringValue()!
        default:
            throw AsciiPlistParserError.parseFailed
        }
    }

    private func getArray() -> ArrayValue? {
        let result = ArrayValue(value: [])
        while let next = iterator.next() {
            switch next {
            case "(", ",":
                eatWhiteSpaceAndNewLine()
                if String(iterator.prefix(2)) == ");" {
                    eat(1)
                    return result
                }
                result.value.append(getStringValue()!)
            default:
                assertionFailure()
            }
            eatWhiteSpaceAndNewLine()
        }
        return nil
    }

    private func getObject() throws -> Object? {
        let result: Object = [:]
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
                    return result
                }
                keyref = getKeyRef()
            case ";" where keyref == nil:
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                if scanner.scan(iterator: iterator) == .string {
                    keyref = getKeyRef()
                }
            case "=" where keyref != nil:
                eatWhiteSpaceAndNewLine()
                let value = try _parse()
                result[keyref] = value
                assert(String(iterator.prefix(1)) == ";")
                eat(1)
                keyref = nil
            case "}":
                switch String(iterator.prefix(1)) {
                case ";":
                    return result
                default:
                    break
                }
            default:
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()
                eatWhiteSpaceAndNewLine()
                eatBeginEndAnnotation()

                if String(iterator.prefix(2)) == "" {
                    return result
                }
                if scanner.scan(iterator: iterator) == .string {
                    keyref = getKeyRef()
                }
            }
        }
        return result
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

    private func getKeyRef() -> KeyRef? {
        if String(iterator.prefix(1)) == "\"" {
            return getQuotedStringValue()
        }
        guard let value = getBefore([" "]) else {
            return nil
        }
        return KeyRef(value: value, annotation: getAnnotation())
    }

    private func getQuotedStringValue() -> StringValue? {
        guard String(iterator.prefix(1)) == "\"" else {
            return nil
        }
        eat(1) // "
        guard let string = getBefore(["\""]) else {
            return nil
        }
        eat(1) // "
        eatWhiteSpaceAndNewLine()
        return .quoted(value: string, annotation: getAnnotation())
    }

    private func getStringValue() -> StringValue? {
        if String(iterator.prefix(1)) == "\"" {
            return getQuotedStringValue()
        }
        guard let string = getBefore([",", ";"]) else {
            return nil
        }
        if string.contains("/*") {
            let components = string.components(separatedBy: " /* ")
            let value = components.first!
            let last = components.last!
            var it = last.characters.makeIterator()
            var a = ""
            while let next = it.next() {
                a += String(next)
                if String(it.prefix(3)) == " */" {
                    break
                }
            }
            return .raw(value: value, annotation: a)
        } else {
            return .raw(value: string, annotation: nil)
        }
    }

    private func getBefore(_ strings: [String]) -> String? {
        if strings.contains(String(iterator.prefix(1))) {
            return ""
        }
        var result = ""
        var isEscapeNext = String(iterator.prefix(1)) == "\\"
        while let next = iterator.next() {
            result += String(next)
            if isEscapeNext == false && strings.contains(String(iterator.prefix(1))) {
                return result
            }
            if isEscapeNext == false && String(iterator.prefix(1)) == "\\" {
                isEscapeNext = true
            } else {
                isEscapeNext = false
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
        guard scanner.scan(iterator: iterator) == .annotation else {
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
        assertionFailure()
    }

}
