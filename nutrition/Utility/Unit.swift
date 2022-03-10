import Foundation

enum Unit: String, Codable, CaseIterable {
    case none

    case gram = "Grams"
    case tablespoon = "Tablespoons"
    case egg = "Eggs"
    case slice = "Slices"
    case bar = "Bars"
    case whole = "Whole"
    case can = "Cans"
    case stick = "Sticks"
    case tablet = "Tablets"

    case inch
    case year
    case kilogram
    case centimeter
    case calorie
    case percentage
    case gramsPerLbm
    case liter
    case pound

    var singular: String {
        switch self {
        case .none: return ""

        case .gram: return "gram"
        case .tablespoon: return "tbsp"
        case .egg: return "egg"
        case .slice: return "slice"
        case .bar: return "bar"
        case .whole: return "whole"
        case .can: return "can"
        case .stick: return "stick"
        case .tablet: return "tablet"

        case .inch: return "in"
        case .year: return "yr"
        case .kilogram: return "kg"
        case .centimeter: return "cm"
        case .calorie: return "kcal"
        case .percentage: return "%"
        case .gramsPerLbm: return "g/lbm"
        case .liter: return "liter"
        case .pound: return "lb"
        }
    }

    var plural: String {
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
        case .tablet: return "tablets"

        case .inch: return "inches"
        case .year: return "yrs"
        case .kilogram: return "kgs"
        case .centimeter: return "cm"
        case .calorie: return "kcals"
        case .percentage: return "%"
        case .gramsPerLbm: return "g/lbm"
        case .liter: return "liters"
        case .pound: return "lbs"
        }
    }

    static func ingredientOptions() -> [Unit] {
        var options: [Unit] = []
        options.append(gram)
        options.append(tablespoon)
        options.append(egg)
        options.append(slice)
        options.append(bar)
        options.append(whole)
        options.append(can)
        options.append(stick)
        options.append(tablet)
        return options
    }
}
