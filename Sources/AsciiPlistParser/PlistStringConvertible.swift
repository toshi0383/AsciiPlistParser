import Foundation

protocol PlistStringConvertible {
    func string(_ depth: Int, isNewLineNeeded: Bool) -> String
}

extension Object {
    public func data() -> Data {
        return (string() as NSString).data(using: String.Encoding.utf8.rawValue)!
    }
}

extension Object: PlistStringConvertible {
    func _sorted() -> [(KeyRef, Any)] {
        return self.sorted {
            (fst, snd) in
            if fst.0.value == "isa" {
                return true
            } else if snd.0.value == "isa" {
                return false
            }
            guard let fstobj = fst.1 as? Object,
                let sndobj = snd.1 as? Object else {
                    return fst.0.nonQuotedValue < snd.0.nonQuotedValue
            }
            if let isa1 = fstobj["isa"] as? StringValue,
                let isa2 = sndobj["isa"] as? StringValue {
                if isa1.value == isa2.value {
                    return fst.0.nonQuotedValue < snd.0.nonQuotedValue
                } else {
                    return isa1.value < isa2.value
                }
            }
            if fst.0.nonQuotedValue > snd.0.nonQuotedValue {
                return false
            }
            return true
        }
    }
    public func string(_ depth: Int = 0, isNewLineNeeded: Bool = true) -> String {
        var result = depth == 0 ? "\(Const.header)\n" : ""
        result += "{"
        result += isNewLineNeeded ? "\n" : ""
        var lastIsa: String?
        let sorted = self._sorted()
        for i in (0..<sorted.count) {
            let (keyref, object) = sorted[i]
            // pbxproj compatible
            if let obj = object as? Object {
                let isa = (obj["isa"] as? StringValue)?.value
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
            result += isNewLineNeeded ? tabs(depth + 1) : ""
            result += keyref.string(depth + 1)
            result += " = "
            if isNewLineNeeded {
                if let isa = ((object as? Object)?["isa"] as? StringValue)?.value {
                    if Const.noNewLineIsas.contains(isa) {
                        result += (object as! PlistStringConvertible).string(depth + 1, isNewLineNeeded: false)
                    } else {
                        result += (object as! PlistStringConvertible).string(depth + 1, isNewLineNeeded: true)
                    }
                } else {
                    result += (object as! PlistStringConvertible).string(depth + 1, isNewLineNeeded: true)
                }
            } else {
                result += (object as! PlistStringConvertible).string(depth + 1, isNewLineNeeded: false)
            }
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
    func string(_ depth: Int, isNewLineNeeded: Bool = true) -> String {
        var result = "\(value)"
        if let a = annotation {
            result += " "
            result += _annotation(a)
        }
        return result
    }
}

extension ArrayValue: PlistStringConvertible {
    func string(_ depth: Int, isNewLineNeeded: Bool = true) -> String {
        var result = ""
        result += "(\n"
        for s in value {
            result += "\(tabs(depth + 1))\(s.string(depth, isNewLineNeeded: true)),\n"
        }
        result += "\(tabs(depth)))"
        return result
    }
}

extension String: PlistStringConvertible {
    func string(_ depth: Int, isNewLineNeeded: Bool = true) -> String {
        return self
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
