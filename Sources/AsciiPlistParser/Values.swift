import Foundation

enum Const {
    static let header = "// !$*UTF8*$!"
}

// MARK: Type Definition
public typealias KeyRef = StringValue

public final class StringValue {
    public var value: String
    public var annotation: String?
    public init(value: String, annotation: String?) {
        self.value = value
        self.annotation = annotation
    }
    public var nonQuotedValue: String {
        var chars: [Character] = []
        for (i, c) in value.characters.enumerated() {
            if (i == 0 || i == value.characters.count - 1) && c == "\"" {
            } else {
                chars.append(c)
            }
        }
        return String(chars)
    }
}

public final class ArrayValue {
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

// MARK: ExpressibleByArrayLiteral
extension ArrayValue: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: StringValue...) {
        self.init(value: [])
        self.value = elements
    }
}

// MARK: ExpressibleByStringLiteral
extension StringValue: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: String) {
        self.init(value: value, annotation: nil)
    }

    public convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(value: value, annotation: nil)
    }

    public convenience init(unicodeScalarLiteral value: String) {
        self.init(value: value, annotation: nil)
    }
}

// MARK: Hashable
extension KeyRef: Hashable {
    public var hashValue: Int {
        return value.hashValue
    }
}

// MARK: AutoEquatable
protocol AutoEquatable { }
extension StringValue: AutoEquatable { }
extension ArrayValue: AutoEquatable { }
