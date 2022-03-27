import Foundation

enum Gender: String, Codable, CaseIterable {
    case male = "🙍‍♂️ Male"
    case female = "🙍‍♀️ Female"

    static func values() -> [Gender] {
        var values: [Gender] = []
        for unit in Gender.allCases {
            values.append(unit)
        }
        return values
    }
}

extension Gender: Identifiable {
    var id: Self { self }
}
