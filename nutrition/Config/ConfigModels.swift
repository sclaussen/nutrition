import Foundation

// Wire types mirroring the nutrition-config YAML (foods, ingredients,
// per-profile meals, RDA, supplements). These are decoded from YAML (via Yams
// at runtime, or the bundled fallback copy). They are the app's ONLY data
// source — there is no backward-compatible UserDefaults seed.
//
// Keys are kebab-case in YAML; CodingKeys map them to Swift camelCase.

struct ConfigData {
    var foods: [ConfigFood]
    var ingredients: [ConfigIngredient]
    var meals: [String: [ConfigMealRow]]        // profile slug -> meal rows
    var supplements: [String: [ConfigSupplement]] // profile slug -> supplements
    var rda: [String: ConfigRDA]                 // nutrient key (kebab) -> thresholds
}

struct ConfigFood: Codable, Equatable {
    var name: String
    var type: String
    var defaultAmount: Double
    var stepAmount: Double
    var consumptionUnit: String
    var consumptionGrams: Double
    var currentVariant: String?

    enum CodingKeys: String, CodingKey {
        case name, type
        case defaultAmount = "default-amount"
        case stepAmount = "step-amount"
        case consumptionUnit = "consumption-unit"
        case consumptionGrams = "consumption-grams"
        case currentVariant = "current-variant"
    }
}

struct ConfigPrice: Codable, Equatable {
    var totalCost: Double?
    var totalGrams: Double?

    enum CodingKeys: String, CodingKey {
        case totalCost = "total-cost"
        case totalGrams = "total-grams"
    }
}

struct ConfigIngredient: Codable, Equatable {
    var name: String
    var food: String
    var brand: String?
    var servingSize: Double?
    var consumptionUnit: String?
    var consumptionGrams: Double?
    var calories: Double?
    var fat: Double?
    var fiber: Double?
    var netCarbs: Double?
    var protein: Double?
    var price: ConfigPrice?
    var url: String?
    var verified: String?
    // Only non-zero micronutrients are listed; key is the kebab nutrient name
    // (e.g. "vitamin-d", "calcium"). Absent ⇒ 0.
    var nutrients: [String: Double]?

    enum CodingKeys: String, CodingKey {
        case name, food, brand, calories, fat, fiber, protein, price, url, verified, nutrients
        case servingSize = "serving-size"
        case consumptionUnit = "consumption-unit"
        case consumptionGrams = "consumption-grams"
        case netCarbs = "net-carbs"
    }
}

// A meal row is one of: ordinary {food, amount}; group {food, amount, member};
// composite {food, amount, composite:[...]}; or category placeholder
// {category, food-type}. Distinguished by which fields are present.
struct ConfigMealRow: Codable, Equatable {
    var food: String?
    var amount: Double?
    var member: String?
    var composite: [ConfigCompositePart]?
    var category: String?
    var foodType: String?

    enum CodingKeys: String, CodingKey {
        case food, amount, member, composite, category
        case foodType = "food-type"
    }
}

struct ConfigCompositePart: Codable, Equatable {
    var food: String
    var variant: String
    var amount: Double
}

struct ConfigSupplement: Codable, Equatable {
    var name: String
    var amount: Double
}

struct ConfigRDAThreshold: Codable, Equatable {
    var maxAge: Double   // YAML ".inf" decodes to Double.infinity
    var male: Double
    var female: Double

    enum CodingKeys: String, CodingKey {
        case maxAge = "max-age"
        case male, female
    }
}

struct ConfigRDA: Codable, Equatable {
    var unit: String
    var min: [ConfigRDAThreshold]
    var max: [ConfigRDAThreshold]
}
