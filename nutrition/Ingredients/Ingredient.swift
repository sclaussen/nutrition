import Foundation

class IngredientMgr: ObservableObject {

    @Published var ingredients: [Ingredient] = [] {
        didSet {
            serialize()
        }
    }

    init() {
        ingredients.append(Ingredient(name: "Coconut Oil", servingSize: 14, calories: 130, fat: 14, fiber: 0, netCarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Avocado Oil", servingSize: 14, calories: 120, fat: 14, fiber: 0, netCarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Pumpkin Seeds", servingSize: 28, calories: 160, fat: 14, fiber: 2, netCarbs: 1, protein: 8, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Chicken", servingSize: 100, calories: 115, fat: 2.7, fiber: 0, netCarbs: 0, protein: 22, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 250))
        ingredients.append(Ingredient(name: "Beef", servingSize: 100, calories: 214, fat: 15.2, fiber: 0, netCarbs: 0, protein: 19, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 150,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon),
                                                         MealAdjustment(name: "Collared Greens", amount: 20, consumptionUnit: Unit.gram) ]))
        ingredients.append(Ingredient(name: "Bison", servingSize: 112, calories: 160, fat: 8, fiber: 0, netCarbs: 0, protein: 23, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 150,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon) ]))
        ingredients.append(Ingredient(name: "Lamb", servingSize: 85, calories: 253, fat: 22, fiber: 0, netCarbs: 0.19, protein: 13.09, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 150,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon) ], available: false))
        ingredients.append(Ingredient(name: "Pork Chop", servingSize: 113, calories: 220, fat: 11, fiber: 0, netCarbs: 0, protein: 30, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true,
                                      mealAdjustments: [ MealAdjustment(name: "Eggs", amount: -1, consumptionUnit: Unit.egg),
                                                         MealAdjustment(name: "Extra Virgin Olive Oil", amount: -1, consumptionUnit: Unit.tablespoon) ]))
        ingredients.append(Ingredient(name: "Salmon", servingSize: 112, calories: 150, fat: 5, fiber: 0, netCarbs: 0, protein: 25, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true,
                                      mealAdjustments: [ MealAdjustment(name: "Fish Oil", amount: -1, consumptionUnit: Unit.tablespoon) ]))
        ingredients.append(Ingredient(name: "Top Sirloin Cap", servingSize: 238, calories: 125, fat: 14, fiber: 0, netCarbs: 0, protein: 51, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, available: false))
        ingredients.append(Ingredient(name: "Argentine Red Shrimp", servingSize: 110, calories: 100, fat: 1.5, fiber: 0, netCarbs: 0, protein: 21, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: true, meatAmount: 250, available: false))
        ingredients.append(Ingredient(name: "Eggs", servingSize: 50, calories: 70, fat: 5, fiber: 0, netCarbs: 0, protein: 6, consumptionUnit: Unit.egg, consumptionGrams: 50, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Serrano Pepper", servingSize: 6.1, calories: 2, fat: 0.03, fiber: 0.23, netCarbs: 0.18, protein: 0.11, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Jalapeno Pepper", servingSize: 14, calories: 4, fat: 0.05, fiber: 0.39, netCarbs: 0.52, protein: 0.13, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, available: false))
        ingredients.append(Ingredient(name: "Salsa", servingSize: 30, calories: 10, fat: 0, fiber: 1, netCarbs: 0, protein: 1, consumptionUnit: Unit.tablespoon, consumptionGrams: 15, meat: false, available: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Arugula", servingSize: 20, calories: 5, fat: 0.13, fiber: 0.32, netCarbs: 0.41, protein: 0.52, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "No nutrition on whole foods site"))
        ingredients.append(Ingredient(name: "Spinach", servingSize: 85, calories: 25, fat: 0.25, fiber: 2, netCarbs: 1, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false))
        ingredients.append(Ingredient(name: "Romaine", servingSize: 47, calories: 8, fat: 0.14, fiber: 0.99, netCarbs: 0.51, protein: 0.58, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Collared Greens", servingSize: 36, calories: 12, fat: 0.22, fiber: 1.4, netCarbs: 0.6, protein: 1.09, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Broccoli", servingSize: 85, calories: 20, fat: 0, fiber: 3, netCarbs: 1, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Cauliflower", servingSize: 85, calories: 20, fat: 0, fiber: 2, netCarbs: 2, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mushrooms", servingSize: 35, calories: 8, fat: 0.12, fiber: 0.35, netCarbs: 0.75, protein: 1.081, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Radish", servingSize: 58, calories: 9, fat: 0.06, fiber: 0.93, netCarbs: 1.07, protein: 0.39, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Avocado", servingSize: 50, calories: 80, fat: 7, fiber: 3.4, netCarbs: 0.9, protein: 1, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mackerel", servingSize: 85, calories: 180, fat: 11, fiber: 0, netCarbs: 0, protein: 21, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Smoked Sardines", servingSize: 85, calories: 170, fat: 11, fiber: 0, netCarbs: 0, protein: 18, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Sardines", servingSize: 85, calories: 190, fat: 12, fiber: 0, netCarbs: 0, protein: 21, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Tuna", servingSize: 85, calories: 100, fat: 2.5, fiber: 0, netCarbs: 0, protein: 21, consumptionUnit: Unit.can, consumptionGrams: 85, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mustard", servingSize: 5, calories: 5, fat: 0, fiber: 0, netCarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 15, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Extra Virgin Olive Oil", servingSize: 14, calories: 120, fat: 14, fiber: 0, netCarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Fish Oil", servingSize: 4.667, calories: 40, fat: 4.5, fiber: 0, netCarbs: 0, protein: 0, consumptionUnit: Unit.tablespoon, consumptionGrams: 14, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "String Cheese", servingSize: 28, calories: 80, fat: 6, fiber: 0, netCarbs: 0, protein: 7, consumptionUnit: Unit.stick, consumptionGrams: 28, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Dubliner Cheese", servingSize: 28, calories: 110, fat: 9, fiber: 0, netCarbs: 0, protein: 7, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Cheddar Cheese", servingSize: 28, calories: 110, fat: 9, fiber: 0, netCarbs: 1, protein: 7, consumptionUnit: Unit.slice, consumptionGrams: 9.33, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Keto Bite (Mint)", servingSize: 25, calories: 140, fat: 12, fiber: 4, netCarbs: 1, protein: 6, consumptionUnit: Unit.whole, consumptionGrams: 9.33, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Keto Bite (Macadamia)", servingSize: 25, calories: 140, fat: 11, fiber: 6, netCarbs: 0, protein: 6, consumptionUnit: Unit.whole, consumptionGrams: 9.33, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Mini Original Semisoft Cheese", servingSize: 21, calories: 70, fat: 6, fiber: 0, netCarbs: 0, protein: 5, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Macadamia Nuts", servingSize: 30, calories: 220, fat: 23, fiber: 3, netCarbs: 1, protein: 2, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Dark Chocolate (Divine)", servingSize: 28, calories: 180, fat: 14, fiber: 4, netCarbs: 6, protein: 3, consumptionUnit: Unit.piece, consumptionGrams: 3.5, meat: false))
        ingredients.append(Ingredient(name: "Keto Mint Ice Cream", servingSize: 99, calories: 250, fat: 23, fiber: 4, netCarbs: 3, protein: 4, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
        ingredients.append(Ingredient(name: "Dry Roasted Peanuts (unsalted)", servingSize: 28, calories: 160, fat: 14, fiber: 2, netCarbs: 4, protein: 7, consumptionUnit: Unit.gram, consumptionGrams: 1, meat: false, verified: "3/16/22"))
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
                productBrand: String = "",
                productCost: Double = 0,
                productGrams:Double = 0,
                servingSize: Double,
                calories: Double,
                fat: Double,
                fiber: Double,
                netCarbs: Double,
                protein: Double,
                consumptionUnit: Unit,
                consumptionGrams: Double,
                meat: Bool,
                meatAmount: Double,
                mealAdjustments: [MealAdjustment],
                omega3: Double = 0,
                vitaminD: Double = 0,
                calcium: Double = 0,
                iron: Double = 0,
                potassium: Double = 0,
                vitaminA: Double = 0,
                vitaminC: Double = 0,
                vitaminE: Double = 0,
                vitaminK: Double = 0,
                thiamin: Double = 0,
                niacin: Double = 0,
                vitaminB6: Double = 0,
                folate: Double = 0,
                vitaminB12: Double = 0,
                pantothenicAcid: Double = 0,
                phosphorus: Double = 0,
                magnesium: Double = 0,
                zinc: Double = 0,
                selenium: Double = 0,
                copper: Double = 0,
                manganese: Double = 0,
                available: Bool,
                verified: String) {
        let ingredient = Ingredient(name: name,
                                    productBrand: productBrand,
                                    productCost: productCost,
                                    productGrams: productGrams,
                                    servingSize: servingSize,
                                    calories: calories,
                                    fat: fat,
                                    fiber: fiber,
                                    netCarbs: netCarbs,
                                    protein: protein,
                                    consumptionUnit: consumptionUnit,
                                    consumptionGrams: consumptionGrams,
                                    meat: meat,
                                    meatAmount: meatAmount,
                                    mealAdjustments: mealAdjustments,
                                    omega3: omega3,
                                    vitaminD: vitaminD,
                                    calcium: calcium,
                                    iron: iron,
                                    potassium: potassium,
                                    vitaminA: vitaminA,
                                    vitaminC: vitaminC,
                                    vitaminE: vitaminE,
                                    vitaminK: vitaminK,
                                    thiamin: thiamin,
                                    niacin: niacin,
                                    vitaminB6: vitaminB6,
                                    folate: folate,
                                    vitaminB12: vitaminB12,
                                    pantothenicAcid: pantothenicAcid,
                                    phosphorus: phosphorus,
                                    magnesium: magnesium,
                                    zinc: zinc,
                                    selenium: selenium,
                                    copper: copper,
                                    manganese: manganese,
                                    available: available,
                                    verified: verified)
        ingredients.append(ingredient)
    }

    func get(includeUnavailable: Bool = false) -> [Ingredient] {
        if includeUnavailable {
            return ingredients.sorted(by: { $0.name < $1.name })
        }
        return ingredients.filter({ $0.available == true }).sorted(by: { $0.name < $1.name })
    }

    func getAllMeatNames() -> [String] {
        let meats = ingredients.filter({ $0.meat == true })
        var meatNames: [String] = []
        meatNames.append("None")
        for meat in meats {
            meatNames.append(meat.name)
        }
        return meatNames
    }

    func getNewMeatNames(existing: [String]) -> [String] {
        let existingSet = Set(existing)
        var ingredientsSet = Set(ingredients.map { $0.name })
        let meatOptionSet = Set(getAllMeatNames())
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

    var productBrand: String
    var productCost: Double
    var productGrams: Double

    var servingSize: Double
    var calories: Double

    var fat: Double
    var fiber: Double
    var netCarbs: Double
    var protein: Double

    var consumptionUnit: Unit
    var consumptionGrams: Double

    var meat: Bool
    var meatAmount: Double
    var mealAdjustments: [MealAdjustment]

    var available: Bool

    var verified: String

    var omega3: Double
    var vitaminD: Double
    var calcium: Double
    var iron: Double
    var potassium: Double
    var vitaminA: Double
    var vitaminC: Double
    var vitaminE: Double
    var vitaminK: Double
    var thiamin: Double
    var niacin: Double
    var vitaminB6: Double
    var folate: Double
    var vitaminB12: Double
    var pantothenicAcid: Double
    var phosphorus: Double
    var magnesium: Double
    var zinc: Double
    var selenium: Double
    var copper: Double
    var manganese: Double

    init(id: String = UUID().uuidString,
         name: String,
         productBrand: String = "",
         productCost: Double = 0,
         productGrams: Double = 0,
         servingSize: Double,
         calories: Double,
         fat: Double,
         fiber: Double,
         netCarbs: Double,
         protein: Double,
         consumptionUnit: Unit = Unit.gram,
         consumptionGrams: Double,
         meat: Bool = false,
         meatAmount: Double = 200,
         mealAdjustments: [MealAdjustment] = [],
         omega3: Double = 0,
         vitaminD: Double = 0,
         calcium: Double = 0,
         iron: Double = 0,
         potassium: Double = 0,
         vitaminA: Double = 0,
         vitaminC: Double = 0,
         vitaminE: Double = 0,
         vitaminK: Double = 0,
         thiamin: Double = 0,
         niacin: Double = 0,
         vitaminB6: Double = 0,
         folate: Double = 0,
         vitaminB12: Double = 0,
         pantothenicAcid: Double = 0,
         phosphorus: Double = 0,
         magnesium: Double = 0,
         zinc: Double = 0,
         selenium: Double = 0,
         copper: Double = 0,
         manganese: Double = 0,
         available: Bool = true,
         verified: String = "") {

        self.id = id

        self.name = name

        self.productBrand = productBrand
        self.productCost = productCost
        self.productGrams = productGrams

        self.servingSize = servingSize
        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netCarbs = netCarbs
        self.protein = protein

        self.consumptionUnit = consumptionUnit
        self.consumptionGrams = consumptionGrams

        self.meat = meat
        self.meatAmount = meatAmount
        self.mealAdjustments = mealAdjustments

        self.omega3 = omega3
        self.vitaminD = vitaminD
        self.calcium = calcium
        self.iron = iron
        self.potassium = potassium
        self.vitaminA = vitaminA
        self.vitaminC = vitaminC
        self.vitaminE = vitaminE
        self.vitaminK = vitaminK
        self.thiamin = thiamin
        self.niacin = niacin
        self.vitaminB6 = vitaminB6
        self.folate = folate
        self.vitaminB12 = vitaminB12
        self.pantothenicAcid = pantothenicAcid
        self.phosphorus = phosphorus
        self.magnesium = magnesium
        self.zinc = zinc
        self.selenium = selenium
        self.copper = copper
        self.manganese = manganese

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
                          productBrand: productBrand,
                          productCost: productCost,
                          productGrams: productGrams,
                          servingSize: servingSize,
                          calories: calories,
                          fat: fat,
                          fiber: fiber,
                          netCarbs: netCarbs,
                          protein: protein,
                          consumptionUnit: consumptionUnit,
                          consumptionGrams: consumptionGrams,
                          meat: meat,
                          mealAdjustments: mealAdjustments,
                          omega3: omega3,
                          vitaminD: vitaminD,
                          calcium: calcium,
                          iron: iron,
                          potassium: potassium,
                          vitaminA: vitaminA,
                          vitaminC: vitaminC,
                          vitaminE: vitaminE,
                          vitaminK: vitaminK,
                          thiamin: thiamin,
                          niacin: niacin,
                          vitaminB6: vitaminB6,
                          folate: folate,
                          vitaminB12: vitaminB12,
                          pantothenicAcid: pantothenicAcid,
                          phosphorus: phosphorus,
                          magnesium: magnesium,
                          zinc: zinc,
                          selenium: selenium,
                          copper: copper,
                          manganese: manganese,
                          available: !available,
                          verified: verified)
    }

    func update(ingredient: Ingredient) -> Ingredient {
        return Ingredient(id: ingredient.id,
                          name: ingredient.name,
                          productBrand: ingredient.productBrand,
                          productCost: ingredient.productCost,
                          productGrams: ingredient.productGrams,
                          servingSize: ingredient.servingSize,
                          calories: ingredient.calories,
                          fat: ingredient.fat,
                          fiber: ingredient.fiber,
                          netCarbs: ingredient.netCarbs,
                          protein: ingredient.protein,
                          consumptionUnit: ingredient.consumptionUnit,
                          consumptionGrams: ingredient.consumptionGrams,
                          meat: ingredient.meat,
                          meatAmount: ingredient.meatAmount,
                          mealAdjustments: ingredient.mealAdjustments,
                          omega3: ingredient.omega3,
                          vitaminD: ingredient.vitaminD,
                          calcium: ingredient.calcium,
                          iron: ingredient.iron,
                          potassium: ingredient.potassium,
                          vitaminA: ingredient.vitaminA,
                          vitaminC: ingredient.vitaminC,
                          vitaminE: ingredient.vitaminE,
                          vitaminK: ingredient.vitaminK,
                          thiamin: ingredient.thiamin,
                          niacin: ingredient.niacin,
                          vitaminB6: ingredient.vitaminB6,
                          folate: ingredient.folate,
                          vitaminB12: ingredient.vitaminB12,
                          pantothenicAcid: ingredient.pantothenicAcid,
                          phosphorus: ingredient.phosphorus,
                          magnesium: ingredient.magnesium,
                          zinc: ingredient.zinc,
                          selenium: ingredient.selenium,
                          copper: ingredient.copper,
                          manganese: ingredient.manganese,
                          available: ingredient.available,
                          verified: verified)
    }
}
