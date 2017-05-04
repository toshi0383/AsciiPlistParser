import Foundation
import AsciiPlistParser

func pathForResource(at path: String) -> String {
    #if Xcode
        return Bundle.main.path(forResource: path, ofType: nil)!
    #else
        return path
    #endif
}

extension Node {
    init(rawKey: String, rawValue: String) {
        self.key = KeyRef(id: rawKey, annotation: nil)
        self.value = Value(value: rawValue, annotation: nil)
    }
}
