import Foundation

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
