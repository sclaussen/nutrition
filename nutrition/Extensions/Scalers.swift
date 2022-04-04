import Foundation
import SwiftUI

extension Double: ValueType {
    func singular() -> Bool {
        return self.round(0) == 1.0
    }

    func formattedString(_ precision: Int = -1) -> String {
        if precision == -1 {
            return self.description
        }

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        formatter.roundingMode = .halfEven
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }

    func round(_ places:Int = 0) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    public static var allCases: [Double] {
        return []
    }
}

extension Int: ValueType {
    func formattedString(_ max: Int = -1) -> String {
        return self.description
    }

    func singular() -> Bool {
        return self == 1
    }

    var displayName: String {
        return String(self)
    }

    public static var allCases: [Int] {
        return []
    }
}

extension String: ValueType {
    func formattedString(_ max: Int = -1) -> String {
        return self
    }

    func singular() -> Bool {
        return true
    }

    public static var allCases: [String] {
        return []
    }
}

// extension Float: ValueType {
//     func round(_ places:Int = 0) -> Float {
//         let divisor = pow(10.0, Float(places))
//         return (self * divisor).rounded() / divisor
//     }

//     func string(_ precision: Int = -1) -> String {
//         if precision == -1 {
//             return self.description
//         }

//         Formatter.number.minimumFractionDigits = 0
//         Formatter.number.maximumFractionDigits = precision
//         Formatter.number.roundingMode = .halfEven
//         Formatter.number.numberStyle = .decimal
//         return Formatter.number.string(for: self) ?? ""
//     }

//     func singular() -> Bool {
//         return self.round(0) == 1.0
//     }

//     var displayName: String {
//         return String(self)
//     }

//     public static var allCases: [Float] {
//         return []
//     }
// }

extension Bool: ValueType {
    func formattedString(_ max: Int = -1) -> String {
        return self.description
    }

    func singular() -> Bool {
        return true
    }

    public static var allCases: [Bool] {
        return []
    }
}

extension Date: ValueType {
    func formattedString(_ max: Int = -1) -> String {
        return self.description
    }

    func singular() -> Bool {
        return true
    }

    public static var allCases: [Date] {
        return []
    }
}
