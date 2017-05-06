import Foundation

protocol PlistStringConvertible {
    func string(_ depth: Int, xcode: Bool) -> String
}

extension PlistObject {
    public func data() -> Data {
        return (string() as NSString).data(using: String.Encoding.utf8.rawValue)!
    }
}

extension PlistObject: PlistStringConvertible {
    public func string(_ depth: Int = 0, xcode: Bool = true) -> String {
        var result = depth == 0 ? "\(Const.header)\n" : ""
        result += "{"
        result += isNewLineNeeded ? "\n" : ""
        var lastIsa: String?
        let sorted = self.sorted {
            (fst, snd) in
            if let isa1 = (fst.value.value as? PlistObject)?["isa"] as? String,
                let isa2 = (snd.value.value as? PlistObject)?["isa"] as? String {
                if isa1 > isa2 { return false }
                if fst.key.id > snd.key.id { return false }
            }
            if fst.key.id > snd.key.id { return false }
            return true
        }
        for (i, node) in sorted.enumerated() {
            // pbxproj compatible
            let isa = (node.value.value as? PlistObject)?["isa"] as? String
            if let lastIsa = lastIsa {
                if let isa = isa {
                    if lastIsa != isa {
                        // write end of lastIsa
                        result += endSection(lastIsa)
                        result += "\n"
                        // write begin of isa
                        result += "\n"
                        result += beginSection(isa)
                        result += "\n"
                    }
                } else {
                    // write end of lastIsa
                    result += endSection(lastIsa)
                    result += "\n"
                }
            } else {
                if let isa = isa {
                    // write begin of isa
                    result += "\n"
                    result += beginSection(isa)
                    result += "\n"
                }
            }
            // plist writing
            lastIsa = isa
            result += node.string(depth + 1)
            result += ";"
            result += isNewLineNeeded ? "\n" : " "
            // if isLastObject
            if self.count - 1 == i {
                // write end of lastIsa
                if let lastIsa = lastIsa {
                    result += endSection(lastIsa)
                    result += "\n"
                }
            }
        }
        if isNewLineNeeded && depth > 0 {
            result += tabs(depth)
        }
        result += depth == 0 ? "}\n" : "}"
        return result
    }
}

extension Node: PlistStringConvertible {
    func string(_ depth: Int, xcode: Bool = true) -> String {
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
    func string(_ depth: Int, xcode: Bool = true) -> String {
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
            result += values.map { "\(tabs(depth + 1))\($0.string(depth + 1))," }.joined(separator: "\n")
            result += "\n"
            result += tabs(depth)
            result += ")"
        default:
            fatalError()
        }
        return result
    }
}

func tabs(_ depth: Int) -> String {
    return (0..<depth).reduce("") { $0.0 + "\t" }
}

func beginSection(_ section: String) -> String {
    return annotation("Begin \(section) section")
}

func endSection(_ section: String) -> String {
    return annotation("End \(section) section")
}

func annotation(_ string: String) -> String {
    return "/* \(string) */"
}
