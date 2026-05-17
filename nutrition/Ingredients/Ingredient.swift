import Foundation


enum IngredientType: String, Codable, CaseIterable, Identifiable {
    case meat, supplement, nuts, produce, cheese, oils, proteins, carbs, fruit
    var id: String { rawValue }
    var label: String { rawValue.capitalized }
    var sortRank: Int {
        switch self {
        case .oils: return 0
        case .produce: return 1
        case .cheese: return 2
        case .nuts: return 3
        case .proteins: return 4
        case .carbs: return 5
        case .fruit: return 6
        case .meat: return 7
        case .supplement: return 8
        }
    }
}


class IngredientMgr: ObservableObject {


    @Published var ingredients: [Ingredient] = [] {
        didSet {
            serialize()
        }
    }


    init() {
        ingredients.append(Ingredient(name: "Coconut Oil",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Coconut Oil",
                                      servingSize: 14,
                                      calories: 120.0,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      verified: "12/25/23"))
        ingredients.append(Ingredient(name: "Avocado Oil",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Avocado Oil",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07q4yng8w",
                                      servingSize: 14,
                                      calories: 130,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Avocado Oil (Chosen Foods)",
                                      brand: "Chosen Foods",
                                      foodName: "Avocado Oil",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b00cyml9fw",
                                      totalCost: 14.99,
                                      totalGrams: 460,
                                      servingSize: 14,
                                      calories: 130,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Chicken",
                                      brand: "ButcherBox",
                                      servingSize: 100,
                                      calories: 115,
                                      fat: 2.7,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 22,
                                      vitaminB6: 0.7,
                                      vitaminB12: 0.4,
                                      selenium: 22,
                                      potassium: 256,
                                      phosphorus: 200,
                                      niacin: 10,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meatAmount: 300))
        ingredients.append(Ingredient(name: "Beef",
                                      brand: "ButcherBox",
                                      foodName: "Beef",
                                      servingSize: 100,
                                      calories: 214,
                                      fat: 15.2,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 19,
                                      zinc: 4.6,
                                      vitaminB12: 2.1,
                                      selenium: 17,
                                      potassium: 270,
                                      phosphorus: 180,
                                      niacin: 5.4,
                                      iron: 2.6,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meatAmount: 200))
        ingredients.append(Ingredient(name: "Bison",
                                      brand: "ButcherBox",
                                      servingSize: 112,
                                      calories: 160,
                                      fat: 8,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 23,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meatAmount: 150));
        ingredients.append(Ingredient(name: "Lamb",
                                      brand: "ButcherBox",
                                      servingSize: 85,
                                      calories: 253,
                                      fat: 22,
                                      fiber: 0,
                                      netCarbs: 0.19,
                                      protein: 13.09,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meatAmount: 150))
        ingredients.append(Ingredient(name: "Pork Chop",
                                      brand: "ButcherBox",
                                      servingSize: 113,
                                      calories: 220,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 30,
                                      vitaminB12: 0.8,
                                      thiamin: 0.8,
                                      selenium: 35,
                                      potassium: 350,
                                      phosphorus: 220,
                                      niacin: 6,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meatAmount: 300))
        ingredients.append(Ingredient(name: "Salmon",
                                      brand: "ButcherBox",
                                      foodName: "Salmon",
                                      servingSize: 112,
                                      calories: 150,
                                      fat: 5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 25,
                                      vitaminD: 12,
                                      vitaminB12: 3.4,
                                      selenium: 46,
                                      potassium: 420,
                                      phosphorus: 270,
                                      niacin: 8,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meatAmount: 300))
        ingredients.append(Ingredient(name: "Top Sirloin Cap",
                                      brand: "ButcherBox",
                                      servingSize: 238,
                                      calories: 125,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 51,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1))
        ingredients.append(Ingredient(name: "Eggs",
                                      brand: "Vital Farms",
                                      foodName: "Eggs",
                                      servingSize: 44.0,
                                      calories: 60.0,
                                      fat: 4.0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 6,
                                      vitaminD: 1, // mcg
                                      vitaminB12: 0.6,
                                      selenium: 15,
                                      riboflavin: 0.2,
                                      potassium: 70, // mg
                                      iron: 0.8, // mg
                                      folate: 24,
                                      calcium: 30, // mg
                                      consumptionUnit: Unit.egg,
                                      consumptionGrams: 50,
                                      verified: "12/25/23"))
        ingredients.append(Ingredient(name: "Arugula",
                                      brand: "365 by Whole Foods Market",
                                      servingSize: 142.0,
                                      calories: 45.0,
                                      fat: 1.0,
                                      fiber: 2.0,
                                      netCarbs: 3.0,
                                      protein: 4.0,
                                      vitaminK: 22,
                                      vitaminC: 3,
                                      vitaminA: 24,
                                      folate: 19,
                                      calcium: 32,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "No nutrition on whole foods site",
                                      stepAmount: 5))
        ingredients.append(Ingredient(name: "Spinach",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Spinach",
                                      servingSize: 30.0,
                                      calories: 7.0,
                                      fat: 0.12,
                                      fiber: 0.66,
                                      netCarbs: 0.44,
                                      protein: 0.86,
                                      vitaminK: 410,
                                      vitaminE: 1.7,
                                      vitaminC: 8.0,
                                      vitaminA: 141,
                                      potassium: 167.0,
                                      manganese: 0.8,
                                      magnesium: 67,
                                      iron: 0.81,
                                      folate: 165,
                                      calcium: 30.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      stepAmount: 5))
        ingredients.append(Ingredient(name: "Romaine",
                                      brand: "365 by Whole Foods Market",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07814bsw2",
                                      servingSize: 47,
                                      calories: 8,
                                      fat: 0.14,
                                      fiber: 0.99,
                                      netCarbs: 0.51,
                                      protein: 0.58,
                                      vitaminK: 48,
                                      vitaminC: 2,
                                      vitaminA: 205,
                                      potassium: 116,
                                      iron: 0.5,
                                      folate: 64,
                                      calcium: 16,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "3/16/22",
                                      stepAmount: 5))
        ingredients.append(Ingredient(name: "Broccoli",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Broccoli",
                                      servingSize: 85,
                                      calories: 25.0,
                                      fat: 0,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 3.0,
                                      vitaminK: 87,
                                      vitaminC: 58.0,
                                      vitaminA: 26,
                                      potassium: 269,
                                      manganese: 0.17,
                                      iron: 0.9,
                                      folate: 54,
                                      calcium: 30.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "9/1/22",
                                      stepAmount: 5))
        ingredients.append(Ingredient(name: "Cauliflower",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Cauliflower",
                                      servingSize: 85,
                                      calories: 20,
                                      fat: 0,
                                      fiber: 2,
                                      netCarbs: 2,
                                      protein: 2,
                                      vitaminK: 13,
                                      vitaminC: 41,
                                      vitaminB6: 0.16,
                                      potassium: 254,
                                      pantothenicAcid: 0.6,
                                      manganese: 0.13,
                                      folate: 48,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "9/1/22",
                                      stepAmount: 5))
        ingredients.append(Ingredient(name: "Mushrooms",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Mushrooms",
                                      servingSize: 84.0,
                                      calories: 18.0,
                                      fat: 0.29,
                                      fiber: 1.1,
                                      netCarbs: 2.2,
                                      protein: 1.77,
                                      selenium: 3.3,
                                      riboflavin: 0.14,
                                      potassium: 306.0,
                                      pantothenicAcid: 0.5,
                                      niacin: 1.3,
                                      copper: 0.1,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "9/1/22",
                                      stepAmount: 5))
        ingredients.append(Ingredient(name: "Radish",
                                      brand: "365 by Whole Foods Market",
                                      servingSize: 85.0,
                                      calories: 14.0,
                                      fat: 0.1,
                                      fiber: 1.4,
                                      netCarbs: 1.6,
                                      protein: 0.6,
                                      vitaminC: 12.0,
                                      potassium: 200.0,
                                      folate: 15,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "9/1/22",
                                      stepAmount: 5))
        // Avocado is a Food (group) with size variants. Values per
        // 50 g serving (= 0.25 fruit on the Whole Foods label).
        // Large = generic Whole Foods Hass; Medium = 365 Organic
        // 4-count ($4.99 / ~560 g edible across the 4 fruit).
        ingredients.append(Ingredient(name: "Avocado, Large",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Avocado",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000p72uzg",
                                      servingSize: 50,
                                      calories: 80,
                                      fat: 7,
                                      saturatedFat: 1.1,
                                      sodium: 3.5,
                                      carbohydrates: 4.3,
                                      fiber: 3.4,
                                      netCarbs: 0.9,
                                      protein: 1,
                                      vitaminK: 11,
                                      vitaminE: 1.1,
                                      vitaminC: 5,
                                      vitaminA: 73,
                                      potassium: 243,
                                      pantothenicAcid: 0.7,
                                      magnesium: 15,
                                      folate: 41,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 225))
        ingredients.append(Ingredient(name: "Avocado, Medium",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Avocado",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000nogkn4",
                                      totalCost: 4.99,
                                      totalGrams: 560,
                                      servingSize: 50,
                                      calories: 80,
                                      fat: 7,
                                      saturatedFat: 1.1,
                                      sodium: 3.5,
                                      carbohydrates: 4.3,
                                      fiber: 3.4,
                                      sugar: 0.33,
                                      netCarbs: 0.9,
                                      protein: 1,
                                      vitaminK: 11,
                                      vitaminE: 1.1,
                                      vitaminC: 10,
                                      vitaminA: 146,
                                      potassium: 243,
                                      pantothenicAcid: 0.7,
                                      magnesium: 15,
                                      iron: 0.55,
                                      folate: 41,
                                      calcium: 12,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 140))

        // USDA per 100 g.  Step 25 g — a typical handful is ~75–100 g.
        // Copper stored in mg (matches our convention — see
        // VitaminMineralActuals.swift, which converts to mcg).
        ingredients.append(Ingredient(name: "Blueberries",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Blueberries",
                                      servingSize: 148.0,
                                      calories: 84.0,
                                      fat: 0.49,
                                      fiber: 3.6,
                                      netCarbs: 17.4,
                                      protein: 1.1,
                                      vitaminK: 19.3,
                                      vitaminE: 0.57,
                                      vitaminC: 14.0,
                                      vitaminB6: 0.05,
                                      potassium: 114.0,
                                      manganese: 0.34,
                                      magnesium: 6,
                                      iron: 0.41,
                                      folate: 6,
                                      copper: 0.057,
                                      calcium: 8.88,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/11/2026",
                                      stepAmount: 25))

        ingredients.append(Ingredient(name: "Blackberries",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Blackberries",
                                      servingSize: 72.0,
                                      calories: 31.0,
                                      fat: 0.35,
                                      fiber: 3.8,
                                      netCarbs: 3.2,
                                      protein: 1.0,
                                      vitaminK: 19.8,
                                      vitaminE: 1.17,
                                      vitaminC: 15.0,
                                      vitaminA: 154.0,
                                      potassium: 117.0,
                                      niacin: 0.65,
                                      manganese: 0.65,
                                      magnesium: 20,
                                      iron: 0.45,
                                      folate: 25,
                                      copper: 0.165,
                                      calcium: 21.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/11/2026",
                                      stepAmount: 25))
        ingredients.append(Ingredient(name: "Sardines (H2O)",
                                      brand: "Wild Planet",
                                      foodName: "Sardines",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b013ork8p2",
                                      servingSize: 85,
                                      calories: 140,
                                      fat: 8,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 18,
                                      vitaminD: 4,
                                      vitaminB12: 7.5,
                                      selenium: 45,
                                      potassium: 340,
                                      phosphorus: 417,
                                      niacin: 4.4,
                                      calcium: 325,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      verified: "3/10/24"))
        ingredients.append(Ingredient(name: "Sardines (SB)",
                                      brand: "Wild Planet",
                                      foodName: "Sardines",
                                      servingSize: 85,
                                      calories: 190,
                                      fat: 12,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      vitaminD: 4,
                                      vitaminB12: 7.5,
                                      selenium: 45,
                                      potassium: 340,
                                      phosphorus: 417,
                                      niacin: 4.4,
                                      calcium: 325,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      verified: "3/10/24"))
        ingredients.append(Ingredient(name: "Sardines (LS)",
                                      brand: "Wild Planet",
                                      foodName: "Sardines",
                                      servingSize: 85,
                                      calories: 170,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 18,
                                      vitaminD: 4,
                                      vitaminB12: 7.5,
                                      selenium: 45,
                                      potassium: 340,
                                      phosphorus: 417,
                                      niacin: 4.4,
                                      calcium: 325,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      verified: "3/10/24"))
        ingredients.append(Ingredient(name: "Sardines (LS L)",
                                      brand: "Wild Planet",
                                      foodName: "Sardines",
                                      servingSize: 85,
                                      calories: 170,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 18,
                                      vitaminD: 4,
                                      vitaminB12: 7.5,
                                      selenium: 45,
                                      potassium: 340,
                                      phosphorus: 417,
                                      niacin: 4.4,
                                      calcium: 325,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      verified: "3/10/24"))
        ingredients.append(Ingredient(name: "Mackerel (Skinless Boneless)",
                                      brand: "Wild Planet",
                                      foodName: "Mackerel",
                                      servingSize: 85,
                                      calories: 180,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      vitaminD: 7,
                                      vitaminB12: 14,
                                      selenium: 38,
                                      potassium: 280,
                                      phosphorus: 230,
                                      niacin: 7,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      verified: "3/10/24"))
        ingredients.append(Ingredient(name: "Mackerel (Smoked)",
                                      brand: "Wild Planet",
                                      foodName: "Mackerel",
                                      servingSize: 75,
                                      calories: 140,
                                      fat: 6,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 22,
                                      vitaminD: 8,
                                      vitaminB12: 12,
                                      selenium: 32,
                                      phosphorus: 200,
                                      niacin: 6,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 75,
                                      verified: "3/10/24"))
        ingredients.append(Ingredient(name: "Tuna",
                                      brand: "Wild Planet",
                                      foodName: "Tuna",
                                      servingSize: 85,
                                      calories: 100,
                                      fat: 2.5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      vitaminD: 1.4,
                                      vitaminB12: 2.5,
                                      selenium: 76,
                                      potassium: 200,
                                      phosphorus: 170,
                                      niacin: 11,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Cashews",
                                      brand: "365 by Whole Foods Market",
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 13,
                                      fiber: 1,
                                      netCarbs: 8,
                                      protein: 5,
                                      zinc: 1.6,
                                      vitaminK: 9.5,
                                      thiamin: 0.1,
                                      selenium: 5.6,
                                      potassium: 187,
                                      phosphorus: 165,
                                      manganese: 0.5,
                                      magnesium: 80,
                                      iron: 1.9,
                                      copper: 0.6,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1))
        ingredients.append(Ingredient(name: "Macadamia Nuts",
                                      brand: "Aurora",
                                      servingSize: 30,
                                      calories: 220,
                                      fat: 23,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 2,
                                      thiamin: 0.3,
                                      manganese: 1.2,
                                      magnesium: 36,
                                      iron: 1,
                                      copper: 0.2,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Walnuts",
                                      brand: "Aurora",
                                      servingSize: 30.0,
                                      calories: 200.0,
                                      fat: 20.0,
                                      fiber: 2,
                                      netCarbs: 2,
                                      protein: 5.0,
                                      phosphorus: 98,
                                      manganese: 1,
                                      magnesium: 45,
                                      folate: 28,
                                      copper: 0.5,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1))
        ingredients.append(Ingredient(name: "Pistachios (Wonderful In-Shell 16 oz)",
                                      brand: "Wonderful",
                                      foodName: "Pistachios",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07h693qjg",
                                      totalCost: 10.49,
                                      totalGrams: 226,
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 13,
                                      saturatedFat: 1.5,
                                      sodium: 0,
                                      carbohydrates: 8,
                                      fiber: 3,
                                      sugar: 2,
                                      netCarbs: 5,
                                      protein: 6,
                                      vitaminB6: 0.5,
                                      vitaminA: 4,
                                      thiamin: 0.25,
                                      potassium: 290,
                                      phosphorus: 137,
                                      manganese: 0.34,
                                      magnesium: 34,
                                      iron: 1.1,
                                      copper: 0.36,
                                      calcium: 30,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/17/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Pistachios (Wonderful No-Shell 12 oz)",
                                      brand: "Wonderful",
                                      foodName: "Pistachios",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b00biz2nlu",
                                      totalCost: 9.49,
                                      totalGrams: 340.2,
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 13,
                                      saturatedFat: 1.5,
                                      sodium: 135,
                                      carbohydrates: 8,
                                      fiber: 3,
                                      sugar: 2,
                                      netCarbs: 5,
                                      protein: 6,
                                      vitaminB6: 0.5,
                                      vitaminA: 4,
                                      thiamin: 0.25,
                                      potassium: 290,
                                      phosphorus: 137,
                                      manganese: 0.34,
                                      magnesium: 34,
                                      iron: 1.1,
                                      copper: 0.36,
                                      calcium: 30,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/17/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Pecans",
                                      brand: "Aurora",
                                      foodName: "Pecans",
                                      servingSize: 28,
                                      calories: 210.0,
                                      fat: 22.0,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 3,
                                      zinc: 1.3,
                                      vitaminE: 0.4,
                                      thiamin: 0.2,
                                      manganese: 1.3,
                                      copper: 0.3,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1))
        ingredients.append(Ingredient(name: "Peanuts",
                                      brand: "365 by Whole Foods Market",
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 14,
                                      fiber: 2,
                                      netCarbs: 4,
                                      protein: 7,
                                      vitaminE: 2.4,
                                      phosphorus: 107,
                                      niacin: 3.4,
                                      manganese: 0.5,
                                      magnesium: 50,
                                      folate: 67,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Pumpkin Seeds",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Pumpkin Seeds",
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 14,
                                      fiber: 2,
                                      netCarbs: 1,
                                      protein: 8,
                                      zinc: 1.8, // mg
                                      selenium: 2.5,
                                      potassium: 230, // mg
                                      phosphorus: 348,
                                      manganese: 1.3,
                                      magnesium: 165, // mg
                                      iron: 2.5, // mg
                                      copper: 0.4,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "12/25/23"))
        ingredients.append(Ingredient(name: "Mustard",
                                      brand: "Organicville",
                                      foodName: "Mustard",
                                      servingSize: 5,
                                      calories: 5,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 15,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Extra Virgin Olive Oil",
                                      brand: "365 by Whole Foods Market",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b074y6wz8x",
                                      servingSize: 14,
                                      calories: 120,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      vitaminK: 8,
                                      vitaminE: 1.9,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Fish Oil",
                                      brand: "Carlson",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b001lf39ro",
                                      servingSize: 4.667,
                                      calories: 40,
                                      fat: 4.5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "String Cheese",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "String Cheese",
                                      servingSize: 28,
                                      calories: 80,
                                      fat: 6,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 7,
                                      zinc: 0.9,
                                      vitaminB12: 0.3,
                                      vitaminA: 80,
                                      phosphorus: 140,
                                      calcium: 0.0,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 28,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Dubliner Cheese",
                                      brand: "Kerrygold",
                                      foodName: "Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b001e96kuu",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 7,
                                      zinc: 1,
                                      vitaminB12: 0.3,
                                      vitaminA: 90,
                                      phosphorus: 150,
                                      calcium: 200,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Manchego Cheese",
                                      brand: "Mitica",
                                      foodName: "Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0787tnqqx",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 7,
                                      zinc: 1,
                                      vitaminB12: 0.4,
                                      vitaminA: 80,
                                      phosphorus: 150,
                                      calcium: 283.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/12/26"))
        ingredients.append(Ingredient(name: "Babybel Cheese",
                                      brand: "Mini Babybel",
                                      foodName: "Babybel Cheese",
                                      servingSize: 20.0,
                                      calories: 70,
                                      fat: 5.0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 4.0,
                                      zinc: 0.8,
                                      vitaminB12: 0.2,
                                      vitaminA: 60,
                                      phosphorus: 105,
                                      calcium: 150,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 21,
                                      verified: "12/22/23"))
        ingredients.append(Ingredient(name: "Tillamook Cheddar Cheese",
                                      brand: "Tillamook",
                                      foodName: "Cheese",
                                      servingSize: 21,
                                      calories: 90,
                                      fat: 7,
                                      fiber: 0,
                                      netCarbs: 1,
                                      protein: 5,
                                      zinc: 0.8,
                                      vitaminB12: 0.2,
                                      vitaminA: 70,
                                      phosphorus: 105,
                                      calcium: 150,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 21,
                                      verified: "12/25/23"))
        ingredients.append(Ingredient(name: "Emmi Roth",
                                      brand: "Emmi Roth",
                                      foodName: "Cheese",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 8,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Mitica",
                                      brand: "Mitica",
                                      foodName: "Cheese",
                                      servingSize: 28,
                                      calories: 100,
                                      fat: 8,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 7,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "1/8/24"))
        ingredients.append(Ingredient(name: "Cheddar Cheese",
                                      brand: "Tillamook",
                                      foodName: "Cheese",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 1,
                                      protein: 7,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 9.33,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Latte (Venti Iced)",
                                      brand: "Starbucks",
                                      servingSize: 1,
                                      calories: 180,
                                      fat: 6,
                                      fiber: 0,
                                      netCarbs: 18,
                                      protein: 12,
                                      vitaminD: 2.5,
                                      vitaminB12: 1.2,
                                      vitaminA: 75,
                                      riboflavin: 0.4,
                                      phosphorus: 250,
                                      calcium: 300,
                                      consumptionUnit: Unit.cup,
                                      consumptionGrams: 1,
                                      verified: "11/1/24"))
        ingredients.append(Ingredient(name: "Latte (Grande Hot)",
                                      brand: "Starbucks",
                                      servingSize: 1,
                                      calories: 190,
                                      fat: 7,
                                      fiber: 0,
                                      netCarbs: 19,
                                      protein: 13,
                                      vitaminD: 2.5,
                                      vitaminB12: 1.2,
                                      vitaminA: 75,
                                      riboflavin: 0.4,
                                      phosphorus: 250,
                                      calcium: 300,
                                      consumptionUnit: Unit.cup,
                                      consumptionGrams: 1,
                                      verified: "11/1/24"))
        ingredients.append(Ingredient(name: "Bacon, Gouda & Egg Sandwich",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Breakfast Sandwich",
                                      servingSize: 120,
                                      calories: 360,
                                      fat: 18,
                                      saturatedFat: 6,
                                      transFat: 0,
                                      cholesterol: 155,
                                      sodium: 710,
                                      carbohydrates: 35,
                                      fiber: 1,
                                      sugar: 2,
                                      netCarbs: 34,
                                      protein: 18,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 120,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Double-Smoked Bacon, Cheddar & Egg Sandwich",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Breakfast Sandwich",
                                      servingSize: 148,
                                      calories: 500,
                                      fat: 27,
                                      saturatedFat: 13,
                                      transFat: 0,
                                      cholesterol: 225,
                                      sodium: 960,
                                      carbohydrates: 43,
                                      fiber: 2,
                                      sugar: 8,
                                      netCarbs: 41,
                                      protein: 21,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 148,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Sausage, Cheddar & Egg Sandwich",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Breakfast Sandwich",
                                      servingSize: 157,
                                      calories: 480,
                                      fat: 29,
                                      saturatedFat: 10,
                                      transFat: 0,
                                      cholesterol: 165,
                                      sodium: 890,
                                      carbohydrates: 34,
                                      fiber: 1,
                                      sugar: 2,
                                      netCarbs: 33,
                                      protein: 18,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 157,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Turkey Bacon, Cheddar & Egg White Sandwich",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Breakfast Sandwich",
                                      servingSize: 142,
                                      calories: 260,
                                      fat: 9,
                                      saturatedFat: 3.5,
                                      transFat: 0,
                                      cholesterol: 25,
                                      sodium: 600,
                                      carbohydrates: 30,
                                      fiber: 2,
                                      sugar: 2,
                                      netCarbs: 28,
                                      protein: 17,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 142,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Bacon, Sausage & Egg Wrap",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Breakfast Sandwich",
                                      servingSize: 214,
                                      calories: 640,
                                      fat: 33,
                                      saturatedFat: 13,
                                      transFat: 0,
                                      cholesterol: 340,
                                      sodium: 1050,
                                      carbohydrates: 57,
                                      fiber: 2,
                                      sugar: 2,
                                      netCarbs: 55,
                                      protein: 27,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 214,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Spinach, Feta & Egg White Wrap",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Breakfast Sandwich",
                                      servingSize: 159,
                                      calories: 290,
                                      fat: 8,
                                      saturatedFat: 3.5,
                                      transFat: 0,
                                      cholesterol: 20,
                                      sodium: 840,
                                      carbohydrates: 34,
                                      fiber: 3,
                                      sugar: 5,
                                      netCarbs: 31,
                                      protein: 20,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 159,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Ham & Swiss on Baguette",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Sandwich",
                                      servingSize: 176,
                                      calories: 510,
                                      fat: 25,
                                      saturatedFat: 10,
                                      transFat: 0,
                                      cholesterol: 80,
                                      sodium: 1230,
                                      carbohydrates: 43,
                                      fiber: 2,
                                      sugar: 1,
                                      netCarbs: 41,
                                      protein: 25,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 176,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Tomato & Mozzarella on Focaccia",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Sandwich",
                                      servingSize: 153,
                                      calories: 360,
                                      fat: 12,
                                      saturatedFat: 4.5,
                                      transFat: 0,
                                      cholesterol: 20,
                                      sodium: 590,
                                      carbohydrates: 47,
                                      fiber: 1,
                                      sugar: 2,
                                      netCarbs: 46,
                                      protein: 15,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 153,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Cheese Trio Protein Box",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Protein Box",
                                      servingSize: 135,
                                      calories: 520,
                                      fat: 24,
                                      saturatedFat: 14,
                                      transFat: 1,
                                      cholesterol: 70,
                                      sodium: 710,
                                      carbohydrates: 59,
                                      fiber: 5,
                                      sugar: 40,
                                      netCarbs: 54,
                                      protein: 20,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 135,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Eggs & Cheddar Protein Box",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Protein Box",
                                      servingSize: 247,
                                      calories: 460,
                                      fat: 24,
                                      saturatedFat: 7,
                                      transFat: 0,
                                      cholesterol: 350,
                                      sodium: 450,
                                      carbohydrates: 40,
                                      fiber: 5,
                                      sugar: 21,
                                      netCarbs: 35,
                                      protein: 22,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 247,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Cheese & Fruit Protein Box",
                                      brand: "Starbucks",
                                      foodName: "Starbucks Protein Box",
                                      servingSize: 192,
                                      calories: 470,
                                      fat: 28,
                                      saturatedFat: 16,
                                      transFat: 1,
                                      cholesterol: 75,
                                      sodium: 770,
                                      carbohydrates: 37,
                                      fiber: 3,
                                      sugar: 17,
                                      netCarbs: 34,
                                      protein: 20,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 192,
                                      verified: "5/17/2026"))
        ingredients.append(Ingredient(name: "Peanut Butter",
                                      brand: "Once Again",
                                      foodName: "Peanut Butter",
                                      servingSize: 30,
                                      calories: 190,
                                      fat: 14,
                                      fiber: 2,
                                      netCarbs: 5,
                                      protein: 8,
                                      vitaminE: 2.5,
                                      phosphorus: 100,
                                      niacin: 4.3,
                                      manganese: 0.5,
                                      magnesium: 50,
                                      folate: 24,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 15,
                                      verified: "10/10/24"))
        ingredients.append(Ingredient(name: "Sunflower Butter",
                                      brand: "Once Again",
                                      foodName: "Sunflower Butter",
                                      servingSize: 30,
                                      calories: 210,
                                      fat: 19,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 5,
                                      vitaminE: 7.4,
                                      selenium: 22,
                                      phosphorus: 200,
                                      manganese: 0.6,
                                      magnesium: 110,
                                      copper: 0.5,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 15,
                                      verified: "10/10/24"))
        ingredients.append(Ingredient(name: "Jelly",
                                      brand: "Crofter's",
                                      foodName: "Jelly",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000uxyzi0",
                                      servingSize: 18,
                                      calories: 30,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 8,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 18,
                                      verified: "10/10/24"))
        ingredients.append(Ingredient(name: "Ezekiel 4:9",
                                      brand: "Food For Life",
                                      foodName: "Bread",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000rey4ni",
                                      servingSize: 34,
                                      calories: 80,
                                      fat: 0.5,
                                      fiber: 3,
                                      netCarbs: 12,
                                      protein: 5,
                                      thiamin: 0.1,
                                      phosphorus: 60,
                                      niacin: 1.2,
                                      manganese: 0.4,
                                      magnesium: 20,
                                      iron: 1.0,
                                      folate: 13,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 34,
                                      verified: "11/1/24"))
        ingredients.append(Ingredient(name: "Dave's Bread (Thin)",
                                      brand: "Dave's Killer Bread",
                                      foodName: "Bread",
                                      servingSize: 28,
                                      calories: 70,
                                      fat: 1,
                                      fiber: 2,
                                      netCarbs: 11,
                                      protein: 3,
                                      thiamin: 0.1,
                                      niacin: 1,
                                      magnesium: 15,
                                      iron: 0.7,
                                      folate: 8,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 28,
                                      verified: "11/1/24"))
        ingredients.append(Ingredient(name: "Dave's Bread",
                                      brand: "Dave's Killer Bread",
                                      foodName: "Bread",
                                      servingSize: 45,
                                      calories: 110,
                                      fat: 1.5,
                                      fiber: 5,
                                      netCarbs: 17,
                                      protein: 5,
                                      thiamin: 0.16,
                                      niacin: 1.6,
                                      magnesium: 25,
                                      iron: 1.1,
                                      folate: 13,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 45,
                                      verified: "11/1/24"))
        ingredients.append(Ingredient(name: "String Cheese W",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "String Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07fwc98xk",
                                      servingSize: 28,
                                      calories: 80,
                                      fat: 6,
                                      fiber: 0,
                                      netCarbs: 1,
                                      protein: 6,
                                      zinc: 0.9,
                                      vitaminB12: 0.3,
                                      vitaminA: 80,
                                      phosphorus: 140,
                                      calcium: 200,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 28,
                                      verified: "7/3/2025"))
        ingredients.append(Ingredient(name: "Dave's Bread W",
                                      brand: "Dave's Killer Bread",
                                      foodName: "Bread",
                                      servingSize: 45,
                                      calories: 110,
                                      fat: 1.5,
                                      fiber: 4,
                                      netCarbs: 18,
                                      protein: 6,
                                      thiamin: 0.16,
                                      niacin: 1.6,
                                      magnesium: 25,
                                      iron: 1.1,
                                      folate: 13,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 45,
                                      verified: "7/3/2025"))
        ingredients.append(Ingredient(name: "Turkey W",
                                      brand: "Applegate",
                                      foodName: "Turkey",
                                      servingSize: 56,
                                      calories: 60,
                                      fat: 1,
                                      fiber: 0,
                                      netCarbs: 1,
                                      protein: 10,
                                      zinc: 1.2,
                                      vitaminB6: 0.3,
                                      vitaminB12: 0.5,
                                      selenium: 14,
                                      phosphorus: 110,
                                      niacin: 3.6,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 28,
                                      verified: "7/3/2025"))
        ingredients.append(Ingredient(name: "Cheddar Cheese W",
                                      brand: "Tillamook",
                                      foodName: "Cheese",
                                      servingSize: 21,
                                      calories: 90,
                                      fat: 7,
                                      fiber: 0,
                                      netCarbs: 1,
                                      protein: 5,
                                      zinc: 0.8,
                                      vitaminB12: 0.2,
                                      vitaminA: 70,
                                      phosphorus: 105,
                                      calcium: 150,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 21,
                                      verified: "7/3/2025"))


        // ----- Supplements -----
        // Each is Unit.piece with servingSize 1 so a meal-ingredient
        // amount of N pieces yields N servings (and N times the V&M
        // values below).  Macros are 0.

        ingredients.append(Ingredient(name: "Vitamin D3 (1000 IU)",
                                      brand: "Thorne",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0797h3vqs",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      vitaminD: 25,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 1,
                                      verified: "5/10/2026"))

        // SlowMag — magnesium chloride + calcium, taken with the meal.
        // Per-tablet values (manufacturer label, 2-tablet serving / 2):
        //   magnesium 71.5 mg, calcium 119 mg, chloride 208 mg.
        // Chloride isn't tracked by the V&M page so it's omitted.
        ingredients.append(Ingredient(name: "SlowMag",
                                      brand: "SlowMag",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      magnesium: 71.5,
                                      calcium: 119,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 1,
                                      verified: "5/10/2026"))

        // Thorne Basic Nutrients 2/Day — comprehensive iron-free
        // multivitamin. Daily dose is 2 capsules; per-capsule values
        // below are the manufacturer's 2-capsule label / 2 so seed
        // amount = 2 reproduces the label total. Fields not tracked
        // by the V&M page (biotin, iodine, chromium, molybdenum,
        // boron, choline, inositol) are omitted.
        ingredients.append(Ingredient(name: "Thorne Basic Nutrients 2/Day",
                                      brand: "Thorne",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0fr5qmd5y",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      zinc: 7.5,
                                      vitaminK: 500,
                                      vitaminE: 33.5,
                                      vitaminD: 12.5,
                                      vitaminC: 125,
                                      vitaminB6: 5,
                                      vitaminB12: 300,
                                      vitaminA: 750,
                                      thiamin: 12.5,
                                      selenium: 50,
                                      riboflavin: 4.5,
                                      pantothenicAcid: 22.5,
                                      niacin: 40,
                                      manganese: 1.5,
                                      magnesium: 100,
                                      folate: 500,
                                      copper: 0.5,
                                      calcium: 50,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 1,
                                      verified: "5/13/2026"))

        // Non-V&M supplements — tracked for record-keeping only; none
        // contributes to any vitamin/mineral the V&M page reports.
        // consumptionGrams reflects the per-capsule/per-dose mass so
        // total grams in the day can be calculated correctly elsewhere.

        ingredients.append(Ingredient(name: "Creatine HCl",
                                      brand: "CON-CRET",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0bkcvlygx",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 0.75,  // ~750 mg per capsule (CON-CRET HCl)
                                      verified: "5/10/2026"))

        ingredients.append(Ingredient(name: "Taurine",
                                      brand: "Thorne",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 1,     // 1000 mg dose
                                      verified: "5/10/2026"))

        ingredients.append(Ingredient(name: "Glycine",
                                      brand: "Thorne",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000vyrroc",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 3,     // 3 g dose
                                      verified: "5/10/2026"))

        ingredients.append(Ingredient(name: "L-Theanine",
                                      brand: "Thorne",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 0.2,   // 200 mg dose
                                      verified: "5/10/2026"))

        ingredients.append(Ingredient(name: "Apigenin",
                                      brand: "Double Wood",
                                      servingSize: 1,
                                      calories: 0,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.pill,
                                      consumptionGrams: 0.05,  // 50 mg dose
                                      verified: "5/10/2026"))
        ingredients.append(Ingredient(name: "Arugula (365 by Whole Foods M 5 OZ)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Arugula",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b09zhx8y9v",
                                      totalCost: 3.99,
                                      totalGrams: 141.8,
                                      servingSize: 20.0,
                                      calories: 5.0,
                                      fat: 0.13,
                                      sodium: 5.0,
                                      carbohydrates: 0.7,
                                      fiber: 0.3,
                                      sugar: 0.4,
                                      netCarbs: 0.4,
                                      protein: 0.5,
                                      vitaminK: 21.0,
                                      vitaminC: 3.0,
                                      vitaminA: 24.0,
                                      potassium: 74.0,
                                      calcium: 32.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 20))
        ingredients.append(Ingredient(name: "Cauliflower (365 by Whole Foods M 16 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Cauliflower",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0812kzpj4",
                                      totalCost: 2.99,
                                      totalGrams: 476.3,
                                      servingSize: 85.0,
                                      calories: 20.0,
                                      fat: 0.0,
                                      sodium: 20.0,
                                      carbohydrates: 4.0,
                                      fiber: 2.0,
                                      sugar: 2.0,
                                      netCarbs: 2.0,
                                      protein: 2.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Eggs (Vital Farms 6 Ct)",
                                      brand: "Vital Farms",
                                      foodName: "Eggs",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0c4g8b5kz",
                                      totalCost: 7.99,
                                      servingSize: 44.0,
                                      calories: 60.0,
                                      fat: 4.0,
                                      saturatedFat: 1.5,
                                      sodium: 60.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 6.0,
                                      iron: 0.8,
                                      calcium: 30.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 44))
        ingredients.append(Ingredient(name: "String Cheese (365 by Whole Foods M 12 OZ)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "String Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07fwc98xk",
                                      totalCost: 4.99,
                                      totalGrams: 340.2,
                                      servingSize: 28.0,
                                      calories: 80.0,
                                      fat: 6.0,
                                      saturatedFat: 3.5,
                                      sodium: 200.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 7.0,
                                      iron: 0.0,
                                      calcium: 0.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Tuna (Wild Planet 5 Ounce)",
                                      brand: "Wild Planet",
                                      foodName: "Tuna",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b013orjqwi",
                                      totalCost: 6.29,
                                      totalGrams: 141.8,
                                      servingSize: 85.0,
                                      calories: 100.0,
                                      fat: 2.5,
                                      saturatedFat: 1.0,
                                      sodium: 85.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 21.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Pumpkin Seeds (365 by Whole Foods M 8 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Pumpkin Seeds",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07gl6jlzy",
                                      totalCost: 5.89,
                                      totalGrams: 226.8,
                                      servingSize: 28.0,
                                      calories: 160.0,
                                      fat: 14.0,
                                      saturatedFat: 2.5,
                                      carbohydrates: 3.0,
                                      fiber: 2.0,
                                      netCarbs: 1.0,
                                      protein: 8.0,
                                      vitaminD: 0.0,
                                      iron: 2.5,
                                      calcium: 0.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Blueberries (Whole Foods Market)",
                                      brand: "Whole Foods Market",
                                      foodName: "Blueberries",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b077n7tr5g",
                                      totalCost: 5.54,
                                      servingSize: 148.0,
                                      calories: 84.0,
                                      fat: 0.49,
                                      saturatedFat: 0.04,
                                      sodium: 1.5,
                                      carbohydrates: 21.0,
                                      fiber: 3.6,
                                      sugar: 14.74,
                                      netCarbs: 17.4,
                                      protein: 1.1,
                                      vitaminC: 14.0,
                                      vitaminA: 80.0,
                                      potassium: 114.0,
                                      iron: 0.41,
                                      calcium: 8.88,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 148))
        ingredients.append(Ingredient(name: "Mustard (Organicville 12 oz)",
                                      brand: "Organicville",
                                      foodName: "Mustard",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b00mfnax52",
                                      totalCost: 5.29,
                                      totalGrams: 340.2,
                                      servingSize: 5.0,
                                      calories: 5.0,
                                      fat: 0.0,
                                      sodium: 55.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 0.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 5))
        ingredients.append(Ingredient(name: "Pecans (Aurora 14 Ounce)",
                                      brand: "Aurora",
                                      foodName: "Pecans",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b079vrdfcw",
                                      totalCost: 11.49,
                                      totalGrams: 396.9,
                                      servingSize: 28.0,
                                      calories: 210.0,
                                      fat: 22.0,
                                      saturatedFat: 2.0,
                                      carbohydrates: 4.0,
                                      fiber: 3.0,
                                      sugar: 1.0,
                                      netCarbs: 1.0,
                                      protein: 3.0,
                                      vitaminD: 0.0,
                                      iron: 0.72,
                                      calcium: 26.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Walnuts (Aurora 7 oz)",
                                      brand: "Aurora",
                                      foodName: "Walnuts",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07812j5z2",
                                      totalCost: 9.99,
                                      totalGrams: 198.5,
                                      servingSize: 30.0,
                                      calories: 200.0,
                                      fat: 20.0,
                                      saturatedFat: 2.0,
                                      carbohydrates: 4.0,
                                      fiber: 2.0,
                                      sugar: 1.0,
                                      netCarbs: 2.0,
                                      protein: 5.0,
                                      vitaminD: 0.0,
                                      iron: 1.08,
                                      calcium: 26.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 30))
        ingredients.append(Ingredient(name: "Macadamia Nuts (Aurora 6 OZ)",
                                      brand: "Aurora",
                                      foodName: "Macadamia Nuts",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07xvyq5rh",
                                      totalCost: 12.49,
                                      totalGrams: 170.1,
                                      servingSize: 30.0,
                                      calories: 220.0,
                                      fat: 23.0,
                                      saturatedFat: 3.5,
                                      carbohydrates: 4.0,
                                      fiber: 3.0,
                                      sugar: 1.0,
                                      netCarbs: 1.0,
                                      protein: 2.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 30))
        ingredients.append(Ingredient(name: "Spinach (365 by Whole Foods M 5 oz)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Spinach",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0bfg3bhnh",
                                      totalCost: 3.99,
                                      totalGrams: 141.8,
                                      servingSize: 85.0,
                                      calories: 20.0,
                                      fat: 0.3,
                                      sodium: 65.0,
                                      carbohydrates: 3.0,
                                      fiber: 2.0,
                                      sugar: 0.3,
                                      netCarbs: 1.0,
                                      protein: 2.4,
                                      vitaminK: 400.0,
                                      vitaminC: 24.0,
                                      vitaminA: 400.0,
                                      potassium: 470.0,
                                      iron: 2.3,
                                      calcium: 85.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Beef (365 by Whole Foods M 365 G)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Beef",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0cbcx4thf",
                                      totalCost: 8.49,
                                      totalGrams: 453.6,
                                      servingSize: 113.0,
                                      calories: 290.0,
                                      fat: 23.0,
                                      saturatedFat: 9.0,
                                      sodium: 75.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 19.0,
                                      iron: 2.2,
                                      calcium: 0.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 113))
        ingredients.append(Ingredient(name: "Beef (ButcherBox)",
                                      brand: "ButcherBox",
                                      foodName: "Beef",
                                      totalCost: 9.50,
                                      totalGrams: 453.6,
                                      servingSize: 113,
                                      calories: 240,
                                      fat: 17,
                                      saturatedFat: 7,
                                      sodium: 75,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 22,
                                      zinc: 5.3,
                                      vitaminB12: 2.4,
                                      selenium: 18,
                                      iron: 2.3,
                                      calcium: 0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/17/2026",
                                      stepAmount: 5,
                                      defaultAmount: 113))
        ingredients.append(Ingredient(name: "Manchego (Corcuera)",
                                      brand: "Corcuera",
                                      foodName: "Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0787tnqqx",
                                      totalCost: 17.79,
                                      servingSize: 28.0,
                                      calories: 110.0,
                                      fat: 9.0,
                                      saturatedFat: 7.0,
                                      sodium: 160.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 7.0,
                                      iron: 0.0,
                                      calcium: 283.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Radish (Whole Foods Market)",
                                      brand: "Whole Foods Market",
                                      foodName: "Radish",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000rh1nf2",
                                      totalCost: 2.79,
                                      servingSize: 85.0,
                                      calories: 14.0,
                                      fat: 0.1,
                                      sodium: 33.0,
                                      carbohydrates: 3.0,
                                      fiber: 1.4,
                                      sugar: 1.6,
                                      netCarbs: 1.6,
                                      protein: 0.6,
                                      vitaminC: 12.0,
                                      potassium: 200.0,
                                      calcium: 21.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Spinach (365 by Whole Foods M 5 OZ)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Spinach",
                                      totalCost: 3.99,
                                      totalGrams: 141.8,
                                      servingSize: 85.0,
                                      calories: 20.0,
                                      fat: 0.3,
                                      sodium: 65.0,
                                      carbohydrates: 3.0,
                                      fiber: 2.0,
                                      sugar: 0.3,
                                      netCarbs: 1.0,
                                      protein: 2.4,
                                      vitaminK: 400.0,
                                      vitaminC: 24.0,
                                      vitaminA: 394.0,
                                      potassium: 470.0,
                                      iron: 2.3,
                                      calcium: 85.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Peanut Butter (Once Again)",
                                      brand: "Once Again",
                                      foodName: "Peanut Butter",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0085efmyw",
                                      totalCost: 8.99,
                                      servingSize: 30.0,
                                      calories: 190.0,
                                      fat: 14.0,
                                      saturatedFat: 2.0,
                                      carbohydrates: 7.0,
                                      fiber: 2.0,
                                      sugar: 2.0,
                                      netCarbs: 5.0,
                                      protein: 8.0,
                                      vitaminD: 0.0,
                                      iron: 0.0,
                                      calcium: 26.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 30))
        ingredients.append(Ingredient(name: "Avocado (Whole Foods Market 6 Count)",
                                      brand: "Whole Foods Market",
                                      foodName: "Avocado",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b09xxv8h97",
                                      totalCost: 3.49,
                                      servingSize: 50.0,
                                      calories: 80.0,
                                      fat: 7.0,
                                      saturatedFat: 1.1,
                                      sodium: 3.5,
                                      carbohydrates: 4.3,
                                      fiber: 3.4,
                                      sugar: 0.33,
                                      netCarbs: 0.9,
                                      protein: 1.0,
                                      vitaminC: 5.0,
                                      vitaminA: 73.0,
                                      potassium: 243.0,
                                      iron: 0.28,
                                      calcium: 6.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 50))
        ingredients.append(Ingredient(name: "Coconut Oil (365 by Whole Foods M 14 Fl Oz)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Coconut Oil",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b074h5bv9y",
                                      totalCost: 6.49,
                                      servingSize: 14.0,
                                      calories: 120.0,
                                      fat: 14.0,
                                      saturatedFat: 13.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 0.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 14))
        ingredients.append(Ingredient(name: "String Cheese (365 by Whole Foods M 8 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "String Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b09vq5dk7v",
                                      totalCost: 6.99,
                                      totalGrams: 226.8,
                                      servingSize: 28.0,
                                      calories: 80.0,
                                      fat: 6.0,
                                      saturatedFat: 3.5,
                                      sodium: 210.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 7.0,
                                      iron: 0.0,
                                      calcium: 15.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Babybel Cheese (Babybel 12 Count)",
                                      brand: "Babybel",
                                      foodName: "Babybel Cheese",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0bvgj2vvp",
                                      totalCost: 11.29,
                                      servingSize: 20.0,
                                      calories: 70.0,
                                      fat: 5.0,
                                      saturatedFat: 3.5,
                                      sodium: 150.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 4.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 20))
        ingredients.append(Ingredient(name: "Avocado (365 by Whole Foods M 4 Count)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Avocado",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07fycb4wx",
                                      totalCost: 5.54,
                                      servingSize: 50.0,
                                      calories: 80.0,
                                      fat: 7.0,
                                      saturatedFat: 1.1,
                                      sodium: 3.5,
                                      carbohydrates: 4.3,
                                      fiber: 3.4,
                                      sugar: 0.33,
                                      netCarbs: 0.9,
                                      protein: 1.0,
                                      vitaminC: 10.0,
                                      vitaminA: 146.0,
                                      potassium: 243.0,
                                      iron: 0.55,
                                      calcium: 12.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 50))
        ingredients.append(Ingredient(name: "Broccoli (365 by Whole Foods M 32 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Broccoli",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b079jt8zzf",
                                      totalCost: 5.99,
                                      servingSize: 85.0,
                                      calories: 25.0,
                                      fat: 0.0,
                                      sodium: 15.0,
                                      carbohydrates: 4.0,
                                      fiber: 3.0,
                                      sugar: 1.0,
                                      netCarbs: 1.0,
                                      protein: 3.0,
                                      vitaminC: 58.0,
                                      iron: 0.9,
                                      calcium: 30.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Eggs (Vital Farms 12 Count)",
                                      brand: "Vital Farms",
                                      foodName: "Eggs",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b00m1qwodw",
                                      totalCost: 8.49,
                                      servingSize: 50.0,
                                      calories: 70.0,
                                      fat: 5.0,
                                      saturatedFat: 1.5,
                                      sodium: 70.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 6.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 50))
        ingredients.append(Ingredient(name: "Eggs (365 by Whole Foods M 18 Count)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Eggs",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b074h6ypbj",
                                      totalCost: 6.29,
                                      servingSize: 50.0,
                                      calories: 70.0,
                                      fat: 5.0,
                                      saturatedFat: 1.5,
                                      sodium: 70.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 6.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 50))
        ingredients.append(Ingredient(name: "Radish (Whole Foods Market 12 Oz)",
                                      brand: "Whole Foods Market",
                                      foodName: "Radish",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b079vlpq2l",
                                      totalCost: 3.99,
                                      totalGrams: 340.2,
                                      servingSize: 85.0,
                                      calories: 14.0,
                                      fat: 0.1,
                                      sodium: 33.0,
                                      carbohydrates: 3.0,
                                      fiber: 1.4,
                                      sugar: 1.6,
                                      netCarbs: 1.6,
                                      protein: 0.6,
                                      vitaminC: 12.0,
                                      potassium: 200.0,
                                      calcium: 21.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Arugula (Earthbound Farm 4 OZ)",
                                      brand: "Earthbound Farm",
                                      foodName: "Arugula",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0d2ydtph6",
                                      totalCost: 3.49,
                                      totalGrams: 113.4,
                                      servingSize: 142.0,
                                      calories: 45.0,
                                      fat: 1.0,
                                      sodium: 40.0,
                                      carbohydrates: 5.0,
                                      fiber: 2.0,
                                      sugar: 3.0,
                                      netCarbs: 3.0,
                                      protein: 4.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 142))
        ingredients.append(Ingredient(name: "Bread (Food for Life 24 OZ)",
                                      brand: "Food for Life",
                                      foodName: "Bread",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000rey4ni",
                                      totalCost: 7.99,
                                      totalGrams: 680.4,
                                      servingSize: 34.0,
                                      calories: 80.0,
                                      fat: 0.5,
                                      carbohydrates: 15.0,
                                      fiber: 3.0,
                                      netCarbs: 12.0,
                                      protein: 5.0,
                                      iron: 1.0,
                                      calcium: 9.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 34))
        ingredients.append(Ingredient(name: "Arugula (organicgirl 5 Oz)",
                                      brand: "organicgirl",
                                      foodName: "Arugula",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b00jxr8ryw",
                                      totalCost: 4.49,
                                      totalGrams: 141.8,
                                      servingSize: 85.0,
                                      calories: 21.0,
                                      fat: 0.55,
                                      saturatedFat: 0.07,
                                      sodium: 23.0,
                                      carbohydrates: 3.1,
                                      fiber: 1.4,
                                      sugar: 1.8,
                                      netCarbs: 1.7,
                                      protein: 2.2,
                                      vitaminK: 90.0,
                                      vitaminC: 13.0,
                                      vitaminA: 100.0,
                                      potassium: 312.0,
                                      iron: 1.2,
                                      calcium: 136.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Macadamia Nuts (Whole Foods Market)",
                                      brand: "Whole Foods Market",
                                      foodName: "Macadamia Nuts",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07t471m4j",
                                      servingSize: 30.0,
                                      calories: 220.0,
                                      fat: 23.0,
                                      saturatedFat: 3.5,
                                      carbohydrates: 4.0,
                                      fiber: 2.5,
                                      sugar: 1.0,
                                      netCarbs: 1.5,
                                      protein: 2.0,
                                      iron: 1.1,
                                      calcium: 24.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 30))
        ingredients.append(Ingredient(name: "Pecans (365 by Whole Foods M 12 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Pecans",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b074vcsh7k",
                                      totalCost: 11.79,
                                      totalGrams: 340.2,
                                      servingSize: 28.0,
                                      calories: 190.0,
                                      fat: 20.0,
                                      saturatedFat: 2.0,
                                      carbohydrates: 4.0,
                                      fiber: 3.0,
                                      sugar: 1.0,
                                      netCarbs: 1.0,
                                      protein: 3.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 28))
        ingredients.append(Ingredient(name: "Mushrooms (365 by Whole Foods M 8 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Mushrooms",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07d9q1vh3",
                                      totalCost: 3.79,
                                      totalGrams: 226.8,
                                      servingSize: 84.0,
                                      calories: 18.0,
                                      fat: 0.29,
                                      saturatedFat: 0.05,
                                      sodium: 8.0,
                                      carbohydrates: 3.3,
                                      fiber: 1.1,
                                      sugar: 2.1,
                                      netCarbs: 2.2,
                                      protein: 1.77,
                                      vitaminC: 0.0,
                                      vitaminA: 0.0,
                                      potassium: 306.0,
                                      iron: 0.26,
                                      calcium: 2.52,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 84))
        ingredients.append(Ingredient(name: "Cauliflower (365 by Whole Foods M 12 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Cauliflower",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b077l7s52w",
                                      totalCost: 2.99,
                                      servingSize: 100.0,
                                      calories: 27.0,
                                      fat: 0.3,
                                      saturatedFat: 0.14,
                                      sodium: 32.0,
                                      carbohydrates: 5.3,
                                      fiber: 2.1,
                                      sugar: 2.0,
                                      netCarbs: 3.2,
                                      protein: 2.0,
                                      vitaminD: 0.0,
                                      vitaminC: 51.6,
                                      vitaminA: 0.0,
                                      iron: 0.45,
                                      calcium: 23.5,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 100))
        ingredients.append(Ingredient(name: "Macadamia Nuts (Aurora 8 oz)",
                                      brand: "Aurora",
                                      foodName: "Macadamia Nuts",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b002hqnkvq",
                                      totalCost: 14.99,
                                      totalGrams: 226.8,
                                      servingSize: 30.0,
                                      calories: 220.0,
                                      fat: 23.0,
                                      saturatedFat: 3.5,
                                      carbohydrates: 4.0,
                                      fiber: 3.0,
                                      sugar: 1.0,
                                      netCarbs: 1.0,
                                      protein: 2.0,
                                      vitaminD: 0.0,
                                      iron: 1.08,
                                      calcium: 26.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 30))
        ingredients.append(Ingredient(name: "Salmon (Whole Foods Market)",
                                      brand: "Whole Foods Market",
                                      foodName: "Salmon",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b09y5w11j1",
                                      totalCost: 18.99,
                                      servingSize: 113.0,
                                      calories: 230.0,
                                      fat: 14.0,
                                      saturatedFat: 3.0,
                                      sodium: 60.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 25.0,
                                      vitaminD: 13.0,
                                      potassium: 430.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 113))
        ingredients.append(Ingredient(name: "Chicken (Mary's Chicken)",
                                      brand: "Mary's Chicken",
                                      foodName: "Chicken",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0787z9hfs",
                                      totalCost: 4.99,
                                      servingSize: 112.0,
                                      calories: 170.0,
                                      fat: 9.0,
                                      saturatedFat: 2.5,
                                      sodium: 95.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 21.0,
                                      potassium: 230.0,
                                      iron: 1.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 112))
        ingredients.append(Ingredient(name: "Sunflower Butter (Once Again)",
                                      brand: "Once Again",
                                      foodName: "Sunflower Butter",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b008k4htn4",
                                      totalCost: 10.49,
                                      servingSize: 30.0,
                                      calories: 210.0,
                                      fat: 19.0,
                                      saturatedFat: 2.0,
                                      carbohydrates: 4.0,
                                      fiber: 3.0,
                                      sugar: 1.0,
                                      netCarbs: 1.0,
                                      protein: 5.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 30))
        ingredients.append(Ingredient(name: "Tuna (Wild Planet 5 Oz)",
                                      brand: "Wild Planet",
                                      foodName: "Tuna",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b00cq7puim",
                                      totalCost: 6.29,
                                      totalGrams: 68.0,
                                      servingSize: 85.0,
                                      calories: 100.0,
                                      fat: 2.5,
                                      saturatedFat: 1.0,
                                      sodium: 200.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 21.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 85))
        ingredients.append(Ingredient(name: "Eggs (Vital Farms 18 Count)",
                                      brand: "Vital Farms",
                                      foodName: "Eggs",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b089c8jt7b",
                                      totalCost: 14.79,
                                      servingSize: 50.0,
                                      calories: 70.0,
                                      fat: 5.0,
                                      saturatedFat: 1.5,
                                      sodium: 70.0,
                                      fiber: 0.0,
                                      netCarbs: 0.0,
                                      protein: 6.0,
                                      vitaminD: 1.0,
                                      vitaminA: 80.0,
                                      iron: 0.9,
                                      calcium: 30.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 50))
        ingredients.append(Ingredient(name: "Blueberries (Driscoll's 11 Oz)",
                                      brand: "Driscoll's",
                                      foodName: "Blueberries",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b07yfdqxq9",
                                      totalGrams: 311.9,
                                      servingSize: 140.0,
                                      calories: 80.0,
                                      fat: 0.5,
                                      carbohydrates: 21.0,
                                      fiber: 4.0,
                                      sugar: 15.0,
                                      netCarbs: 17.0,
                                      protein: 1.0,
                                      vitaminC: 14.0,
                                      potassium: 114.0,
                                      iron: 0.4,
                                      calcium: 9.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 140))
        ingredients.append(Ingredient(name: "Blueberries (Whole Foods Market 1 Pint)",
                                      brand: "Whole Foods Market",
                                      foodName: "Blueberries",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b003aykyig",
                                      totalCost: 4.79,
                                      servingSize: 148.0,
                                      calories: 84.0,
                                      fat: 0.49,
                                      saturatedFat: 0.04,
                                      sodium: 1.5,
                                      carbohydrates: 21.0,
                                      fiber: 3.6,
                                      sugar: 14.74,
                                      netCarbs: 17.4,
                                      protein: 1.1,
                                      vitaminC: 14.0,
                                      vitaminA: 80.0,
                                      potassium: 114.0,
                                      iron: 0.41,
                                      calcium: 8.88,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 148))
        ingredients.append(Ingredient(name: "Blackberries (Whole Foods Market 6 oz)",
                                      brand: "Whole Foods Market",
                                      foodName: "Blackberries",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b000p717mi",
                                      totalCost: 7.49,
                                      totalGrams: 170.1,
                                      servingSize: 72.0,
                                      calories: 31.0,
                                      fat: 0.35,
                                      saturatedFat: 0.01,
                                      sodium: 0.7,
                                      carbohydrates: 7.0,
                                      fiber: 3.8,
                                      sugar: 3.5,
                                      netCarbs: 3.2,
                                      protein: 1.0,
                                      vitaminC: 15.0,
                                      vitaminA: 154.0,
                                      potassium: 117.0,
                                      iron: 0.45,
                                      calcium: 21.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 72))
        ingredients.append(Ingredient(name: "Avocado (Whole Foods Market)",
                                      brand: "Whole Foods Market",
                                      foodName: "Avocado",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b0014glse6",
                                      totalCost: 2.99,
                                      servingSize: 50.0,
                                      calories: 80.0,
                                      fat: 7.0,
                                      saturatedFat: 1.1,
                                      sodium: 3.5,
                                      carbohydrates: 4.3,
                                      fiber: 3.4,
                                      sugar: 0.33,
                                      netCarbs: 0.9,
                                      protein: 1.0,
                                      vitaminC: 5.0,
                                      vitaminA: 73.0,
                                      potassium: 243.0,
                                      iron: 0.28,
                                      calcium: 6.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 50))
        ingredients.append(Ingredient(name: "Blueberries (365 by Whole Foods M 32 Ounce)",
                                      brand: "365 by Whole Foods Market",
                                      foodName: "Blueberries",
                                      url: "https://www.wholefoodsmarket.com/grocery/product/b074h5hflz",
                                      totalCost: 10.99,
                                      totalGrams: 907.2,
                                      servingSize: 140.0,
                                      calories: 70.0,
                                      fat: 1.0,
                                      carbohydrates: 17.0,
                                      fiber: 4.0,
                                      sugar: 12.0,
                                      netCarbs: 13.0,
                                      protein: 0.99,
                                      vitaminD: 0.0,
                                      iron: 0.0,
                                      calcium: 0.0,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      verified: "5/16/2026",
                                      stepAmount: 5,
                                      defaultAmount: 140))
    }


    func serialize() {
        if let encodedData = try? JSONEncoder().encode(ingredients) {
            UserDefaults.standard.set(encodedData, forKey: "ingredient")
        }
    }


    func deserialize() {
        guard
          let data = UserDefaults.standard.data(forKey: "ingredient"),
          let savedItems = try? JSONDecoder().decode([Ingredient].self, from: data)
        else {
            return
        }

        self.ingredients = savedItems
    }


    func create(name: String,
                brand: String = "",
                fullName: String = "",
                category: String = "",
                url: String = "",
                totalCost: Double = 0,
                totalGrams:Double = 0,
                ingredients: [String] = [],
                allergens: [String] = [],
                servingSize: Double,
                calories: Double,
                fat: Double,
                saturatedFat: Double = 0,
                transFat: Double = 0,
                polyunsaturatedFat: Double = 0,
                monounsaturatedFat: Double = 0,
                cholesterol: Double = 0,
                sodium: Double = 0,
                carbohydrates: Double = 0,
                fiber: Double,
                sugar: Double = 0,
                addedSugar: Double = 0,
                sugarAlcohool: Double = 0,
                netCarbs: Double,
                protein: Double,
                omega3: Double = 0,
                zinc: Double = 0,
                vitaminK: Double = 0,
                vitaminE: Double = 0,
                vitaminD: Double = 0,
                vitaminC: Double = 0,
                vitaminB6: Double = 0,
                vitaminB12: Double = 0,
                vitaminA: Double = 0,
                thiamin: Double = 0,
                selenium: Double = 0,
                riboflavin: Double = 0,
                potassium: Double = 0,
                phosphorus: Double = 0,
                pantothenicAcid: Double = 0,
                niacin: Double = 0,
                manganese: Double = 0,
                magnesium: Double = 0,
                iron: Double = 0,
                folicAcid: Double = 0,
                folate: Double = 0,
                copper: Double = 0,
                calcium: Double = 0,
                consumptionUnit: Unit,
                consumptionGrams: Double,
                meatAmount: Double = 0,
                mealAdjustments: [MealAdjustment] = [],
                microNutrients: Bool = false,
                verified: String = "",
                stepAmount: Double = 0,
                defaultAmount: Double = 0,
                foodActive: Bool = true,
                foodName: String = "") {
        let ingredient = Ingredient(name: name,
                                    brand: brand,
                                    fullName: fullName,
                                    category: category,
                                    foodName: foodName,
                                    url: url,
                                    totalCost: totalCost,
                                    totalGrams: totalGrams,
                                    ingredients: ingredients,
                                    allergens: allergens,
                                    servingSize: servingSize,
                                    calories: calories,
                                    fat: fat,
                                    saturatedFat: saturatedFat,
                                    transFat: transFat,
                                    polyunsaturatedFat: polyunsaturatedFat,
                                    monounsaturatedFat: monounsaturatedFat,
                                    cholesterol: cholesterol,
                                    sodium: sodium,
                                    carbohydrates: carbohydrates,
                                    fiber: fiber,
                                    sugar: sugar,
                                    addedSugar: addedSugar,
                                    sugarAlcohool: sugarAlcohool,
                                    netCarbs: netCarbs,
                                    protein: protein,
                                    omega3: omega3,
                                    zinc: zinc,
                                    vitaminK: vitaminK,
                                    vitaminE: vitaminE,
                                    vitaminD: vitaminD,
                                    vitaminC: vitaminC,
                                    vitaminB6: vitaminB6,
                                    vitaminB12: vitaminB12,
                                    vitaminA: vitaminA,
                                    thiamin: thiamin,
                                    selenium: selenium,
                                    riboflavin: riboflavin,
                                    potassium: potassium,
                                    phosphorus: phosphorus,
                                    pantothenicAcid: pantothenicAcid,
                                    niacin: niacin,
                                    manganese: manganese,
                                    magnesium: magnesium,
                                    iron: iron,
                                    folicAcid: folicAcid,
                                    folate: folate,
                                    copper: copper,
                                    calcium: calcium,
                                    consumptionUnit: consumptionUnit,
                                    consumptionGrams: consumptionGrams,
                                    meatAmount: meatAmount,
                                    mealAdjustments: mealAdjustments,
                                    microNutrients: microNutrients,
                                    verified: verified,
                                    stepAmount: stepAmount,
                                    defaultAmount: defaultAmount,
                                    foodActive: foodActive)
        self.ingredients.append(ingredient)
    }


    func getAll() -> [Ingredient] {
        return ingredients.sorted(by: { $0.name < $1.name })
    }

    // Return an array of sorted ingredients that are not:
    // 1. already part of the meal ingredients list
    // 2. that are not categorized as meats
    //
    // This list is used by the Meal Add and the Adjustment Add
    // dialogs to add a new ingredient to a meal that isn't already
    // part of the meal ingredient set or to add a new adjustment
    // ingredient to the adjustments list.
    func getNewMealIngredientNames(existingMealIngredientNames: [String]) -> [String] {
        let existingMealIngredientNamesSet = Set(existingMealIngredientNames)

        // Remove the existing meal ingredients and meats leaving the
        // set of ingredient names to potentially add
        var ingredientNamesSet = Set(ingredients.map { $0.name })
        ingredientNamesSet.subtract(existingMealIngredientNamesSet)
        // ingredientNamesSet.subtract(meatNamesSet)

        // Convert the set to an array, sort, and return
        var pickerOptions = [String](ingredientNamesSet)
        pickerOptions.sort()
        return pickerOptions
    }

    // Returns an array of of ingredients that are categorized as
    // meats (ingredient.meat = true) in addition to 'None'.  This
    // list is used by the Meal Configure dialog to configure the meat
    // for the meal (or 'None' if there's no meat).
    func getAllMeatNames(foodMgr: FoodMgr) -> [String] {
        let meats = ingredients.filter({ foodMgr.isMeat($0) })
        var meatNames: [String] = []
        meatNames.append("None")
        for meat in meats {
            meatNames.append(meat.name)
        }
        return meatNames
    }


    func getNamesSorted() -> [String] {
        let sorted = ingredients.sorted{ (ing1, ing2) -> Bool in
            return ing1.name < ing2.name
        }
        return sorted.map { $0.name }
    }


    func getByName(name: String) -> Ingredient? {
        if let index = ingredients.firstIndex(where: { $0.name == name }) {
            return ingredients[index]
        }

        return nil
    }


    // Flip whether an ingredient is an active member of its Food
    // (Prep page tap). Mutating the @Published array persists via
    // the existing didSet.
    func toggleFoodActive(name: String) {
        if let index = ingredients.firstIndex(where: { $0.name == name }) {
            ingredients[index].foodActive.toggle()
        }
    }


    func update(_ ingredient: Ingredient) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index] = ingredient.update(ingredient: ingredient)
        }
    }


