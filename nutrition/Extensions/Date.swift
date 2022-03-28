import Foundation
import SwiftUI

extension Date: Fmt, Singular, PickerType {
    func toStr(_ precision: Int = 0) -> String {
        return self.description
    }

    func singular() -> Bool {
        return true
    }

    var displayName: String {
        return self.description
    }

    public static var allCases: [Date] {
        return []
    }
}
