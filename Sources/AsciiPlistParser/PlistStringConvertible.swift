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
            guard let fstobj = fst.1 as? PlistObject,
                let sndobj = snd.1 as? PlistObject else {
                return true
            }
            if let isa1 = fstobj["isa"] as? String,
                let isa2 = sndobj["isa"] as? String {
                if isa1 > isa2 { return false }
            }
            return true
        }
        for i in (0..<sorted.count) {
            let (keyref, object) = sorted[i]
            // pbxproj compatible
            if let obj = object as? PlistObject {
                let isa = obj["isa"] as? String
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
                lastIsa = isa
            } else {
                lastIsa = nil
            }
            // plist writing
            result += keyref.string(depth + 1)
            result += isNewLineNeeded ? "\n" : " "
            result += " = "
            result += (object as! PlistStringConvertible).string(depth + 1, xcode: xcode)
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

extension StringValue: PlistStringConvertible {
    func string(_ depth: Int, xcode: Bool = true) -> String {
        var result = "\(string)"
        if let a = annotation {
            result += _annotation(a)
        }
        return result
    }
}

extension ArrayValue: PlistStringConvertible {
    func string(_ depth: Int, xcode: Bool = true) -> String {
        var result = ""
        result += "\(tabs(depth))("
        for s in value {
            result += "\(tabs(depth))\(s),\n"
        }
        result += "\(tabs(depth)))"
        return result
    }
}

extension KeyRef: PlistStringConvertible {
    func string(_ depth: Int, xcode: Bool = true) -> String {
        var result = "\(id) "
        if let a = annotation {
            result += _annotation(a)
        }
        return result
    }
}

func tabs(_ depth: Int) -> String {
    return (0..<depth).reduce("") { $0.0 + "\t" }
}

func beginSection(_ section: String) -> String {
    return _annotation("Begin \(section) section")
}

func endSection(_ section: String) -> String {
    return _annotation("End \(section) section")
}

func _annotation(_ string: String) -> String {
    return "/* \(string) */"
}