    func move(from: IndexSet, to: Int) {
        ingredients.move(fromOffsets: from, toOffset: to)
    }


    func deleteSet(indexSet: IndexSet) {
        ingredients.remove(atOffsets: indexSet)
    }


    func delete(_ ingredient: Ingredient) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients.remove(at: index)
        }
    }
}

struct MealAdjustment: Codable, Identifiable {
    var id: String

    var name: String
    var amount: Double
    var consumptionUnit: Unit

    init(id: String = UUID().uuidString, name: String, amount: Double, consumptionUnit: Unit = Unit.gram) {
        self.id = id
        self.name = name
        self.amount = amount
        self.consumptionUnit = consumptionUnit
    }
}

struct Ingredient: Codable, Identifiable {
    var id: String

    var name: String

    var brand: String
    var fullName: String
    var category: String
    // Optional group/variant set this ingredient belongs to (e.g.
    // "Eggs"). Empty = not grouped. The Group entity (FoodMgr)
    // owns the group's default member; membership lives here.
    var foodName: String

    var url: String
    var totalCost: Double
    var totalGrams: Double

    var ingredients: [String]
    var allergens: [String]

    var servingSize: Double
    var calories: Double

    var fat: Double
    var saturatedFat: Double
    var transFat: Double
    var polyunsaturatedFat: Double
    var monounsaturatedFat: Double

