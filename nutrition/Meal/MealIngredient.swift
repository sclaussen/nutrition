import Foundation


enum Constants {
    static let Default: Int = 1

    static let Manual: Int = 2
    static let Automatic: Int = 3

    static let Ingredient: Int = 2
    static let Inactive: Int = 3
    static let Active: Int = 4
}


class MealIngredientMgr: ObservableObject {


    @Published var mealIngredients: [MealIngredient] = [] {
        didSet {
            serialize()
        }
    }


    init() {
        resetMealIngredients()
    }


    func serialize() {
        if let encodedData = try? JSONEncoder().encode(mealIngredients) {
            UserDefaults.standard.set(encodedData, forKey: "mealIngredient")
        }
    }


    func deserialize() {
        guard
          let data = UserDefaults.standard.data(forKey: "mealIngredient"),
          let savedItems = try? JSONDecoder().decode([MealIngredient].self, from: data)
        else {
            return
        }

        self.mealIngredients = savedItems
    }


    func resetMealIngredients() {
        print("RESETTING Meal Ingredients")

        mealIngredients = []

        mealIngredients.append(MealIngredient(name: "Coconut Oil", amount: 1))

        mealIngredients.append(MealIngredient(name: "Mackerel", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sardines", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Smoked Sardines", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "String Cheese", amount: 1, active: false))

        mealIngredients.append(MealIngredient(name: "Eggs", amount: 5))
        mealIngredients.append(MealIngredient(name: "Broccoli", amount: 200))
        mealIngredients.append(MealIngredient(name: "Cauliflower", amount: 100))
        mealIngredients.append(MealIngredient(name: "Arugula", amount: 75))
        mealIngredients.append(MealIngredient(name: "Spinach", amount: 75))
        mealIngredients.append(MealIngredient(name: "Romaine", amount: 500))
        mealIngredients.append(MealIngredient(name: "Pumpkin Seeds", amount: 10))
        mealIngredients.append(MealIngredient(name: "Mushrooms", amount: 100))
        mealIngredients.append(MealIngredient(name: "Radish", amount: 100))
        mealIngredients.append(MealIngredient(name: "Avocado", amount: 145))
        mealIngredients.append(MealIngredient(name: "Mustard", amount: 4))
        mealIngredients.append(MealIngredient(name: "Fish Oil", amount: 1))
        mealIngredients.append(MealIngredient(name: "Extra Virgin Olive Oil", amount: 3))

        mealIngredients.append(MealIngredient(name: "Pecans", amount: 20, active: false))
        mealIngredients.append(MealIngredient(name: "Walnuts", amount: 20, active: false))
        mealIngredients.append(MealIngredient(name: "Peanuts", amount: 20, active: false))
        mealIngredients.append(MealIngredient(name: "Macadamia Nuts", amount: 20, active: false))
        mealIngredients.append(MealIngredient(name: "Flackers (SS)", amount: 30, active: false))
        mealIngredients.append(MealIngredient(name: "Cheddar Cheese", amount: 1, active: false))
        // mealIngredients.append(MealIngredient(name: "Dubliner Cheese", amount: 30, active: false))
        // mealIngredients.append(MealIngredient(name: "Emmi Roth", amount: 30, active: false))
    }


    // Create a new meal ingredient and add it to the meal ingredients list.
    // Consumer is the Meal Add dialog.
    func create(name: String,
                amount: Double,
                meat: Bool = false,
                adjustment: Int = Constants.Default,
                priorState: Int = Constants.Active,
                active: Bool = true) {

        let mealIngredient = MealIngredient(name: name,
                                            amount: amount,
                                            meat: meat,
                                            adjustment: adjustment,
                                            priorState: priorState,
                                            active: active)

        mealIngredients.append(mealIngredient)
    }


