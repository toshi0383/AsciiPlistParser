import Foundation

public struct PlistDictionary {
    var keys = [String]()
    var dict = [String: Object]()

    public var count: Int {
        return self.keys.count
    }

    public subscript(key: String) -> Object? {
        get {
            return self.dict[key]
        }
        set(newValue) {
            if newValue == nil {
                self.dict.removeValue(forKey:key)
                self.keys = self.keys.filter {$0 != key}
            } else {
                let oldValue = self.dict.updateValue(newValue!, forKey: key)
                if oldValue == nil {
                    self.keys.append(key)
                }
            }
        }
    }
}

extension PlistDictionary: Sequence {
    public func makeIterator() -> AnyIterator<Object> {
        var counter = 0
        return AnyIterator {
            guard counter<self.keys.count else {
                return nil
            }
            let next = self.dict[self.keys[counter]]
            counter += 1
            return next
        }
    }
}

extension PlistDictionary: CustomStringConvertible {
    public var description: String {
        let isString = type(of: self.keys[0]) == String.self
        var result = "["
        for key in keys {
            result += isString ? "\"\(key)\"" : "\(key)"
            result += ": \(self[key]!), "
        }
        result = String(result.characters.dropLast(2))
        result += "]"
        return result
    }
}

extension PlistDictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Object)...) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
}
