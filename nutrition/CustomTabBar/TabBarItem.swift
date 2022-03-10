import Foundation

enum TabBarItem: Hashable {
    case base
    case adjustments
    case meal
    case ingredients
    case profile

    var title: String {
        switch self {
        case .base: return "Base"
        case .adjustments: return "Adjustments"
        case .meal: return "Meal"
        case .ingredients: return "Ingredients"
        case .profile: return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .base: return "base"
        case .adjustments: return "adjustments"
        case .meal: return "meal"
        case .ingredients: return "ingredients"
        case .profile: return "profile"
        }
    }

    var color: Color {
        switch self {
        case .base: return Color.red
        case .adjustments: return Color.blue
        case .meal: return Color.green
        case .ingredients: return Color.orange
        case .profile: return Color.blue
        }
    }
}