    func manualAdjustment(name: String, amount: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].manualAdjustment(amount: amount)
            return
        }

        print("  Creating " + name + " \(amount)")
        create(name: name, amount: amount, adjustment: Constants.Manual, priorState: Constants.Ingredient)
    }


    func undoManualAdjustment(name: String) {
        print("Undo Manual Adjustment for \(name)")
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            if mealIngredients[index].adjustment == Constants.Manual {
                if mealIngredients[index].priorState == Constants.Ingredient {
                    print("  - deleting the auto-added/auto-adjusted meal ingredient: \(mealIngredients[index].name)")
                    delete(mealIngredients[index])
                    return
                }

                mealIngredients[index] = mealIngredients[index].undoAdjustment()
            }
        }
    }


    // Handles 4 cases (3 by automaticAdjustment() and one by create()):
    // 1a. meal ingredient exists, not active
    // 1b. meal ingredient exists, active, not previosuly adjusted
    // 1c. meal ingredient exists, active, previosuly adjusted
    // 2.  meal ingredient does not exist
    func automaticAdjustment(name: String, amount: Double) {

        // if let index = mealIngredients.firstIndex(where: { $0.name == name && !$0.active }) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].automaticAdjustment(amount: amount)
            return
        }

        print("  Creating " + name + " \(amount)")
        create(name: name, amount: amount, adjustment: Constants.Manual, priorState: Constants.Ingredient)
    }


    func undoAutoAdjustments() {

        // Go through each meal ingredient that was auto adjusted
        print("Removing Auto Adjustments")
        for mealIngredient in mealIngredients.filter({ $0.adjustment == Constants.Automatic }) {

            // A meal ingredient may be in the meal adjustments list
            // that was not initially a meal ingredient and it needed
            // to be applied via the auto adjustment algorithm.  In
            // that case the meal ingredient would have been created
            // from the ingredient and activated.  In that case,
            // delete the meal ingredient to reverse the adjustment.
            if mealIngredient.priorState == Constants.Ingredient {
                print("  - deleting the auto-added/auto-adjusted meal ingredient: \(mealIngredient)")
                delete(mealIngredient)
                continue
            }

            // SWIFT NUANCE: In order to update an object, we must
            // create a copy of the original object, update the copy,
            // and then replace the original object in the array with
            // the new object.
            if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
                mealIngredients[index] = mealIngredients[index].undoAdjustment()
            }
        }
    }


    func reapplyMeat(name: String, amount: Double) {
        // If there is an existing meat and amount, remove it
        if let index = mealIngredients.firstIndex(where: { $0.meat == true }) {
            print("  Removing: \(mealIngredients[index].name) amount \(mealIngredients[index].amount)")
            mealIngredients.remove(at: index)
        }

        if name != "None" {
            print("  Adding: \(name) amount \(amount)")
            create(name: name, amount: amount, meat: true)
        }
    }


    // Get the meal ingredient by name
    func getByName(name: String) -> MealIngredient? {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            return mealIngredients[index]
        }

        return nil
    }


    // By default, return an array of all the active meal ingredients.
    //
    // If "includeInactive" is true return both the active and
    // inactive meal ingredients.
    func getActive(includeInactive: Bool = false) -> [MealIngredient] {
        if includeInactive {
            return mealIngredients
        }
        return mealIngredients.filter({ $0.active == true })
    }


    // Return all the meal ingredient names
    func getNames() -> [String] {
        return mealIngredients.map { $0.name }
    }


    func update(_ mealIngredient: MealIngredient) {
        if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
            mealIngredients[index] = mealIngredient.update(mealIngredient: mealIngredient)
        }
    }


    func toggleActive(_ mealIngredient: MealIngredient) -> MealIngredient? {
        if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
            mealIngredients[index] = mealIngredient.toggleActive()
            return mealIngredients[index]
        }
        return nil
    }


    // Explicity activate the meal ingredient
    // Invoked from IngredientList.swift when the ingredient is toggled to Available
    func activate(_ name: String) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            if !mealIngredients[index].active {
                mealIngredients[index] = mealIngredients[index].toggleActive()
            }
            print("  \(mealIngredients[index].name) active: \(mealIngredients[index].active) (mealIngredient)")
        }
    }


    // Explicity deactivate the meal ingredient
    // Invoked from IngredientList.swift when the ingredient is toggled to Unavailable
    func deactivate(_ name: String) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            if mealIngredients[index].active {
                mealIngredients[index] = mealIngredients[index].toggleActive()
            }
            print("  \(mealIngredients[index].name) active: \(mealIngredients[index].active) (mealIngredient)")
        }
    }


    func inactiveIngredientsExist() -> Bool {
        let inactiveIngredients = mealIngredients.filter({ $0.active == false })
        return inactiveIngredients.count > 0
    }


    func setMacroActuals(name: String, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].setMacroActuals(calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
        }
    }


    func setMacroActualsToZero() {
        for index in stride(from: 0, through: mealIngredients.count - 1, by: 1) {
            mealIngredients[index] = mealIngredients[index].setMacroActualsToZero()
        }
    }


    func move(from: IndexSet, to: Int) {
        mealIngredients.move(fromOffsets: from, toOffset: to)
    }


    func deleteSet(indexSet: IndexSet) {
        mealIngredients.remove(atOffsets: indexSet)
    }


    func delete(_ mealIngredient: MealIngredient) {
        if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
            print("  Removed: " + mealIngredients[index].name + " \(mealIngredients[index].amount)")
            mealIngredients.remove(at: index)
        }
    }


    func p() {
        for mealIngredient in getActive() {
            print(mealIngredient.name + " \(mealIngredient.amount) \(mealIngredient.adjustment)")
        }
    }


    //    func resetAmountAll() {
