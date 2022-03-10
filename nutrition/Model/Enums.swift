import Foundation

enum Unit: String, Codable, CaseIterable {
    case Gram = "grams"
    case Tablespoon = "tbsp"
    case Egg = "eggs"
    case Slice = "slices"
    case Bar = "bars"
    case Fruit = "pieces"
    case Can = "can"
    case Stick = "sticks"
    case Tablets = "tablets"

    static func values() -> [String] {
        var values: [String] = []
        for unit in Unit.allCases {
            values.append(unit.rawValue)
        }
        return values
    }
}

enum Gender: String, Codable, CaseIterable {
    case Male = "🙍‍♂️ Male"
    case Female = "🙍‍♀️ Female"
    case Other = "🤖 Other"

    static func values() -> [String] {
        var values: [String] = []
        for unit in Gender.allCases {
            values.append(unit.rawValue)
        }
        return values
    }
}
