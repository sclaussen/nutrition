import Foundation

class IngredientMgr: ObservableObject {

    @Published var ingredients: [Ingredient] = [] {
        didSet {
            serialize()
        }
    }

    init() {
        ingredients.append(Ingredient(name: "Coconut Oil", servingSize: 14, calories: 130, fat: 14, fiber: 0, netcarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Avocado Oil", servingSize: 14, calories: 120, fat: 14, fiber: 0, netcarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Pumpkin Seeds", servingSize: 28, calories: 160, fat: 14, fiber: 2, netcarbs: 1, protein: 8, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Chicken", servingSize: 100, calories: 115, fat: 2.7, fiber: 0, netcarbs: 0, protein: 22, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 250))
        ingredients.append(Ingredient(name: "Beef", servingSize: 100, calories: 214, fat: 15.2, fiber: 0, netcarbs: 0, protein: 19, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 150,
                                      meatAdjustments: [ MeatAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MeatAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon),
                                                         MeatAdjustment(name: "Mackerel", amount: 1, consumptionUnit: Unit.can),
                                                         MeatAdjustment(name: "Dark Chocolate (Divine)", amount: 1, consumptionUnit: Unit.block) ]))
        ingredients.append(Ingredient(name: "Lamb", servingSize: 85, calories: 253, fat: 22, fiber: 0, netcarbs: 0.19, protein: 13.09, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 150,
                                      meatAdjustments: [ MeatAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MeatAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon) ], available: false))
        ingredients.append(Ingredient(name: "Pork Chop", servingSize: 113, calories: 220, fat: 11, fiber: 0, netcarbs: 0, protein: 30, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true,
                                      meatAdjustments: [ MeatAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MeatAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon) ]))
        ingredients.append(Ingredient(name: "Salmon", servingSize: 112, calories: 150, fat: 5, fiber: 0, netcarbs: 0, protein: 25, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true,
                                       meatAdjustments: [ MeatAdjustment(name: "Fish Oil", amount: -1, consumptionUnit: Unit.tablespoon) ]))
        ingredients.append(Ingredient(name: "Top Sirloin Cap", servingSize: 238, calories: 125, fat: 14, fiber: 0, netcarbs: 0, protein: 51, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, available: false))
        ingredients.append(Ingredient(name: "Argentine Red Shrimp", servingSize: 110, calories: 100, fat: 1.5, fiber: 0, netcarbs: 0, protein: 21, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 250, available: false))
        ingredients.append(Ingredient(name: "Eggs", servingSize: 50, calories: 70, fat: 5, fiber: 0, netcarbs: 0, protein: 6, consumptionUnit: Unit.egg, consumptionGrams: 50, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Serrano Pepper", servingSize: 6.1, calories: 2, fat: 0.03, fiber: 0.23, netcarbs: 0.18, protein: 0.11, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Jalapeno Pepper", servingSize: 14, calories: 4, fat: 0.05, fiber: 0.39, netcarbs: 0.52, protein: 0.13, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, available: false))
        ingredients.append(Ingredient(name: "Salsa", servingSize: 30, calories: 10, fat: 0, fiber: 1, netcarbs: 0, protein: 1, consumptionUnit: Unit.tablespoon, consumptionGrams: 15, meat: false, available: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Arugula", servingSize: 20, calories: 5, fat: 0.13, fiber: 0.32, netcarbs: 0.41, protein: 0.52, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "No nutrition on whole foods site"))
        ingredients.append(Ingredient(name: "Spinach", servingSize: 85, calories: 25, fat: 0.25, fiber: 2, netcarbs: 1, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false))
        ingredients.append(Ingredient(name: "Romaine", servingSize: 47, calories: 8, fat: 0.14, fiber: 0.99, netcarbs: 0.51, protein: 0.58, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Collared Greens", servingSize: 36, calories: 12, fat: 0.22, fiber: 1.4, netcarbs: 0.6, protein: 1.09, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Broccoli", servingSize: 85, calories: 20, fat: 0, fiber: 3, netcarbs: 1, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Cauliflower", servingSize: 85, calories: 20, fat: 0, fiber: 2, netcarbs: 2, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mushrooms", servingSize: 35, calories: 8, fat: 0.12, fiber: 0.35, netcarbs: 0.75, protein: 1.081, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Radish", servingSize: 58, calories: 9, fat: 0.06, fiber: 0.93, netcarbs: 1.07, protein: 0.39, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Avocado", servingSize: 50, calories: 80, fat: 7, fiber: 3.4, netcarbs: 0.9, protein: 1, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mackerel", servingSize: 85, calories: 180, fat: 11, fiber: 0, netcarbs: 0, protein: 21, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Smoked Sardines", servingSize: 85, calories: 170, fat: 11, fiber: 0, netcarbs: 0, protein: 18, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Sardines", servingSize: 85, calories: 190, fat: 12, fiber: 0, netcarbs: 0, protein: 21, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Tuna", servingSize: 85, calories: 100, fat: 2.5, fiber: 0, netcarbs: 0, protein: 21, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mustard", servingSize: 5, calories: 5, fat: 0, fiber: 0, netcarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 15, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Extra Virgin Olive Oil", servingSize: 14, calories: 120, fat: 14, fiber: 0, netcarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Fish Oil", servingSize: 4.667, calories: 40, fat: 4.5, fiber: 0, netcarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "String Cheese", servingSize: 28, calories: 80, fat: 6, fiber: 0, netcarbs: 0, protein: 7, consumptionUnit: Unit.stick, consumptionGrams: 28, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mini Original Semisoft Cheese", servingSize: 21, calories: 70, fat: 6, fiber: 0, netcarbs: 0, protein: 5, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Macadamia Nuts", servingSize: 30, calories: 220, fat: 23, fiber: 3, netcarbs: 1, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Dark Chocolate (Divine)", servingSize: 42.5, calories: 260, fat: 22, fiber: 6, netcarbs: 10, protein: 4, consumptionUnit: Unit.block, consumptionGrams: 3.54, meat: false))
        ingredients.append(Ingredient(name: "Mint Chocolate Ice Cream", servingSize: 99, calories: 250, fat: 23, fiber: 4, netcarbs: 3, protein: 4, consumptionUnit: Unit.block, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Dry Roasted Peanuts (unsalted)", servingSize: 28, calories: 160, fat: 14, fiber: 2, netcarbs: 4, protein: 7, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
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

    func create(name: String, servingSize: Double, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double, consumptionUnit: Unit, consumptionGrams: Double, meat: Bool, meatAmount: Double, meatAdjustments: [MeatAdjustment], available: Bool, verified: String) {
        let ingredient = Ingredient(name: name, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAmount: meatAmount, meatAdjustments: meatAdjustments, available: available, verified: verified)
        ingredients.append(ingredient)
    }

    func get(includeUnavailable: Bool = false) -> [Ingredient] {
        if includeUnavailable {
            return ingredients.sorted(by: { $0.name < $1.name })
        }
        return ingredients.filter({ $0.available == true }).sorted(by: { $0.name < $1.name })
    }

    func getMeatOptions() -> [String] {
        let meats = ingredients.filter({ $0.meat == true })
        var meatNames: [String] = []
        meatNames.append("None")
        for meat in meats {
            meatNames.append(meat.name)
        }
        return meatNames
    }

    func getPickerOptions(existing: [String]) -> [String] {
        let existingSet = Set(existing)
        var ingredientsSet = Set(ingredients.map { $0.name })
        let meatOptionSet = Set(getMeatOptions())
        ingredientsSet.subtract(existingSet)
        ingredientsSet.subtract(meatOptionSet)
        var pickerOptions = [String](ingredientsSet)
        pickerOptions.sort()
        return pickerOptions
    }

    func getNamesSorted() -> [String] {
        let sorted = ingredients.sorted{ (ing1, ing2) -> Bool in
            return ing1.name < ing2.name
        }
        return sorted.map { $0.name }
    }

    func getIngredient(name: String) -> Ingredient? {
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

struct MeatAdjustment: Codable, Identifiable {
    var id: String

    var name: String
    var amount: Double
    var consumptionUnit: Unit

    init(id: String = UUID().uuidString, name: String, amount: Double, consumptionUnit: Unit) {
        self.id = id
        self.name = name
        self.amount = amount
        self.consumptionUnit = consumptionUnit
    }
}

struct Ingredient: Codable, Identifiable {
    var id: String

    var name: String

    var servingSize: Double
    var calories: Double

    var fat: Double
    var fiber: Double
    var netcarbs: Double
    var protein: Double

    var consumptionUnit: Unit
    var consumptionGrams: Double

    var meat: Bool
    var meatAmount: Double
    var meatAdjustments: [MeatAdjustment]

    var available: Bool

    var verified: String

    var calories100: Double {
        (calories * 100) / servingSize
    }

    var fat100: Double {
        (fat * 100) / servingSize
    }

    var fiber100: Double {
        (fiber * 100) / servingSize
    }

    var netcarbs100: Double {
        (netcarbs * 100) / servingSize
    }

    var protein100: Double {
        (protein * 100) / servingSize
    }

    init(id: String = UUID().uuidString, name: String, servingSize: Double, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double, consumptionUnit: Unit, consumptionGrams: Double, meat: Bool = false, meatAmount: Double = 200, meatAdjustments: [MeatAdjustment] = [], available: Bool = true, verified: String = "") {
        self.id = id

        self.name = name

        self.servingSize = servingSize
        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netcarbs = netcarbs
        self.protein = protein

        self.consumptionUnit = consumptionUnit
        self.consumptionGrams = consumptionGrams

        self.meat = meat
        self.meatAmount = meatAmount
        self.meatAdjustments = meatAdjustments

        self.available = available

        self.verified = verified
    }

    func toggleAvailable() -> Ingredient {
        return Ingredient(id: id, name: name, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAdjustments: meatAdjustments, available: !available, verified: verified)
    }

    func update(ingredient: Ingredient) -> Ingredient {
        return Ingredient(id: ingredient.id, name: ingredient.name, servingSize: ingredient.servingSize, calories: ingredient.calories, fat: ingredient.fat, fiber: ingredient.fiber, netcarbs: ingredient.netcarbs, protein: ingredient.protein, consumptionUnit: ingredient.consumptionUnit, consumptionGrams: ingredient.consumptionGrams, meat: ingredient.meat, meatAmount: ingredient.meatAmount, meatAdjustments: ingredient.meatAdjustments, available: ingredient.available, verified: verified)
    }
}