//        for mealIngredient in mealIngredients {
//            if let index = mealIngredients.firstIndex(where: { $0.name == mealIngredient.name }) {
//                mealIngredients[index] = mealIngredients[index].resetAmountToDefaultAmount()
//            }
//        }
//    }
}


struct MealIngredient: Codable, Identifiable {
    var id: String

    var name: String

    var originalAmount: Double
    var amount: Double

    var meat: Bool

    var calories: Double
    var fat: Double
    var fiber: Double
    var netcarbs: Double
    var protein: Double

    var adjustment: Int
    var priorState: Int

    var active: Bool


    init(id: String = UUID().uuidString,
         name: String,
         originalAmount: Double = 0,
         amount: Double,
         meat: Bool = false,
         calories: Double = 0,
         fat: Double = 0,
         fiber: Double = 0,
         netcarbs: Double = 0,
         protein: Double = 0,
         adjustment: Int = Constants.Default,
         priorState: Int = Constants.Active,
         active: Bool = true) {

        self.id = id

        self.name = name

        if originalAmount == 0 {
            self.originalAmount = amount
        } else {
            self.originalAmount = originalAmount
        }
        self.amount = amount

        self.meat = meat

        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netcarbs = netcarbs
        self.protein = protein

        self.adjustment = adjustment
        self.priorState = priorState

        self.active = active
    }


    func toggleActive() -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment, priorState: priorState, active: !active);
    }


    func setMacroActualsToZero() -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: 0, fat: 0, fiber: 0, netcarbs: 0, protein: 0, adjustment: adjustment, priorState: priorState, active: active);
    }


    func setMacroActuals(calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: self.calories + calories, fat: self.fat + fat, fiber: self.fiber + fiber, netcarbs: self.netcarbs + netcarbs, protein: self.protein + protein, adjustment: adjustment, priorState: priorState, active: active);
    }


    func manualAdjustment(amount: Double) -> MealIngredient {
        if adjustment == Constants.Automatic {
            undoAdjustment()
        }

        // adjustment: Manual
        // amount: amount
        // priorState: self.active
        // active: true
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Manual, priorState: self.active ? Constants.Active : Constants.Inactive, active: true);
    }


    // Adjust the meal ingredient's amount saving the original value
    // for active and amount to allow the auto adjustment to be
    // removed later.
    func automaticAdjustment(amount: Double) -> MealIngredient {

        if adjustment == Constants.Manual {
            print("  Attempted an automatic adjustment but the meal ingredient has been manually adjusted: \(name)")
            return self
        }

        if adjustment == Constants.Default && !active {
            // adjustment: Automatic
            // amount: += amount
            // priorState: self.active
            // active: true
            print("  Automatic adjustment of \(self.name) to \(amount) (and activating ingredient) (original amount \(originalAmount))")
            return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Automatic, priorState: self.active ? Constants.Active : Constants.Inactive, active: true)
        }

        if adjustment == Constants.Default && active {
            // adjustment: Automatic
            // amount: += amount
            // priorState: self.active
            // active: true
            print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (initial adjustment) (original amount \(originalAmount))")
            return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: self.amount + amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Automatic, priorState: self.active ? Constants.Active : Constants.Inactive, active: true)
        }

        print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (delta adjustment) (original amount \(originalAmount))")
        // amount: += amount
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: self.amount + amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: self.adjustment, priorState: self.priorState, active: self.active)
    }


    // Remove the adjustment to a meal ingredient.
    func undoAdjustment() -> MealIngredient {
        print("  Undoing \(name) current amount: \(amount) to original amount \(originalAmount)")
        // amount: self.originalAmount
        // adjustment: Default
        // priorState: Default
        // active: self.priorState
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: self.originalAmount, meat: self.meat, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: Constants.Default, priorState: Constants.Default, active: self.priorState == Constants.Active)
    }


    func update(mealIngredient: MealIngredient) -> MealIngredient {
        print("  Update \(mealIngredient.name)")
        return MealIngredient(id: mealIngredient.id, name: mealIngredient.name, originalAmount: mealIngredient.originalAmount, amount: mealIngredient.amount, meat: mealIngredient.meat, calories: mealIngredient.calories, fat: mealIngredient.fat, fiber: mealIngredient.fiber, netcarbs: mealIngredient.netcarbs, protein: mealIngredient.protein, adjustment: mealIngredient.adjustment, priorState: mealIngredient.priorState, active: mealIngredient.active);
    }
}
