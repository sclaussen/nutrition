import Foundation


enum Constants {
    // Three user-visible adjustment modes (plus Default as a
    // transient internal state):
    //   Default   — fresh row, hasn't been touched; renders black.
    //               Auto-adjustments can promote it to Automatic.
    //   Manual    — user controls amount; auto-adjust skips this
    //               row; renders black. Same color as Default; user
    //               doesn't see a difference.
    //   Automatic — system auto-adjusted this generation cycle;
    //               renders green.
    //   Done      — user-locked / "complete"; renders blue.
    //               Inc/dec/pill are disabled; auto-adjust skips.
    static let Default: Int = 1
    static let Manual: Int = 2
    static let Automatic: Int = 3
    static let Done: Int = 5

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

        mealIngredients.append(MealIngredient(name: "Sard (H2O)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sard (SB)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sard (LS)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sard (LS L)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Mack (SB)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Mack (Smk)", amount: 1, active: false))
        // Cheeses (Babybel, Tillamook Cheddar, Dubliner) and nuts
        // (Macadamia, Pecans, Walnuts, Peanuts) moved below the
        // String Cheese / String Cheese W block further down the list
        // — keeps the dairy + nuts grouped together near the end.
        // Dubliner Cheese, Babybel Cheese, Tillamook Cheddar Cheese,
        // Macadamia Nuts, Pecans, Walnuts, and Peanuts all moved
        // below the String Cheese block further down the list.
        // mealIngredients.append(MealIngredient(name: "Mitica", amount: 10, active: false))
        // mealIngredients.append(MealIngredient(name: "Flackers (SS)", amount: 30, active: false))
        // mealIngredients.append(MealIngredient(name: "Cheddar Cheese", amount: 1, active: false))
        // mealIngredients.append(MealIngredient(name: "Emmi Roth", amount: 30, active: false))

        mealIngredients.append(MealIngredient(name: "Coconut Oil", amount: 0.5))
        mealIngredients.append(MealIngredient(name: "Eggs", amount: 5))
        mealIngredients.append(MealIngredient(name: "Broccoli", amount: 150))
        mealIngredients.append(MealIngredient(name: "Cauliflower", amount: 100))
        // String Cheese W moved below String Cheese (further down).
        mealIngredients.append(MealIngredient(name: "Romaine", amount: 175))
        mealIngredients.append(MealIngredient(name: "Spinach", amount: 50))
        mealIngredients.append(MealIngredient(name: "Arugula", amount: 50))
        mealIngredients.append(MealIngredient(name: "Mushrooms", amount: 125))
        mealIngredients.append(MealIngredient(name: "Radish", amount: 70))
        mealIngredients.append(MealIngredient(name: "Avocado", amount: 225))
        mealIngredients.append(MealIngredient(name: "Mustard", amount: 3))
        mealIngredients.append(MealIngredient(name: "Fish Oil", amount: 1))
        mealIngredients.append(MealIngredient(name: "Extra Virgin Olive Oil", amount: 2))
        mealIngredients.append(MealIngredient(name: "Pumpkin Seeds", amount: 30))
        mealIngredients.append(MealIngredient(name: "String Cheese", amount: 0))
        // String Cheese W, the other cheeses, and the nuts moved
        // here per request: String Cheese / String Cheese W first,
        // then other cheeses, then nuts.
        mealIngredients.append(MealIngredient(name: "String Cheese W", amount: 0, active: false))
        mealIngredients.append(MealIngredient(name: "Dubliner Cheese", amount: 30, active: false))
        mealIngredients.append(MealIngredient(name: "Manchego Cheese", amount: 30, active: false))
        mealIngredients.append(MealIngredient(name: "Macadamia Nuts", amount: 0, active: false))
        mealIngredients.append(MealIngredient(name: "Pecans", amount: 20, active: false))
        mealIngredients.append(MealIngredient(name: "Walnuts", amount: 20, active: false))
        mealIngredients.append(MealIngredient(name: "Peanuts", amount: 20, active: false))

