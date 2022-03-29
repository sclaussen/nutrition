import Foundation
import SwiftUI

extension Date: NVValueTypeProtocol {
    func string(_ max: Int = -1) -> String {
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
