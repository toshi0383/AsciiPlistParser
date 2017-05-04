import Foundation
import AsciiPlistParser

func pathForResource(at path: String) -> String {
    #if Xcode
        return Bundle.main.path(forResource: path, ofType: nil)!
    #else
        return path
    #endif
}