        // Berries — seeded inactive so they're easy to enable from
        // the meal list when you actually eat them, without showing
        // every day.  Toggle "Show inactive" in the toolbar to see.
        mealIngredients.append(MealIngredient(name: "Blueberries",  amount: 100, active: false))
        mealIngredients.append(MealIngredient(name: "Blackberries", amount: 100, active: false))

        // Supplements — hidden from the meal list by default, but
        // active and counted toward daily V&M (and macros).  Toggle
        // 'Show supplements' in the toolbar to see them.  Order matches
        // the user's preferred display order, not time-of-day.
        mealIngredients.append(MealIngredient(name: "Thorne Basic Nutrients 2/Day", amount: 2, isSupplement: true))
        mealIngredients.append(MealIngredient(name: "Creatine HCl",         amount: 2, isSupplement: true))
        mealIngredients.append(MealIngredient(name: "Glycine",              amount: 1, isSupplement: true))
        mealIngredients.append(MealIngredient(name: "Vitamin D3 (1000 IU)", amount: 1, isSupplement: true))
        mealIngredients.append(MealIngredient(name: "SlowMag",              amount: 2, isSupplement: true))
        mealIngredients.append(MealIngredient(name: "L-Theanine",           amount: 1, isSupplement: true))
        mealIngredients.append(MealIngredient(name: "Apigenin",             amount: 1, isSupplement: true))
    }


    // Create a new meal ingredient and add it to the meal ingredients list.
    // Consumer is the Meal Add dialog.
    func create(name: String,
                amount: Double,
                meat: Bool = false,
                adjustment: Int = Constants.Default,
                priorState: Int = Constants.Active,
                active: Bool = true,
                isSupplement: Bool = false) {

        let mealIngredient = MealIngredient(name: name,
                                            amount: amount,
                                            meat: meat,
                                            adjustment: adjustment,
                                            priorState: priorState,
                                            active: active,
                                            isSupplement: isSupplement)

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


    // Promote a row to Done (blue / fully locked). Called when the
    // user taps the name of a Manual or Default row. Keeps the
    // current amount.
    func doneAdjustment(name: String, amount: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            mealIngredients[index] = mealIngredients[index].doneAdjustment(amount: amount)
        }
    }


    // Revert a Done row to Default.
    //
    // resetAmount=true: caller has decided this ingredient is auto-
    //   eligible and the amount should be reset to originalAmount so
    //   the next generateMeal can let auto recompute cleanly.
    // resetAmount=false: caller has decided this is a manual-only
    //   ingredient; preserve the user's amount.
    func undoDoneAdjustment(name: String, resetAmount: Bool) {
        print("Undo Done Adjustment for \(name) resetAmount=\(resetAmount)")
        if let index = mealIngredients.firstIndex(where: { $0.name == name }) {
            if mealIngredients[index].adjustment == Constants.Done {
                mealIngredients[index] = mealIngredients[index].undoDoneAdjustment(resetAmount: resetAmount)
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


    // Replace the meal's protein rows with the given list. Removes
    // every existing meat-flagged MealIngredient, then adds one per
    // protein. Proteins sharing the same `name` are coalesced (their
    // amounts summed) so the MealIngredient name-uniqueness invariant
    // — `getByName(name:)` returns the first match — keeps holding.
    func reapplyProteins(_ proteins: [Protein]) {
        mealIngredients.removeAll(where: { $0.meat })

        var combined: [String: Double] = [:]
        var order: [String] = []
        for p in proteins {
            if combined[p.name] == nil { order.append(p.name) }
            combined[p.name, default: 0] += p.amount
        }
        for name in order {
            let amount = combined[name]!
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
        let base = includeInactive ? mealIngredients : mealIngredients.filter { $0.active }
        // Supplements always render at the very bottom of the meal
        // list — under the meat (which is dynamically appended via
        // reapplyMeat).  Within each group the original insertion
        // order is preserved, since filter is stable.
        return base.filter { !$0.isSupplement } + base.filter { $0.isSupplement }
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


    // Flip the supplement flag on a meal ingredient.  When the flag
    // is on, the row is hidden from the Meal list unless the user
    // enables 'Show supplements' in the view-options menu.  V&M and
    // macros aggregations still include it.
    func toggleSupplement(_ mealIngredient: MealIngredient) -> MealIngredient? {
        if let index = mealIngredients.firstIndex(where: { $0.id == mealIngredient.id }) {
            mealIngredients[index] = mealIngredient.toggleSupplement()
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

    // Supplements are meal ingredients that count toward daily macro
    // and V&M totals but are hidden from the Meal list by default
    // (toggle in the view-options menu to show them).
    var isSupplement: Bool


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
         active: Bool = true,
         isSupplement: Bool = false) {

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
        self.isSupplement = isSupplement
    }


    // Custom Codable decoder for back-compat: old saved data won't
    // have `isSupplement` so default to false.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decode(String.self, forKey: .id)
        self.name = try c.decode(String.self, forKey: .name)
        self.originalAmount = try c.decode(Double.self, forKey: .originalAmount)
        self.amount = try c.decode(Double.self, forKey: .amount)
        self.meat = try c.decode(Bool.self, forKey: .meat)
        self.calories = try c.decode(Double.self, forKey: .calories)
        self.fat = try c.decode(Double.self, forKey: .fat)
        self.fiber = try c.decode(Double.self, forKey: .fiber)
        self.netcarbs = try c.decode(Double.self, forKey: .netcarbs)
        self.protein = try c.decode(Double.self, forKey: .protein)
        self.adjustment = try c.decode(Int.self, forKey: .adjustment)
        self.priorState = try c.decode(Int.self, forKey: .priorState)
        self.active = try c.decode(Bool.self, forKey: .active)
        self.isSupplement = try c.decodeIfPresent(Bool.self, forKey: .isSupplement) ?? false
    }


    func toggleActive() -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment, priorState: priorState, active: !active, isSupplement: isSupplement);
    }


    func toggleSupplement() -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment, priorState: priorState, active: active, isSupplement: !isSupplement);
    }


    func setMacroActualsToZero() -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: 0, fat: 0, fiber: 0, netcarbs: 0, protein: 0, adjustment: adjustment, priorState: priorState, active: active, isSupplement: isSupplement);
    }


    func setMacroActuals(calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) -> MealIngredient {
        return MealIngredient(id: id, name: name, originalAmount: originalAmount, amount: amount, meat: meat, calories: self.calories + calories, fat: self.fat + fat, fiber: self.fiber + fiber, netcarbs: self.netcarbs + netcarbs, protein: self.protein + protein, adjustment: adjustment, priorState: priorState, active: active, isSupplement: isSupplement);
    }


    func manualAdjustment(amount: Double) -> MealIngredient {
        if adjustment == Constants.Automatic {
            undoAdjustment()
        }

        // adjustment: Manual
        // amount: amount
        // priorState: self.active
        // active: true
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Manual, priorState: self.active ? Constants.Active : Constants.Inactive, active: true, isSupplement: self.isSupplement);
    }


    // Adjust the meal ingredient's amount saving the original value
    // for active and amount to allow the auto adjustment to be
    // removed later.
    // Promote this row to Done (blue / locked complete). Preserves
    // priorState so the prior pre-Done active/inactive flag is
    // recoverable if we ever need it.
    func doneAdjustment(amount: Double) -> MealIngredient {
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Done, priorState: self.priorState, active: true, isSupplement: self.isSupplement)
    }


    // Revert from Done back to Default.
    //
    // resetAmount=true: amount goes back to originalAmount so the
    //   next generateMeal's auto-adjustment can compute the right
    //   amount cleanly without double-counting against the user's
    //   Done amount.
    // resetAmount=false: preserve the user's amount (manual-only
    //   ingredient — no auto-rule to overwrite, the user's amount
    //   should survive Done → manual mode).
    //
    // Active is always preserved as-is — we do NOT derive it from
    // priorState the way `undoAdjustment()` does. That derivation
    // breaks across multi-step user cycles because priorState gets
    // reset to Default during the auto-adjust round-trip, and a
    // subsequent Done → Default would then evaluate Default==Active
    // as false and silently deactivate the row.
    func undoDoneAdjustment(resetAmount: Bool) -> MealIngredient {
        let newAmount = resetAmount ? self.originalAmount : self.amount
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: newAmount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Default, priorState: self.priorState, active: self.active, isSupplement: self.isSupplement)
    }


    func automaticAdjustment(amount: Double) -> MealIngredient {

        if adjustment == Constants.Manual || adjustment == Constants.Done {
            print("  Attempted an automatic adjustment but the meal ingredient has been manually adjusted or marked Done: \(name)")
            return self
        }

        // Defensive: caller (tryAddingAdjustment) already skips
        // inactive rows. Double-check here so any future call site
        // can't silently reactivate a row the user has deactivated.
        if !active {
            print("  Attempted an automatic adjustment but the meal ingredient is inactive: \(name)")
            return self
        }

        if adjustment == Constants.Default && !active {
            // adjustment: Automatic
            // amount: += amount
            // priorState: self.active
            // active: true
            print("  Automatic adjustment of \(self.name) to \(amount) (and activating ingredient) (original amount \(originalAmount))")
            return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Automatic, priorState: self.active ? Constants.Active : Constants.Inactive, active: true, isSupplement: self.isSupplement)
        }

        if adjustment == Constants.Default && active {
            // adjustment: Automatic
            // amount: += amount
            // priorState: self.active
            // active: true
            print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (initial adjustment) (original amount \(originalAmount))")
            return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: self.amount + amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: Constants.Automatic, priorState: self.active ? Constants.Active : Constants.Inactive, active: true, isSupplement: self.isSupplement)
        }

        print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (delta adjustment) (original amount \(originalAmount))")
        // amount: += amount
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: self.amount + amount, meat: self.meat, calories: self.calories, fat: self.fat, fiber: self.fiber, netcarbs: self.netcarbs, protein: self.protein, adjustment: self.adjustment, priorState: self.priorState, active: self.active, isSupplement: self.isSupplement)
    }


    // Remove the adjustment to a meal ingredient.
    func undoAdjustment() -> MealIngredient {
        print("  Undoing \(name) current amount: \(amount) to original amount \(originalAmount)")
        // amount: self.originalAmount
        // adjustment: Default
        // priorState: Default
        // active: stays true only if BOTH the row is currently
        //   active AND priorState was Active. self.active being
        //   false here means the user just deactivated the row
        //   (trash-can swipe) AFTER the auto-adjustment had set
        //   priorState=Active — we must NOT silently reactivate.
        let restoredActive = self.active && (self.priorState == Constants.Active)
        return MealIngredient(id: self.id, name: self.name, originalAmount: self.originalAmount, amount: self.originalAmount, meat: self.meat, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: Constants.Default, priorState: Constants.Default, active: restoredActive, isSupplement: self.isSupplement)
    }


    func update(mealIngredient: MealIngredient) -> MealIngredient {
        print("  Update \(mealIngredient.name)")
        return MealIngredient(id: mealIngredient.id, name: mealIngredient.name, originalAmount: mealIngredient.originalAmount, amount: mealIngredient.amount, meat: mealIngredient.meat, calories: mealIngredient.calories, fat: mealIngredient.fat, fiber: mealIngredient.fiber, netcarbs: mealIngredient.netcarbs, protein: mealIngredient.protein, adjustment: mealIngredient.adjustment, priorState: mealIngredient.priorState, active: mealIngredient.active, isSupplement: mealIngredient.isSupplement);
    }
}
