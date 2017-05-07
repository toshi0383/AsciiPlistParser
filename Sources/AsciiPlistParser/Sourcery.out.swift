// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - ArrayValue AutoEquatable
extension ArrayValue: Equatable {} 
public func == (lhs: ArrayValue, rhs: ArrayValue) -> Bool {
    guard lhs.value == rhs.value else { return false }
    return true
}
// MARK: - Object AutoEquatable
extension Object: Equatable {} 
public func == (lhs: Object, rhs: Object) -> Bool {
    guard lhs.keyrefs == rhs.keyrefs else { return false }
    guard lhs.dict == rhs.dict else { return false }
    return true
}
// MARK: - StringValue AutoEquatable
extension StringValue: Equatable {} 
public func == (lhs: StringValue, rhs: StringValue) -> Bool {
    guard lhs.value == rhs.value else { return false }
    guard compareOptionals(lhs: lhs.annotation, rhs: rhs.annotation, compare: ==) else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// MARK: -
