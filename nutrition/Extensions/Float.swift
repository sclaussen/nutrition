import Foundation

extension Float: NVValueTypeProtocol {
    func round(_ places:Int = 1) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }

    func toStr(_ precision: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = precision
        return formatter.string(from: self as NSNumber)!
    }

    func singular() -> Bool {
        return self == 1.0
    }

    var displayName: String {
        return String(self)
    }

    public static var allCases: [Float] {
        return []
    }
}
