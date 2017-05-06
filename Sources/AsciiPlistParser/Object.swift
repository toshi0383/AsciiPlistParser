import Foundation

enum Const {
    static let header = "// !$*UTF8*$!"
}

public struct KeyRef {
    public var id: String
    public var annotation: String?
    public init(id: String, annotation: String?) {
        self.id = id
        self.annotation = annotation
    }
}

public struct StringValue {
    public var value: String
    public var annotation: String?
    public init(value: String, annotation: String?) {
        self.value = value
        self.annotation = annotation
    }
}

public struct ArrayValue {
    public var value: [StringValue]
    public init(value: [StringValue]) {
        self.value = value
    }
}

// MARK: Collection
extension ArrayValue: Collection {
    public var startIndex: Int {
        return value.startIndex
    }
    public var endIndex: Int {
        return value.endIndex
    }
    public func index(after: Int) -> Int {
        return value.index(after: after)
    }
    public subscript(position: Int) -> StringValue {
        return value[position]
    }
}

extension ArrayValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: StringValue...) {
        self.value = elements
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
extension StringValue: AutoEquatable { }

func equals(_ l: Any?, _ r: Any?) -> Bool {
    if l == nil && r == nil {
        return true
    }
    guard let l = l, let r = r else {
        return false
    }
    switch (l, r) {
    case (let l as [StringValue], let r as [StringValue]):
        return l == r
    case (let l as String, let r as String):
        return l == r
    default:
        return false
    }
}
