import Foundation

public struct PlistObject {
    var keys = [String]()
    var dict = [String: Node]()
    public var isNewLineNeeded: Bool = true

    public var count: Int {
        return self.keys.count
    }

    public subscript(key: String) -> Any? {
        get {
            return self.dict[key]?.value.value
        }
        set(newValue) {
            if newValue == nil {
                self.dict.removeValue(forKey: key)
                self.keys = self.keys.filter {$0 != key}
            } else {
                if self[key] == nil {
                    guard let o = newValue as? Node else {
                        fatalError("newValue must be a Node when adding a new entry.")
                    }
                    self.keys.append(key)
                    self.dict[key] = o
                } else {
                    self.dict[key]!.value.value = newValue!
                }
            }
        }
    }
}

// MARK: Collection
extension PlistObject: Collection {
    public func index(after: Int) -> Int {
        return keys.index(after: after)
    }

    public subscript(position: Int) -> Node {
        return dict[keys[position]]!
    }

    public var startIndex: Int {
        return keys.startIndex
    }

    public var endIndex: Int {
        return keys.endIndex
    }
}

// MARK: Sequence
extension PlistObject {
    public func makeIterator() -> AnyIterator<Node> {
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

extension PlistObject: CustomStringConvertible {
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

extension PlistObject: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Node)...) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
}
