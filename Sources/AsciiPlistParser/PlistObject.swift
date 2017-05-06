import Foundation

public struct PlistObject {
    var keyrefs = [KeyRef]()
    var dict = [KeyRef: Any]()

    public var count: Int {
        return self.keyrefs.count
    }

    private func keyRef(for key: String) -> KeyRef? {
        func samekey(_ element: KeyRef) -> Bool {
            return element.value == key
        }
        guard keyrefs.contains(where: samekey) else { return nil }
        return keyrefs.filter(samekey)[0]
    }

    public subscript(key: String) -> Any? {
        get {
            func samekey(_ element: KeyRef) -> Bool {
                return element.value == key
            }
            guard keyrefs.contains(where: samekey) else {
                return nil
            }
            let keyref = keyrefs.filter(samekey)[0]
            return self.dict[keyref]
        }
        set(newValue) {
            if let keyref = keyRef(for: key) {
                if newValue == nil {
                    self.dict.removeValue(forKey: keyref)
                    self.keyrefs = self.keyrefs.filter { $0 != keyref }
                } else {
                    self.dict[keyref] = newValue!
                }
            } else {
                let keyref = KeyRef(value: key, annotation: nil)
                if let v = newValue {
                    self.keyrefs.append(keyref)
                    self.dict[keyref] = v
                }
            }
        }
    }

    public subscript(keyref: KeyRef) -> Any? {
        get {
            return self.dict[keyref]
        }
        set(newValue) {
            if newValue == nil {
                self.dict.removeValue(forKey: keyref)
                self.keyrefs = self.keyrefs.filter { $0 != keyref }
            } else {
                if self[keyref] == nil {
                    self.keyrefs.append(keyref)
                    self.dict[keyref] = newValue!
                } else {
                    self.dict[keyref]! = newValue!
                }
            }
        }
    }
}

// MARK: Collection
extension PlistObject: Collection {
    public func index(after: Int) -> Int {
        return keyrefs.index(after: after)
    }

    public subscript(position: Int) -> (KeyRef, Any) {
        let keyref = keyrefs[position]
        return (keyref, dict[keyref]!)
    }

    public var startIndex: Int {
        return keyrefs.startIndex
    }

    public var endIndex: Int {
        return keyrefs.endIndex
    }
}

// MARK: Sequence
extension PlistObject {
    public func makeIterator() -> AnyIterator<(KeyRef, Any)> {
        var counter = 0
        return AnyIterator {
            guard counter<self.keyrefs.count else {
                return nil
            }
            let keyref = self.keyrefs[counter]
            let next = self.dict[keyref]!
            counter += 1
            return (keyref, next)
        }
    }
}

extension PlistObject: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (KeyRef, Any)...) {
        self.init()
        for (keyref, value) in elements {
            self[keyref] = value
        }
    }
}
