import Foundation

enum Const {
    static let header = "// !$*UTF8*$!"
}

public struct Object {
    public var key: KeyRef
    public var value: Value
}

public struct KeyRef {
    public var id: String
    public var annotation: String?
}

public struct Value {
    public var value: Any // OrderedDictionary, String, Array<Any>
    public var annotation: String?
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