    var cholesterol: Double
    var sodium: Double

    var carbohydrates: Double
    var fiber: Double
    var sugar: Double
    var addedSugar: Double
    var sugarAlcohool: Double
    var netCarbs: Double

    var protein: Double

    var omega3: Double
    var zinc: Double
    var vitaminK: Double
    var vitaminE: Double
    var vitaminD: Double
    var vitaminC: Double
    var vitaminB6: Double
    var vitaminB12: Double
    var vitaminA: Double
    var thiamin: Double
    var selenium: Double
    var riboflavin: Double
    var potassium: Double
    var phosphorus: Double
    var pantothenicAcid: Double
    var niacin: Double
    var manganese: Double
    var magnesium: Double
    var iron: Double
    var folicAcid: Double
    var folate: Double
    var copper: Double
    var calcium: Double

    var consumptionUnit: Unit
    var consumptionGrams: Double

    var meatAmount: Double
    var mealAdjustments: [MealAdjustment]

    var microNutrients: Bool

    var verified: String

    var stepAmount: Double   // 0 means "auto" — use the effectiveStep heuristic

    // Default consumption amount seeded into a new meal row (in the
    // ingredient's consumption unit). 0 = no preset. For group
    // members, switching member resets the row to this amount.
    var defaultAmount: Double

