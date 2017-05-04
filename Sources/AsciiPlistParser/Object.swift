import Foundation

enum Const {
    static let header = "// !$*UTF8*$!"
}

public struct Object {
    public let key: KeyRef
    public let value: Value
    public func asDictionary() -> [String: Any] {
        switch value.value {
        case let v as [Object]:
            return [key.id: v.map { $0.asDictionary() }]
        default:
            return [key.id: value.value]
        }
    }
}

public struct KeyRef {
    public let id: String
    public let annotation: String?
}

public struct Value {
    public let value: Any // OrderedDictionary, String, Array<Any>
    public let annotation: String?
}

// MARK: Hashable
extension KeyRef: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

// MARK: Equatable
extension KeyRef: Equatable { }
public func ==(l: KeyRef, r: KeyRef) -> Bool {
    guard l.id == r.id else { return false }
    guard l.annotation == r.annotation else { return false }
    return true
}
