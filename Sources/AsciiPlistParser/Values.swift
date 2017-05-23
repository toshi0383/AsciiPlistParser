import Foundation

enum Const {
    static let header = "// !$*UTF8*$!"
    static let noNewLineIsas = ["PBXBuildFile", "PBXFileReference"]
}

// MARK: Type Definition
public typealias KeyRef = StringValue
public enum StringValue {
    case quoted(value: String, annotation: String?)
    case raw(value: String, annotation: String?)
    public var value: String {
        switch self {
        case .quoted(let value, _): return value
        case .raw(let value, _): return value
        }
    }
    public var annotation: String? {
        switch self {
        case .quoted(_, let annotation): return annotation
        case .raw(_, let annotation): return annotation
        }
    }
    public init(value: String, annotation: String? = nil) {
        let characters = value.characters
        if characters.count > 1 && characters.first == "\"" && characters.last == "\"" {
            self = .quoted(value: String(characters.dropFirst().dropLast()), annotation: annotation)
        } else {
            self = .raw(value: value, annotation: annotation)
        }
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
    public init(stringLiteral value: String) {
        self.init(value: value, annotation: nil)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value: value, annotation: nil)
    }

    public init(unicodeScalarLiteral value: String) {
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

// MARK: Comparable
extension StringValue: Comparable { }
public func < (lhs: StringValue, rhs: StringValue) -> Bool {
    return lhs.value < rhs.value
}
