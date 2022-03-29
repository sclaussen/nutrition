import Foundation

extension Float: NVValueTypeProtocol {
    func round(_ places:Int = 0) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }

    func string(_ precision: Int = -1) -> String {
        if precision == -1 {
            return self.description
        }

        Formatter.number.minimumFractionDigits = 0
        Formatter.number.maximumFractionDigits = precision
        Formatter.number.roundingMode = .halfEven
        Formatter.number.numberStyle = .decimal
        return Formatter.number.string(for: self) ?? ""
    }

    func singular() -> Bool {
        return self.round(0) == 1.0
    }

    var displayName: String {
        return String(self)
    }

    public static var allCases: [Float] {
        return []
    }
}
