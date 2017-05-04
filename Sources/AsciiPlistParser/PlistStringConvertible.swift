import Foundation

protocol PlistStringConvertible {
    func string(_ depth: Int) -> String
}

extension PlistObject: PlistStringConvertible {
    public func data() -> Data {
        return (string() as NSString).data(using: String.Encoding.utf8.rawValue)!
    }
    public func string(_ depth: Int = 0) -> String {
        var result = ""
        result += "{"
        result += isNewLineNeeded ? "\n" : ""
        var lastIsa: String?
        for node in self {
            result += node.string(depth + 1)
            result += isNewLineNeeded ? "\n" : " "
        }
        if isNewLineNeeded && depth > 0 {
            result += tabs(depth)
        }
        result += depth == 0 ? "}" : "};"
        return result
    }
}

extension Node: PlistStringConvertible {
    func string(_ depth: Int) -> String {
        var result = ""
        result += tabs(depth)
        result += key.id
        if let annotation = key.annotation {
            result += " /* \(annotation) */"
        }
        result += " = "
        result += value.string(depth)
        return result
    }
}

extension Value: PlistStringConvertible {
    func string(_ depth: Int) -> String {
        var result = ""
        switch value {
        case let object as PlistObject:
            result += object.string(depth)
        case let string as String:
            result += "\(string)"
            if let annotation = annotation {
                result += " /* \(annotation) */"
            }
        case let values as [Value]:
            result += "(\n"
            result += values.map { "\(tabs(depth + 1))\($0.string(depth + 1))" }.joined(separator: ",\n")
            result += "\n\(tabs(depth)));"
        default:
            fatalError()
        }
        return result
    }
}

func tabs(_ depth: Int) -> String {
    return (0..<depth).reduce("") { $0.0 + "\t" }
}
