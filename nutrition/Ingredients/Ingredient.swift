import Foundation

class IngredientMgr: ObservableObject {


    @Published var ingredients: [Ingredient] = [] {
        didSet {
            serialize()
        }
    }


    init() {
        ingredients.append(Ingredient(name: "Coconut Oil",
                                      servingSize: 14,
                                      calories: 130,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Avocado Oil",
                                      servingSize: 14,
                                      calories: 130,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Pumpkin Seeds",
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 14,
                                      fiber: 2,
                                      netCarbs: 1,
                                      protein: 8,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Chicken",
                                      servingSize: 100,
                                      calories: 115,
                                      fat: 2.7,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 22,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 240))
        ingredients.append(Ingredient(name: "Beef",
                                      servingSize: 100,
                                      calories: 214,
                                      fat: 15.2,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 19,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 150,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -2, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Pumpkin Seeds", amount: -15, consumptionUnit: Unit.gram) ]))
        ingredients.append(Ingredient(name: "Bison",
                                      servingSize: 112,
                                      calories: 160,
                                      fat: 8,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 23,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 150,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -2, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Pumpkin Seeds", amount: -15, consumptionUnit: Unit.gram) ]))
        ingredients.append(Ingredient(name: "Lamb",
                                      servingSize: 85,
                                      calories: 253,
                                      fat: 22,
                                      fiber: 0,
                                      netCarbs: 0.19,
                                      protein: 13.09,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 150,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -2, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Pumpkin Seeds", amount: -15, consumptionUnit: Unit.gram) ]))
        ingredients.append(Ingredient(name: "Pork Chop",
                                      servingSize: 113,
                                      calories: 220,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 30,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 240,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -2, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Pumpkin Seeds", amount: -15, consumptionUnit: Unit.gram) ]))
        ingredients.append(Ingredient(name: "Salmon",
                                      servingSize: 112,
                                      calories: 150,
                                      fat: 5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 25,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 200,
                                      mealAdjustments: [ MealAdjustment(name: "Fish Oil", amount: -1, consumptionUnit: Unit.tablespoon) ]))
        ingredients.append(Ingredient(name: "Top Sirloin Cap",
                                      servingSize: 238,
                                      calories: 125,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 51,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      available: false))
        ingredients.append(Ingredient(name: "Argentine Red Shrimp",
                                      servingSize: 110,
                                      calories: 100,
                                      fat: 1.5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: true,
                                      meatAmount: 250,
                                      available: false))
        ingredients.append(Ingredient(name: "Eggs",
                                      servingSize: 50,
                                      calories: 70,
                                      fat: 5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 6,
                                      consumptionUnit: Unit.egg,
                                      consumptionGrams: 50,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Serrano Pepper",
                                      servingSize: 6.1,
                                      calories: 2,
                                      fat: 0.03,
                                      fiber: 0.23,
                                      netCarbs: 0.18,
                                      protein: 0.11,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Flackers (SS)",
                                      servingSize: 30,
                                      calories: 160,
                                      fat: 12,
                                      fiber: 9,
                                      netCarbs: 1,
                                      protein: 6,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Jalapeno Pepper",
                                      servingSize: 14,
                                      calories: 4,
                                      fat: 0.05,
                                      fiber: 0.39,
                                      netCarbs: 0.52,
                                      protein: 0.13,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      available: false))
        // ingredients.append(Ingredient(name: "Salsa",
        //                               servingSize: 30,
        //                               calories: 10,
        //                               fat: 0,
        //                               fiber: 1,
        //                               netCarbs: 0,
        //                               protein: 1,
        //                               consumptionUnit: Unit.tablespoon,
        //                               consumptionGrams: 15,
        //                               meat: false,
        //                               available: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Arugula",
                                      servingSize: 20,
                                      calories: 5,
                                      fat: 0.13,
                                      fiber: 0.32,
                                      netCarbs: 0.41,
                                      protein: 0.52,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "No nutrition on whole foods site"))
        ingredients.append(Ingredient(name: "Spinach",
                                      servingSize: 85,
                                      calories: 25,
                                      fat: 0.25,
                                      fiber: 2,
                                      netCarbs: 1,
                                      protein: 2,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false))
        ingredients.append(Ingredient(name: "Romaine",
                                      servingSize: 47,
                                      calories: 8,
                                      fat: 0.14,
                                      fiber: 0.99,
                                      netCarbs: 0.51,
                                      protein: 0.58,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Collared Greens",
                                      servingSize: 36,
                                      calories: 12,
                                      fat: 0.22,
                                      fiber: 1.4,
                                      netCarbs: 0.6,
                                      protein: 1.09,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Broccoli",
                                      servingSize: 85,
                                      calories: 20,
                                      fat: 0,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 2,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Cauliflower",
                                      servingSize: 85,
                                      calories: 20,
                                      fat: 0,
                                      fiber: 2,
                                      netCarbs: 2,
                                      protein: 2,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Mushrooms",
                                      servingSize: 35,
                                      calories: 8,
                                      fat: 0.12,
                                      fiber: 0.35,
                                      netCarbs: 0.75,
                                      protein: 1.081,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Radish",
                                      servingSize: 58,
                                      calories: 9,
                                      fat: 0.06,
                                      fiber: 0.93,
                                      netCarbs: 1.07,
                                      protein: 0.39,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Avocado",
                                      servingSize: 50,
                                      calories: 80,
                                      fat: 7,
                                      fiber: 3.4,
                                      netCarbs: 0.9,
                                      protein: 1,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Mackerel",
                                      servingSize: 85,
                                      calories: 180,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Smoked Sardines",
                                      servingSize: 85,
                                      calories: 170,
                                      fat: 11,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 18,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Sardines",
                                      servingSize: 85,
                                      calories: 190,
                                      fat: 12,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Tuna",
                                      servingSize: 85,
                                      calories: 100,
                                      fat: 2.5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 21,
                                      consumptionUnit: Unit.can,
                                      consumptionGrams: 85,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Macadamia Nuts",
                                      servingSize: 30,
                                      calories: 220,
                                      fat: 23,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 2,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Walnuts",
                                      servingSize: 28,
                                      calories: 190,
                                      fat: 18,
                                      fiber: 2,
                                      netCarbs: 2,
                                      protein: 4,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false))
        ingredients.append(Ingredient(name: "Pecans",
                                      servingSize: 28,
                                      calories: 190,
                                      fat: 20,
                                      fiber: 3,
                                      netCarbs: 1,
                                      protein: 3,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false))
        ingredients.append(Ingredient(name: "Peanuts",
                                      servingSize: 28,
                                      calories: 160,
                                      fat: 14,
                                      fiber: 2,
                                      netCarbs: 4,
                                      protein: 7,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Mustard",
                                      servingSize: 5,
                                      calories: 5,
                                      fat: 0,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 15,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Extra Virgin Olive Oil",
                                      servingSize: 14,
                                      calories: 120,
                                      fat: 14,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Fish Oil",
                                      servingSize: 4.667,
                                      calories: 40,
                                      fat: 4.5,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 0,
                                      consumptionUnit: Unit.tablespoon,
                                      consumptionGrams: 14,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "String Cheese",
                                      servingSize: 28,
                                      calories: 80,
                                      fat: 6,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 7,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 28,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Dubliner Cheese",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 7,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Emmi Roth",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 8,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "9/1/22"))
        ingredients.append(Ingredient(name: "Cheddar Cheese",
                                      servingSize: 28,
                                      calories: 110,
                                      fat: 9,
                                      fiber: 0,
                                      netCarbs: 1,
                                      protein: 7,
                                      consumptionUnit: Unit.slice,
                                      consumptionGrams: 9.33,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Keto Bite (Mint)",
                                      servingSize: 25,
                                      calories: 140,
                                      fat: 12,
                                      fiber: 4,
                                      netCarbs: 1,
                                      protein: 6,
                                      consumptionUnit: Unit.whole,
                                      consumptionGrams: 9.33,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Keto Bite (Macadamia)",
                                      servingSize: 25,
                                      calories: 140,
                                      fat: 11,
                                      fiber: 6,
                                      netCarbs: 0,
                                      protein: 6,
                                      consumptionUnit: Unit.whole,
                                      consumptionGrams: 9.33,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mini Original Semisoft Cheese",
                                      servingSize: 21,
                                      calories: 70,
                                      fat: 6,
                                      fiber: 0,
                                      netCarbs: 0,
                                      protein: 5,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Dark Chocolate (Divine)",
                                      servingSize: 28,
                                      calories: 180,
                                      fat: 14,
                                      fiber: 4,
                                      netCarbs: 6,
                                      protein: 3,
                                      consumptionUnit: Unit.piece,
                                      consumptionGrams: 3.5,
                                      meat: false))
        ingredients.append(Ingredient(name: "Keto Mint Ice Cream",
                                      servingSize: 99,
                                      calories: 250,
                                      fat: 23,
                                      fiber: 4,
                                      netCarbs: 3,
                                      protein: 4,
                                      consumptionUnit: Unit.gram,
                                      consumptionGrams: 1,
                                      meat: false,
                                      verified: "3/16/22"))
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
                consumptionUnit: Unit,
                consumptionGrams: Double,
                meat: Bool = false,
                meatAmount: Double = 0,
                mealAdjustments: [MealAdjustment] = [],
                microNutrients: Bool = false,
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
                available: Bool = true,
                verified: String = "") {
        let ingredient = Ingredient(name: name,
                                    brand: brand,
                                    fullName: fullName,
                                    category: category,
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
                                    consumptionUnit: consumptionUnit,
                                    consumptionGrams: consumptionGrams,
                                    meat: meat,
                                    meatAmount: meatAmount,
                                    mealAdjustments: mealAdjustments,
                                    microNutrients: microNutrients,
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
                                    available: available,
                                    verified: verified)
        self.ingredients.append(ingredient)
    }


    func getAll(includeUnavailable: Bool = false) -> [Ingredient] {
        if includeUnavailable {
            return ingredients.sorted(by: { $0.name < $1.name })
        }
        return ingredients.filter({ $0.available == true }).sorted(by: { $0.name < $1.name })
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
        let meatNamesSet = Set(getAllMeatNames())

        // Remove the existing meal ingredients and meats leaving the
        // set of ingredient names to potentially add
        var ingredientNamesSet = Set(ingredients.map { $0.name })
        ingredientNamesSet.subtract(existingMealIngredientNamesSet)
        ingredientNamesSet.subtract(meatNamesSet)

        // Convert the set to an array, sort, and return
        var pickerOptions = [String](ingredientNamesSet)
        pickerOptions.sort()
        return pickerOptions
    }

    // Returns an array of of ingredients that are categorized as
    // meats (ingredient.meat = true) in addition to 'None'.  This
    // list is used by the Meal Configure dialog to configure the meat
    // for the meal (or 'None' if there's no meat).

    func getAllMeatNames() -> [String] {
        let meats = ingredients.filter({ $0.meat == true })
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


    func update(_ ingredient: Ingredient) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index] = ingredient.update(ingredient: ingredient)
        }
    }


    func available(_ name: String) {
        if let index = ingredients.firstIndex(where: { $0.name == name }) {
            if !ingredients[index].available {
                ingredients[index] = ingredients[index].toggleAvailable()
            }
        }
    }


    func unavailableIngredientsExist() -> Bool {
        let unavailableIngredients = ingredients.filter({ $0.available == false })
        return unavailableIngredients.count > 0
    }


    func toggleAvailable(_ ingredient: Ingredient) -> Ingredient? {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index] = ingredient.toggleAvailable()
            return ingredients[index]
        }

        return nil
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

    var consumptionUnit: Unit
    var consumptionGrams: Double

    var meat: Bool
    var meatAmount: Double
    var mealAdjustments: [MealAdjustment]

    var microNutrients: Bool

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

    var available: Bool

    var verified: String

    init(id: String = UUID().uuidString,
         name: String,
         brand: String = "",
         fullName: String = "",
         category: String = "",
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
         consumptionUnit: Unit = Unit.gram,
         consumptionGrams: Double,
         meat: Bool = false,
         meatAmount: Double = 200,
         mealAdjustments: [MealAdjustment] = [],
         microNutrients: Bool = false,
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
         available: Bool = true,
         verified: String = "") {

        self.id = id

        self.name = name

        self.brand = brand
        self.fullName = fullName
        self.category = category

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

        self.consumptionUnit = consumptionUnit
        self.consumptionGrams = consumptionGrams

        self.meat = meat
        self.meatAmount = meatAmount
        self.mealAdjustments = mealAdjustments

        self.microNutrients = microNutrients

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

        self.available = available

        self.verified = verified
    }

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


    func toggleAvailable() -> Ingredient {
        return Ingredient(id: id,
                          name: name,
                          brand: brand,
                          fullName: fullName,
                          category: category,
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
                          consumptionUnit: consumptionUnit,
                          consumptionGrams: consumptionGrams,
                          meat: meat,
                          mealAdjustments: mealAdjustments,
                          microNutrients: microNutrients,
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
                          available: !available,
                          verified: verified)
    }


    func update(ingredient: Ingredient) -> Ingredient {
        return Ingredient(id: ingredient.id,
                          name: ingredient.name,
                          brand: ingredient.brand,
                          fullName: ingredient.fullName,
                          category: ingredient.category,
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
                          consumptionUnit: ingredient.consumptionUnit,
                          consumptionGrams: ingredient.consumptionGrams,
                          meat: ingredient.meat,
                          meatAmount: ingredient.meatAmount,
                          mealAdjustments: ingredient.mealAdjustments,
                          microNutrients: ingredient.microNutrients,
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
                          available: ingredient.available,
                          verified: verified)
    }
}
