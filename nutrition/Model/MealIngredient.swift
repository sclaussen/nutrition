import Foundation

class MealIngredientMgr: ObservableObject {

    @Published var mealIngredients: [MealIngredient] = [] {
        didSet {
            serialize()
        }
    }

    init() {
        mealIngredients.append(MealIngredient(name: "Coconut Oil", defaultAmount: 1, amount: 1, consumptionUnit: Unit.tablespoon))
        mealIngredients.append(MealIngredient(name: "Serrano Pepper", defaultAmount: 70, amount: 70, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Mackerel", defaultAmount: 1, amount: 1, consumptionUnit: Unit.can, active: false))
        mealIngredients.append(MealIngredient(name: "Sardines", defaultAmount: 1, amount: 1, consumptionUnit: Unit.can, active: false))
        mealIngredients.append(MealIngredient(name: "Smoked Sardines", defaultAmount: 1, amount: 1, consumptionUnit: Unit.can, active: false))
        mealIngredients.append(MealIngredient(name: "Eggs", defaultAmount: 5, amount: 5, consumptionUnit: Unit.egg))
        mealIngredients.append(MealIngredient(name: "Broccoli", defaultAmount: 60, amount: 60, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Cauliflower", defaultAmount: 60, amount: 60, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Arugula", defaultAmount: 145, amount: 145, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Romaine", defaultAmount: 300, amount: 300, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Collared Greens", defaultAmount: 50, amount: 50, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Mushrooms", defaultAmount: 100, amount: 100, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Radish", defaultAmount: 100, amount: 100, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Avocado", defaultAmount: 140, amount: 140, consumptionUnit: Unit.gram))
        mealIngredients.append(MealIngredient(name: "Mustard", defaultAmount: 4, amount: 4, consumptionUnit: Unit.tablespoon))
        mealIngredients.append(MealIngredient(name: "Fish Oil", defaultAmount: 1, amount: 1, consumptionUnit: Unit.tablespoon))
        mealIngredients.append(MealIngredient(name: "Extra Virgin Olive Oil", defaultAmount: 3.5, amount: 3.5, consumptionUnit: Unit.tablespoon))

        mealIngredients.append(MealIngredient(name: "String Cheese", defaultAmount: 1, amount: 1, consumptionUnit: Unit.stick, active: false))
        mealIngredients.append(MealIngredient(name: "Cheddar Cheese", defaultAmount: 1, amount: 1, consumptionUnit: Unit.slice, active: false))
        mealIngredients.append(MealIngredient(name: "Dubliner Cheese", defaultAmount: 1, amount: 1, consumptionUnit: Unit.slice, active: false))
        mealIngredients.append(MealIngredient(name: "Macadamia Nuts", defaultAmount: 1, amount: 1, consumptionUnit: Unit.gram, active: false))
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

    func create(name: String,
                defaultAmount: Double,
                amount: Double,
                consumptionUnit: Unit,
                compensationExists: Bool = false,
                compensationCreated: Bool = false,
                compensationInitialAmount: Double = 0,
                compensationInitialState: Bool = true) {

        let mealIngredient = MealIngredient(name: name,
                                            defaultAmount: defaultAmount,
                                            amount: amount,
                                            consumptionUnit: consumptionUnit,
                                            compensationExists: compensationExists,
                                            compensationCreated: compensationCreated,
                                            compensationInitialAmount: compensationInitialAmount,
                                            compensationInitialState: compensationInitialState)

        mealIngredients.append(mealIngredient)
    }

    func get(includeInactive: Bool = false) -> [MealIngredient] {
        if includeInactive {
            return mealIngredients
        }
        return mealIngredients.filter({ $0.active == true })
    }

    func getIngredient(name: String) -> MealIngredient? {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            return mealIngredients[index]
        }

        return nil
    }

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

    func activate(_ name: String) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            if !mealIngredients[index].active {
                mealIngredients[index] = mealIngredients[index].toggleActive()
            }
            print("  \(mealIngredients[index].name) active: \(mealIngredients[index].active) (mealIngredient)")
        }
    }

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

    func addMacros(name: String, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].addMacros(calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
        }
    }

    func adjust(name: String, amount: Double, consumptionUnit: Unit) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name && !$0.active }) {
            mealIngredients[index] = mealIngredients[index].adjust(amount: amount, active: false)
        } else if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].adjust(amount: amount)
        } else {
            print("  Creating " + name + " \(amount)")
            create(name: name, defaultAmount: amount, amount: amount, consumptionUnit: consumptionUnit, compensationExists: true, compensationCreated: true)
        }
    }

    func resetAmount(name: String) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].resetAmount()
        }
    }

    func resetMacros() {
        for index in stride(from: 0, through: mealIngredients.count - 1, by: 1) {
            mealIngredients[index] = mealIngredients[index].resetMacros()
        }
    }

    func rollbackAll() {
        for mealIngredient in mealIngredients.filter({ $0.compensationExists }) {
            if mealIngredient.compensationCreated {
                delete(mealIngredient)
                continue
            }

            rollback(mealIngredient)
        }
    }

    func rollback(_ mealIngredient: MealIngredient) {
        if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
            mealIngredients[index] = mealIngredients[index].rollback()
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
        for mealIngredient in get() {
            print(mealIngredient.name + " \(mealIngredient.amount) \(mealIngredient.compensationExists)")
        }
    }
}

