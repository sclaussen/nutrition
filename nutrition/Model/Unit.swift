import Foundation

enum Unit: NVValueTypeProtocol {
    case none

    case bar
    case piece
    case can
    case egg
    case gram
    case slice
    case stick
    case tablespoon
    case whole

    case calorie
    case centimeter
    case dollar
    case gramsPerLbm
    case inch
    case kilogram
    case liter
    case percentage
    case pound
    case year

    var displayName: String {
        String(describing: self).capitalized
    }

    var singularForm: String {
        switch self {
        case .none: return ""

        case .bar: return "bar"
        case .piece: return "piece"
        case .can: return "can"
        case .egg: return "egg"
        case .gram: return "gram"
        case .slice: return "slice"
        case .stick: return "stick"
        case .tablespoon: return "tbsp"
        case .whole: return "whole"

        case .calorie: return "cal"
        case .centimeter: return "cm"
        case .dollar: return "$"
        case .gramsPerLbm: return "g/lbm"
        case .inch: return "in"
        case .kilogram: return "kg"
        case .liter: return "liter"
        case .percentage: return "%"
        case .pound: return "lb"
        case .year: return "yr"
        }
    }

    var pluralForm: String {
        switch self {

        case .none: return ""

        case .gram: return "grams"
        case .tablespoon: return "tbsps"
        case .egg: return "eggs"
        case .slice: return "slices"
        case .bar: return "bars"
        case .whole: return "whole"
        case .can: return "cans"
        case .stick: return "sticks"
        case .piece: return "pieces"

        case .calorie: return "cals"
        case .centimeter: return "cm"
        case .dollar: return "$"
        case .gramsPerLbm: return "g/lbm"
        case .inch: return "inches"
        case .kilogram: return "kgs"
        case .liter: return "liters"
        case .percentage: return "%"
        case .pound: return "lbs"
        case .year: return "yrs"
        }
    }

    static func ingredientOptions() -> [Unit] {
        var options: [Unit] = []
        options.append(bar)
        options.append(can)
        options.append(egg)
        options.append(gram)
        options.append(piece)
        options.append(slice)
        options.append(stick)
        options.append(tablespoon)
        options.append(whole)
        return options
    }

    func string(_ precision: Int) -> String {
        return self.displayName
    }

    func singular() -> Bool {
        return true
    }
}