    // Whether this ingredient is an active member/variant of its
    // Food (toggled on the Prep page). Green = active. Defaults
    // true so existing seed/data is active without migration.
    var foodActive: Bool

    init(id: String = UUID().uuidString,
         name: String,
         brand: String = "",
         fullName: String = "",
         category: String = "",
         foodName: String = "",
         url: String = "",
         totalCost: Double = 0,
         totalGrams: Double = 0,
         ingredients: [String] = [],
         allergens: [String] = [],
         servingSize: Double,
         calories: Double,
         fat: Double,
         saturatedFat: Double = 0,
         transFat: Double = 0,
         polyunsaturatedFat: Double = 0,
         monounsaturatedFat: Double = 0,
         cholesterol: Double = 0,
         sodium: Double = 0,
         carbohydrates: Double = 0,
         fiber: Double,
         sugar: Double = 0,
         addedSugar: Double = 0,
         sugarAlcohool: Double = 0,
         netCarbs: Double,
         protein: Double,
         omega3: Double = 0,
         zinc: Double = 0,
         vitaminK: Double = 0,
         vitaminE: Double = 0,
         vitaminD: Double = 0,
         vitaminC: Double = 0,
         vitaminB6: Double = 0,
         vitaminB12: Double = 0,
         vitaminA: Double = 0,
         thiamin: Double = 0,
         selenium: Double = 0,
         riboflavin: Double = 0,
         potassium: Double = 0,
         phosphorus: Double = 0,
         pantothenicAcid: Double = 0,
         niacin: Double = 0,
         manganese: Double = 0,
         magnesium: Double = 0,
         iron: Double = 0,
         folicAcid: Double = 0,
         folate: Double = 0,
         copper: Double = 0,
         calcium: Double = 0,
         consumptionUnit: Unit = Unit.gram,
         consumptionGrams: Double,
         meatAmount: Double = 200,
         mealAdjustments: [MealAdjustment] = [],
         microNutrients: Bool = false,
         verified: String = "",
         stepAmount: Double = 0,
         defaultAmount: Double = 0,
         foodActive: Bool = true) {

        self.id = id

        self.name = name

        self.brand = brand
        self.fullName = fullName
        self.category = category
        self.foodName = foodName

        self.url = url
        self.totalCost = totalCost
        self.totalGrams = totalGrams

        self.ingredients = ingredients
        self.allergens = allergens

        self.servingSize = servingSize
        self.calories = calories

        self.fat = fat
        self.saturatedFat = saturatedFat
        self.transFat = transFat
        self.polyunsaturatedFat = polyunsaturatedFat
        self.monounsaturatedFat = monounsaturatedFat

        self.cholesterol = cholesterol
        self.sodium = sodium

        self.carbohydrates = carbohydrates
        self.fiber = fiber
        self.sugar = sugar
        self.addedSugar = addedSugar
        self.sugarAlcohool = sugarAlcohool
        self.netCarbs = netCarbs

        self.protein = protein

        self.omega3 = omega3
        self.zinc = zinc
        self.vitaminK = vitaminK
        self.vitaminE = vitaminE
        self.vitaminD = vitaminD
        self.vitaminC = vitaminC
        self.vitaminB6 = vitaminB6
        self.vitaminB12 = vitaminB12
        self.vitaminA = vitaminA
        self.thiamin = thiamin
        self.selenium = selenium
        self.riboflavin = riboflavin
        self.potassium = potassium
        self.phosphorus = phosphorus
        self.pantothenicAcid = pantothenicAcid
        self.niacin = niacin
        self.manganese = manganese
        self.magnesium = magnesium
        self.iron = iron
        self.folicAcid = folicAcid
        self.folate = folate
        self.copper = copper
        self.calcium = calcium

        self.consumptionUnit = consumptionUnit
        self.consumptionGrams = consumptionGrams

        self.meatAmount = meatAmount
        self.mealAdjustments = mealAdjustments

        self.microNutrients = microNutrients

        self.verified = verified

        self.stepAmount = stepAmount
        self.defaultAmount = defaultAmount
        self.foodActive = foodActive
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decode(String.self, forKey: .id)
        self.name = try c.decode(String.self, forKey: .name)
        self.brand = try c.decode(String.self, forKey: .brand)
        self.fullName = try c.decode(String.self, forKey: .fullName)
        self.category = try c.decode(String.self, forKey: .category)
        // Migration-safe: absent in data saved before groups existed.
        self.foodName = try c.decodeIfPresent(String.self, forKey: .foodName) ?? ""
        self.url = try c.decode(String.self, forKey: .url)
        self.totalCost = try c.decode(Double.self, forKey: .totalCost)
        self.totalGrams = try c.decode(Double.self, forKey: .totalGrams)
        self.ingredients = try c.decode([String].self, forKey: .ingredients)
        self.allergens = try c.decode([String].self, forKey: .allergens)
        self.servingSize = try c.decode(Double.self, forKey: .servingSize)
        self.calories = try c.decode(Double.self, forKey: .calories)
        self.fat = try c.decode(Double.self, forKey: .fat)
        self.saturatedFat = try c.decode(Double.self, forKey: .saturatedFat)
        self.transFat = try c.decode(Double.self, forKey: .transFat)
        self.polyunsaturatedFat = try c.decode(Double.self, forKey: .polyunsaturatedFat)
        self.monounsaturatedFat = try c.decode(Double.self, forKey: .monounsaturatedFat)
        self.cholesterol = try c.decode(Double.self, forKey: .cholesterol)
        self.sodium = try c.decode(Double.self, forKey: .sodium)
        self.carbohydrates = try c.decode(Double.self, forKey: .carbohydrates)
        self.fiber = try c.decode(Double.self, forKey: .fiber)
        self.sugar = try c.decode(Double.self, forKey: .sugar)
        self.addedSugar = try c.decode(Double.self, forKey: .addedSugar)
        self.sugarAlcohool = try c.decode(Double.self, forKey: .sugarAlcohool)
        self.netCarbs = try c.decode(Double.self, forKey: .netCarbs)
        self.protein = try c.decode(Double.self, forKey: .protein)
        self.omega3 = try c.decode(Double.self, forKey: .omega3)
        self.zinc = try c.decode(Double.self, forKey: .zinc)
        self.vitaminK = try c.decode(Double.self, forKey: .vitaminK)
        self.vitaminE = try c.decode(Double.self, forKey: .vitaminE)
        self.vitaminD = try c.decode(Double.self, forKey: .vitaminD)
        self.vitaminC = try c.decode(Double.self, forKey: .vitaminC)
        self.vitaminB6 = try c.decode(Double.self, forKey: .vitaminB6)
        self.vitaminB12 = try c.decode(Double.self, forKey: .vitaminB12)
        self.vitaminA = try c.decode(Double.self, forKey: .vitaminA)
        self.thiamin = try c.decode(Double.self, forKey: .thiamin)
        self.selenium = try c.decode(Double.self, forKey: .selenium)
        self.riboflavin = try c.decode(Double.self, forKey: .riboflavin)
        self.potassium = try c.decode(Double.self, forKey: .potassium)
        self.phosphorus = try c.decode(Double.self, forKey: .phosphorus)
        self.pantothenicAcid = try c.decode(Double.self, forKey: .pantothenicAcid)
        self.niacin = try c.decode(Double.self, forKey: .niacin)
        self.manganese = try c.decode(Double.self, forKey: .manganese)
        self.magnesium = try c.decode(Double.self, forKey: .magnesium)
        self.iron = try c.decode(Double.self, forKey: .iron)
        self.folicAcid = try c.decode(Double.self, forKey: .folicAcid)
        self.folate = try c.decode(Double.self, forKey: .folate)
        self.copper = try c.decode(Double.self, forKey: .copper)
        self.calcium = try c.decode(Double.self, forKey: .calcium)
        self.consumptionUnit = try c.decode(Unit.self, forKey: .consumptionUnit)
        self.consumptionGrams = try c.decode(Double.self, forKey: .consumptionGrams)
        self.meatAmount = try c.decode(Double.self, forKey: .meatAmount)
        self.mealAdjustments = try c.decode([MealAdjustment].self, forKey: .mealAdjustments)
        self.microNutrients = try c.decode(Bool.self, forKey: .microNutrients)
        self.verified = try c.decode(String.self, forKey: .verified)
        self.stepAmount = try c.decodeIfPresent(Double.self, forKey: .stepAmount) ?? 0
        self.defaultAmount = try c.decodeIfPresent(Double.self, forKey: .defaultAmount) ?? 0
        self.foodActive = try c.decodeIfPresent(Bool.self, forKey: .foodActive) ?? true
    }