struct MealIngredient: Codable, Identifiable {
    var id: String

    var name: String

    var defaultAmount: Double
    var amount: Double
    var consumptionUnit: Unit

    var calories: Double
    var fat: Double
    var fiber: Double
    var netcarbs: Double
    var protein: Double

    var compensationExists: Bool
    var compensationCreated: Bool
    var compensationInitialAmount: Double
    var compensationInitialState: Bool

    var active: Bool

    init(id: String = UUID().uuidString,
         name: String,
         defaultAmount: Double,
         amount: Double,
         consumptionUnit: Unit = Unit.gram,
         calories: Double = 0,
         fat: Double = 0,
         fiber: Double = 0,
         netcarbs: Double = 0,
         protein: Double = 0,
         compensationExists: Bool = false,
         compensationCreated: Bool = false,
         compensationInitialAmount: Double = 0,
         compensationInitialState: Bool = true,
         active: Bool = true) {

        self.id = id

        self.name = name

        self.defaultAmount = defaultAmount
        self.amount = amount
        self.consumptionUnit = consumptionUnit

        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netcarbs = netcarbs
        self.protein = protein

        self.compensationExists = compensationExists
        self.compensationCreated = compensationCreated
        self.compensationInitialAmount = compensationInitialAmount
        self.compensationInitialState = compensationInitialState

        self.active = active
    }

    func toggleActive() -> MealIngredient {
        return MealIngredient(id: id, name: name, defaultAmount: defaultAmount, amount: amount, consumptionUnit: consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: compensationExists, compensationCreated: compensationCreated, compensationInitialAmount: compensationInitialAmount, compensationInitialState: compensationInitialState, active: !active);
    }

    func resetMacros() -> MealIngredient {
        return MealIngredient(id: id, name: name, defaultAmount: defaultAmount, amount: amount, consumptionUnit: consumptionUnit, calories: 0, fat: 0, fiber: 0, netcarbs: 0, protein: 0, compensationExists: compensationExists, compensationCreated: compensationCreated, compensationInitialAmount: compensationInitialAmount, compensationInitialState: compensationInitialState, active: active);
    }

    func addMacros(calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) -> MealIngredient {
        return MealIngredient(id: id, name: name, defaultAmount: defaultAmount, amount: amount, consumptionUnit: consumptionUnit, calories: self.calories + calories, fat: self.fat + fat, fiber: self.fiber + fiber, netcarbs: self.netcarbs + netcarbs, protein: self.protein + protein, compensationExists: compensationExists, compensationCreated: compensationCreated, compensationInitialAmount: compensationInitialAmount, compensationInitialState: compensationInitialState, active: active);
    }

    func adjust(amount: Double, active: Bool = true) -> MealIngredient {
        if !compensationExists && !active {
            print("  Adjusting (activating - and storing compensation) " + name + " \(amount)")
            return MealIngredient(id: self.id, name: self.name, defaultAmount: self.defaultAmount, amount: amount, consumptionUnit: self.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: true, compensationCreated: false, compensationInitialAmount: self.amount, compensationInitialState: self.active, active: true)
        } else if !compensationExists {
            print("  Adjusting (and storing compensation) " + name + " \(amount)")
            return MealIngredient(id: self.id, name: self.name, defaultAmount: self.defaultAmount, amount: self.amount + amount, consumptionUnit: self.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: true, compensationCreated: false, compensationInitialAmount: self.amount, compensationInitialState: self.active, active: true)
        }

        print("  Adjusting " + name + " \(amount)")
        return MealIngredient(id: self.id, name: self.name, defaultAmount: self.defaultAmount, amount: self.amount + amount, consumptionUnit: self.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: self.compensationExists, compensationCreated: self.compensationCreated, compensationInitialAmount: self.compensationInitialAmount, compensationInitialState: self.compensationInitialState, active: true)
    }

    func rollback() -> MealIngredient {
        print("  Rollback " + name + " to \(compensationInitialAmount)")
        return MealIngredient(id: self.id, name: self.name, defaultAmount: self.defaultAmount, amount: self.compensationInitialAmount, consumptionUnit: self.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: false, compensationCreated: false, compensationInitialAmount: 0, compensationInitialState: false, active: compensationInitialState)
    }

    func resetAmount() -> MealIngredient {
        print("  Reset amount " + name + " Old: \(amount) New: \(defaultAmount)")
        return MealIngredient(id: id, name: name, defaultAmount: defaultAmount, amount: defaultAmount, consumptionUnit: consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: self.compensationExists, compensationCreated: self.compensationCreated, compensationInitialAmount: self.compensationInitialAmount, compensationInitialState: self.compensationInitialState, active: active);
    }

    func update(mealIngredient: MealIngredient) -> MealIngredient {
        print("  Update " + mealIngredient.name + " \(mealIngredient.amount)")
        return MealIngredient(id: mealIngredient.id, name: mealIngredient.name, defaultAmount: mealIngredient.defaultAmount, amount: mealIngredient.amount, consumptionUnit: mealIngredient.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, compensationExists: self.compensationExists, compensationCreated: self.compensationCreated, compensationInitialAmount: self.compensationInitialAmount, compensationInitialState: self.compensationInitialState, active: mealIngredient.active);
    }
}
