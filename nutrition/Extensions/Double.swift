import SwiftUI

extension Double {
    func round(_ places:Int = 1) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
