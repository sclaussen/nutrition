import Foundation

class MealIngredient: Identifiable {
    var id: String = UUID().uuidString

    var name: String
    var amount: Double
    var consumptionUnit: Unit

    var calories: Double = 0
    var fat: Double = 0
    var fiber: Double = 0
    var netcarbs: Double = 0
    var protein: Double = 0

    var adjustment: Bool = false

    init(name: String, amount: Double, consumptionUnit: Unit, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double, adjustment: Bool) {
        self.name = name
        self.amount = amount
        self.consumptionUnit = consumptionUnit
        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netcarbs = netcarbs
        self.protein = protein
        self.adjustment = adjustment
    }

    func update(amount: Double, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double, adjustment: Bool) {
        self.amount += amount
        self.calories += calories
        self.fat += fat
        self.fiber += fiber
        self.netcarbs += netcarbs
        self.protein += protein
        self.adjustment = adjustment
    }
}

class Meal: Identifiable {
    var id: String = UUID().uuidString

    var mealIngredients: [MealIngredient] = []

    var caloriesGoalUnadjusted: Double = 0

    var caloriesGoal: Double = 0
    var fatGoal: Double = 0
    var fiberGoal: Double = 0
    var netcarbsGoal: Double = 0
    var proteinGoal: Double = 0

    var calories: Double = 0
    var fat: Double = 0
    var fiber: Double = 0
    var netcarbs: Double = 0
    var protein: Double = 0

    func setMacroGoals(caloriesGoalUnadjusted: Double, caloriesGoal: Double, fatGoal: Double, fiberGoal: Double, netcarbsGoal: Double, proteinGoal: Double) {
        self.caloriesGoalUnadjusted = caloriesGoalUnadjusted
        self.caloriesGoal = caloriesGoal
        self.fatGoal = fatGoal
        self.fiberGoal = fiberGoal
        self.netcarbsGoal = netcarbsGoal
        self.proteinGoal = proteinGoal
    }

    func addOrUpdateMealIngredient(name: String, amount: Double, consumptionUnit: Unit, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double, adjustment: Bool) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            let mealIngredient: MealIngredient = mealIngredients[index]
            mealIngredient.update(amount: amount, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment)
            print("Updating ingredient: " + name + " " + String(amount) + " " + mealIngredient.consumptionUnit.singular)
            if mealIngredient.amount <= 0 {
                delete(mealIngredient)
            }
        } else {
            let mealIngredient: MealIngredient = MealIngredient(name: name, amount: amount, consumptionUnit: consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment)
            mealIngredients.append(mealIngredient)
            print("Creating ingredient: " + name + " " + String(amount) + " " + mealIngredient.consumptionUnit.singular)
        }

        self.calories += calories
        self.fat += fat
        self.fiber += fiber
        self.netcarbs += netcarbs
        self.protein += protein

    }

    func delete(_ mealIngredient: MealIngredient) {
        if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
            mealIngredients.remove(at: index)
        }
    }

    func getMealIngredient(name: String) -> MealIngredient? {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            return mealIngredients[index]
        }

        return nil
    }

    func p() {
        print("calories (goal): " + String(caloriesGoal))
        print("fat (goal): " + String(fatGoal))
        print("fiber (goal): " + String(fiberGoal))
        print("netcarbs (goal): " + String(netcarbsGoal))
        print("protein (goal): " + String(proteinGoal))

        print("calories: " + String(calories))
        print("fat: " + String(fat))
        print("fiber: " + String(fiber))
        print("netcarbs: " + String(netcarbs))
        print("protein: " + String(protein))

        for mealIngredient in mealIngredients {
            print(mealIngredient.name + ": " + String(mealIngredient.amount) + " " + mealIngredient.consumptionUnit.singular)
        }
    }
}
