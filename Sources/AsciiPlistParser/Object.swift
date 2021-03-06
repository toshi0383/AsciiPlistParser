import Foundation

public final class Object {
    var keyrefs = [KeyRef]()
    var dict = [KeyRef: Any]()

    public var count: Int {
        return self.keyrefs.count
    }

    public func keyRef(for key: String) -> KeyRef? {
        func samekey(_ element: KeyRef) -> Bool {
            return element.value == key
        }
        guard keyrefs.contains(where: samekey) else { return nil }
        return keyrefs.filter(samekey)[0]
    }

    public subscript(key: String) -> Any? {
        set(newValue) {
            self[KeyRef(value: key, annotation: nil)] = newValue
        }
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
    }

    public subscript(keyref: KeyRef) -> Any? {
        get {
            return self.dict[keyref]
        }
        set(newValue) {
            if let newValue = newValue {
                guard validateValueType(newValue) else {
                    assertionFailure(); return
                }
                let v: Any
                if let newValue = newValue as? String {
                    v = StringValue(value: newValue, annotation: nil)
                } else if let newValue = newValue as? [String] {
                    v = ArrayValue(value: newValue.map {StringValue(value: $0, annotation: nil)})
                } else if let newValue = newValue as? [String: Any] {
                    v = Object(dictionary: newValue)
                } else {
                    v = newValue
                }
                if self[keyref] == nil {
                    self.keyrefs.append(keyref)
                    self.dict[keyref] = v
                } else {
                    self.dict[keyref] = v
                }
            } else {
                if let idx = self.keyrefs.index(of: keyref) {
                    self.keyrefs.remove(at: idx)
                    self.dict.removeValue(forKey: keyref)
                }
            }
        }
    }
}

// MARK: Collection
extension Object: Collection {
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
extension Object {
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

// MARK: ExpressibleByDictionaryLiteral
extension Object: ExpressibleByDictionaryLiteral {
    public convenience init(dictionary elements: [String: Any]) {
        self.init()
        for (string, value) in elements {
            self[KeyRef(value: string, annotation: nil)] = value
        }
    }
    public convenience init(dictionaryLiteral elements: (KeyRef, Any)...) {
        self.init()
        for (keyref, value) in elements {
            self[keyref] = value
        }
    }
}

// MARK: Utilities
extension Object {
    public func string(for key: String) -> String? {
        return (self[key] as? StringValue)?.value
    }
    public func stringArray(for key: String) -> [String]? {
        return (self[key] as? ArrayValue)?.value.map { $0.value }
    }
    public func stringValue(for key: String) -> StringValue? {
        return self[key] as? StringValue
    }
    public func arrayValue(for key: String) -> ArrayValue? {
        return self[key] as? ArrayValue
    }
    public func object(for key: String) -> Object? {
        return self[key] as? Object
    }
}

// MARK: key (ID) retrieval
extension Object {
    public func keyref<T: Equatable>(for v: T) -> KeyRef? {
        let keyrefs = self.flatMap { ($1 as? T) == v ? $0 : nil }
        return keyrefs.first
    }
    public func key<T: Equatable>(for v: T) -> String? {
        return keyref(for: v)?.value
    }
}

// MARK: Type Conversion
extension Object {
    public var dictionary: [String: Any]  {
        var r = [String: Any]()
        for (keyref, value) in self {
            switch value {
            case let v as StringValue:
                r[keyref.value] = v.value
            case let v as ArrayValue:
                r[keyref.value] = v.value
            case let v as Object:
                r[keyref.value] = v.dictionary
            default:
                fatalError("Failed to convert Object to [String: Any]")
            }
        }
        return r
    }
}

// MARK: Value Validation
extension Object {
    func validateValueType(_ value: Any) -> Bool {
        switch value {
        case is StringValue: return true
        case is ArrayValue: return true
        case is Object: return true
        case is String: return true
        case is [String]: return true
        case is [String: Any]: return true
        default: return false
        }
    }
}

// MARK: AutoEquatable
extension Object: Equatable {}
public func == (lhs: Object, rhs: Object) -> Bool {
    guard lhs.keyrefs == rhs.keyrefs else { return false }
    guard equals(lhs.dict, rhs.dict) else { return false }
    return true
}
func equals(_ lhs: [KeyRef: Any], _ rhs: [KeyRef: Any]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (kl, ol) in lhs {
        guard let or = rhs[kl] else {
            return false
        }
        guard equals(ol, or) else {
            return false
        }
    }
    return true
}
func equals(_ lhs: Any, _ rhs: Any) -> Bool {
    switch lhs {
    case let l as Object:
        if let r = rhs as? Object {
            return l == r
        }
    case let l as StringValue:
        if let r = rhs as? StringValue {
            return l == r
        }
    case let l as ArrayValue:
        if let r = rhs as? ArrayValue {
            return l == r
        }
    default:
        break
    }
    return false
}
