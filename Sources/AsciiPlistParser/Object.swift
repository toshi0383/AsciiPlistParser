import Foundation

enum Const {
    static let header = "// !$*UTF8*$!"
}

public struct Node {
    public var key: KeyRef
    public var value: Value
    public var isNewLineNeeded = true
    public init(key: KeyRef, value: Value, isNewLineNeeded: Bool) {
        self.key = key
        self.value = value
        self.isNewLineNeeded = isNewLineNeeded
    }
}

public struct KeyRef {
    public var id: String
    public var annotation: String?
    public init(id: String, annotation: String?) {
        self.id = id
        self.annotation = annotation
    }
}

public struct Value {
    public var value: Any // OrderedDictionary, String, Array<Any>
    public var annotation: String?
    public init(value: Any, annotation: String?) {
        self.value = value
        self.annotation = annotation
    }
}

// MARK: Hashable
extension KeyRef: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

// MARK: AutoEquatable
protocol AutoEquatable { }

extension KeyRef: AutoEquatable { }
extension Node: AutoEquatable { }

// MARK: Equatable
extension Value: Equatable { }

func equals(_ l: Any?, _ r: Any?) -> Bool {
    if l == nil && r == nil {
        return true
    }
    guard let l = l, let r = r else {
        return false
    }
    switch (l, r) {
    case (let l as [Value], let r as [Value]):
        return l == r
    case (let l as Node, let r as Node):
        return l == r
    case (let l as String, let r as String):
        return l == r
    default:
        return false
    }
}
 public func ==(l: Value, r: Value) -> Bool {
     guard equals(l.value, r.value) else { return false }
     guard l.annotation == r.annotation else { return false }
     return true
 }
 
