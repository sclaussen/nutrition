import Foundation

enum Unit: String, Codable, CaseIterable {
    case none

    case bar = "Bars"
    case block = "Blocks"
    case can = "Cans"
    case egg = "Eggs"
    case gram = "Grams"
    case slice = "Slices"
    case stick = "Sticks"
    case tablespoon = "Tablespoons"
    case tablet = "Tablets"
    case whole = "Whole"

    case calorie
    case centimeter
    case gramsPerLbm
    case inch
    case kilogram
    case liter
    case percentage
    case pound
    case year

    var singular: String {
        switch self {
        case .none: return ""

        case .bar: return "bar"
        case .block: return "block"
        case .can: return "can"
        case .egg: return "egg"
        case .gram: return "gram"
        case .slice: return "slice"
        case .stick: return "stick"
        case .tablespoon: return "tbsp"
        case .tablet: return "tablet"
        case .whole: return "whole"

        case .calorie: return "kcal"
        case .centimeter: return "cm"
        case .gramsPerLbm: return "g/lbm"
        case .inch: return "in"
        case .kilogram: return "kg"
        case .liter: return "liter"
        case .percentage: return "%"
        case .pound: return "lb"
        case .year: return "yr"
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
        case .block: return "blocks"

        case .calorie: return "kcals"
        case .centimeter: return "cm"
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
        options.append(block)
        options.append(can)
        options.append(egg)
        options.append(gram)
        options.append(slice)
        options.append(stick)
        options.append(tablespoon)
        options.append(tablet)
        options.append(whole)
        return options
    }
}