    var effectiveTotalGrams: Double {
        if totalGrams > 0 { return totalGrams }
        let s = name.lowercased()
        func num(_ pattern: String) -> Double? {
            guard let re = try? NSRegularExpression(pattern: pattern),
                  let m = re.firstMatch(in: s, range: NSRange(s.startIndex..., in: s)),
                  let r = Range(m.range(at: 1), in: s) else { return nil }
            return Double(s[r])
        }
        if let n = num(#"([0-9]+(?:\.[0-9]+)?)\s*fl\s*oz"#)                  { return n * 28.3495 }
        if let n = num(#"([0-9]+(?:\.[0-9]+)?)\s*(?:oz|ounce|ounces)\b"#)    { return n * 28.3495 }
        if let n = num(#"([0-9]+(?:\.[0-9]+)?)\s*(?:lb|lbs|pound|pounds)\b"#) { return n * 453.592 }
        if let n = num(#"([0-9]+(?:\.[0-9]+)?)\s*(?:count|ct)\b"#)           { return n * servingSize }
        if let n = num(#"([0-9]+(?:\.[0-9]+)?)\s*pint"#)                     { return n * 473.176 }
        if let n = num(#"([0-9]+(?:\.[0-9]+)?)\s*g(?:ram|rams)?\b"#)         { return n }
        return 0
    }
    var costPerGram: Double { let g = effectiveTotalGrams; return g > 0 ? totalCost / g : 0 }
    var costPer100: Double { get { costPerGram * 100 } set {} }
    var costPerServing: Double { costPerGram * servingSize }

    var calories100: Double {
        set {
        }
        get {
            (calories * 100) / servingSize
        }
    }

    var fat100: Double {
        set {
        }
        get {
            (fat * 100) / servingSize
        }
    }

    var fiber100: Double {
        set {
        }
        get {
            (fiber * 100) / servingSize
        }
    }

    var netCarbs100: Double {
        set {
        }
        get {
            (netCarbs * 100) / servingSize
        }
    }

    var protein100: Double {
        set {
        }
        get {
            (protein * 100) / servingSize
        }
    }


    func update(ingredient: Ingredient) -> Ingredient {
        return Ingredient(id: ingredient.id,
                          name: ingredient.name,
                          brand: ingredient.brand,
                          fullName: ingredient.fullName,
                          category: ingredient.category,
                          foodName: ingredient.foodName,
                          url: ingredient.url,
                          totalCost: ingredient.totalCost,
                          totalGrams: ingredient.totalGrams,
                          ingredients: ingredient.ingredients,
                          allergens: ingredient.allergens,
                          servingSize: ingredient.servingSize,
                          calories: ingredient.calories,
                          fat: ingredient.fat,
                          saturatedFat: ingredient.saturatedFat,
                          transFat: ingredient.transFat,
                          polyunsaturatedFat: ingredient.polyunsaturatedFat,
                          monounsaturatedFat: ingredient.monounsaturatedFat,
                          cholesterol: ingredient.cholesterol,
                          sodium: ingredient.sodium,
                          carbohydrates: ingredient.carbohydrates,
                          fiber: ingredient.fiber,
                          sugar: ingredient.sugar,
                          addedSugar: ingredient.addedSugar,
                          sugarAlcohool: ingredient.sugarAlcohool,
                          netCarbs: ingredient.netCarbs,
                          protein: ingredient.protein,
                          omega3: ingredient.omega3,
                          zinc: ingredient.zinc,
                          vitaminK: ingredient.vitaminK,
                          vitaminE: ingredient.vitaminE,
                          vitaminD: ingredient.vitaminD,
                          vitaminC: ingredient.vitaminC,
                          vitaminB6: ingredient.vitaminB6,
                          vitaminB12: ingredient.vitaminB12,
                          vitaminA: ingredient.vitaminA,
                          thiamin: ingredient.thiamin,
                          selenium: ingredient.selenium,
                          riboflavin: ingredient.riboflavin,
                          potassium: ingredient.potassium,
                          phosphorus: ingredient.phosphorus,
                          pantothenicAcid: ingredient.pantothenicAcid,
                          niacin: ingredient.niacin,
                          manganese: ingredient.manganese,
                          magnesium: ingredient.magnesium,
                          iron: ingredient.iron,
                          folicAcid: ingredient.folicAcid,
                          folate: ingredient.folate,
                          copper: ingredient.copper,
                          calcium: ingredient.calcium,
                          consumptionUnit: ingredient.consumptionUnit,
                          consumptionGrams: ingredient.consumptionGrams,
                          meatAmount: ingredient.meatAmount,
                          mealAdjustments: ingredient.mealAdjustments,
                          microNutrients: ingredient.microNutrients,
                          verified: verified,
                          stepAmount: ingredient.stepAmount,
                          defaultAmount: ingredient.defaultAmount,
                          foodActive: ingredient.foodActive)
    }
}


// ============================================================
// AvoidList — substances to flag when they appear in an
// Ingredient's `ingredients` (label) list. Pure static data +
// matcher; no state, no persistence. Short acronyms (BHA/BHT/
// MSG) match whole-word only so they don't fire on substrings.
// ============================================================
struct AvoidEntry {
    let canonicalName: String
    let category: String
    let substrings: [String]      // all lowercased
    var wholeWordOnly: Bool = false
}

enum AvoidList {

    static let entries: [AvoidEntry] = [
        // Added sugars & syrups (all corn-syrup variants)
        AvoidEntry(canonicalName: "High-Fructose Corn Syrup", category: "Added sugar",
                   substrings: ["high fructose corn syrup", "high-fructose corn syrup", "hfcs"]),
        AvoidEntry(canonicalName: "Corn Syrup", category: "Added sugar",
                   substrings: ["corn syrup"]),
        AvoidEntry(canonicalName: "Glucose-Fructose Syrup", category: "Added sugar",
                   substrings: ["glucose-fructose syrup", "glucose fructose syrup"]),
        AvoidEntry(canonicalName: "Fructose Syrup", category: "Added sugar",
                   substrings: ["fructose syrup"]),
        AvoidEntry(canonicalName: "Invert Sugar", category: "Added sugar",
                   substrings: ["invert sugar", "invert syrup"]),
        AvoidEntry(canonicalName: "Dextrose", category: "Added sugar",
                   substrings: ["dextrose"]),
        AvoidEntry(canonicalName: "Maltodextrin", category: "Added sugar",
                   substrings: ["maltodextrin"]),
        AvoidEntry(canonicalName: "Crystalline Fructose", category: "Added sugar",
                   substrings: ["crystalline fructose"]),
        AvoidEntry(canonicalName: "Brown Rice Syrup", category: "Added sugar",
                   substrings: ["brown rice syrup", "rice syrup"]),
        AvoidEntry(canonicalName: "Agave Syrup", category: "Added sugar",
                   substrings: ["agave nectar", "agave syrup"]),

        // Trans fats / refined seed oils
        AvoidEntry(canonicalName: "Partially Hydrogenated Oil (trans fat)", category: "Trans fat",
                   substrings: ["partially hydrogenated"]),
        AvoidEntry(canonicalName: "Soybean Oil", category: "Seed oil",
                   substrings: ["soybean oil"]),
        AvoidEntry(canonicalName: "Canola Oil", category: "Seed oil",
                   substrings: ["canola oil"]),
        AvoidEntry(canonicalName: "Sunflower Oil", category: "Seed oil",
                   substrings: ["sunflower oil"]),
        AvoidEntry(canonicalName: "Safflower Oil", category: "Seed oil",
                   substrings: ["safflower oil"]),
        AvoidEntry(canonicalName: "Cottonseed Oil", category: "Seed oil",
                   substrings: ["cottonseed oil"]),
        AvoidEntry(canonicalName: "Corn Oil", category: "Seed oil",
                   substrings: ["corn oil"]),

        // Artificial sweeteners
        AvoidEntry(canonicalName: "Aspartame", category: "Artificial sweetener",
                   substrings: ["aspartame"]),
        AvoidEntry(canonicalName: "Sucralose", category: "Artificial sweetener",
                   substrings: ["sucralose"]),
        AvoidEntry(canonicalName: "Acesulfame Potassium", category: "Artificial sweetener",
                   substrings: ["acesulfame potassium", "acesulfame-k", "ace-k"]),
        AvoidEntry(canonicalName: "Saccharin", category: "Artificial sweetener",
                   substrings: ["saccharin"]),

        // Synthetic dyes
        AvoidEntry(canonicalName: "Red 40", category: "Synthetic dye",
                   substrings: ["red 40", "red no. 40", "allura red"]),
        AvoidEntry(canonicalName: "Yellow 5", category: "Synthetic dye",
                   substrings: ["yellow 5", "yellow no. 5", "tartrazine"]),
        AvoidEntry(canonicalName: "Yellow 6", category: "Synthetic dye",
                   substrings: ["yellow 6", "yellow no. 6", "sunset yellow"]),
        AvoidEntry(canonicalName: "Blue 1", category: "Synthetic dye",
                   substrings: ["blue 1", "blue no. 1", "brilliant blue"]),
        AvoidEntry(canonicalName: "Red 3", category: "Synthetic dye",
                   substrings: ["red 3", "red no. 3", "erythrosine"]),

        // Preservatives / antioxidants
        AvoidEntry(canonicalName: "BHA", category: "Preservative",
                   substrings: ["butylated hydroxyanisole", "bha"], wholeWordOnly: true),
        AvoidEntry(canonicalName: "BHT", category: "Preservative",
                   substrings: ["butylated hydroxytoluene", "bht"], wholeWordOnly: true),
        AvoidEntry(canonicalName: "TBHQ", category: "Preservative",
                   substrings: ["tbhq", "tert-butylhydroquinone", "tertiary butylhydroquinone"]),
        AvoidEntry(canonicalName: "Sodium Benzoate", category: "Preservative",
                   substrings: ["sodium benzoate"]),
        AvoidEntry(canonicalName: "Sodium Nitrite", category: "Preservative",
                   substrings: ["sodium nitrite"]),
        AvoidEntry(canonicalName: "Sodium Nitrate", category: "Preservative",
                   substrings: ["sodium nitrate"]),
        AvoidEntry(canonicalName: "Propyl Gallate", category: "Preservative",
                   substrings: ["propyl gallate"]),

        // Flavor enhancers
        AvoidEntry(canonicalName: "MSG", category: "Flavor enhancer",
                   substrings: ["monosodium glutamate", "msg"], wholeWordOnly: true),
        AvoidEntry(canonicalName: "Autolyzed Yeast Extract", category: "Flavor enhancer",
                   substrings: ["autolyzed yeast"]),
        AvoidEntry(canonicalName: "Hydrolyzed Protein", category: "Flavor enhancer",
                   substrings: ["hydrolyzed"]),

        // Emulsifiers of concern
        AvoidEntry(canonicalName: "Carrageenan", category: "Emulsifier",
                   substrings: ["carrageenan"]),
        AvoidEntry(canonicalName: "Polysorbate 80", category: "Emulsifier",
                   substrings: ["polysorbate 80"]),
        AvoidEntry(canonicalName: "Carboxymethylcellulose", category: "Emulsifier",
                   substrings: ["carboxymethylcellulose", "cellulose gum"]),
    ]


    // All flagged substances present in the given label list.
    static func allMatches(in ingredients: [String]) -> [AvoidEntry] {
        guard !ingredients.isEmpty else { return [] }
        let hay = ingredients.map { $0.lowercased() }
        let tokens = Set(hay.flatMap {
            $0.split { !$0.isLetter && !$0.isNumber }.map(String.init)
        })
        return entries.filter { e in
            e.substrings.contains { sub in
                e.wholeWordOnly ? tokens.contains(sub)
                                : hay.contains { $0.contains(sub) }
            }
        }
    }

    static func firstMatch(in ingredients: [String]) -> AvoidEntry? {
        allMatches(in: ingredients).first
    }
}
