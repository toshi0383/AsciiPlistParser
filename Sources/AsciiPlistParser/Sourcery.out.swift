// Generated using Sourcery 0.5.8 — https://github.com/krzysztofzablocki/Sourcery
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
// MARK: - KeyRef AutoEquatable
extension KeyRef: Equatable {} 
public func == (lhs: KeyRef, rhs: KeyRef) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard compareOptionals(lhs: lhs.annotation, rhs: rhs.annotation, compare: ==) else { return false }
    return true
}
// MARK: - Node AutoEquatable
extension Node: Equatable {} 
public func == (lhs: Node, rhs: Node) -> Bool {
    guard lhs.key == rhs.key else { return false }
    guard lhs.value == rhs.value else { return false }
    guard lhs.isNewLineNeeded == rhs.isNewLineNeeded else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// MARK: -
