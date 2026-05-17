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

        mealIngredients.append(MealIngredient(name: "Sardines (H2O)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sardines (SB)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sardines (LS)", amount: 1, active: false))
        mealIngredients.append(MealIngredient(name: "Sardines (LS L)", amount: 1, active: false))
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
                adjustment: Int = Constants.Default,
                priorState: Int = Constants.Active,
                active: Bool = true,
                isSupplement: Bool = false,
                selectedMemberName: String = "",
                compositeParts: [MealCompositePart] = []) {

        let mealIngredient = MealIngredient(name: name,
                                            amount: amount,
                                            adjustment: adjustment,
                                            priorState: priorState,
                                            active: active,
                                            isSupplement: isSupplement,
                                            selectedMemberName: selectedMemberName,
                                            compositeParts: compositeParts)

        mealIngredients.append(mealIngredient)
    }


    // Duplicate an existing meal row into a new, independent row.
    // The clone keeps the source row's member selection, amount,
    // composite parts, supplement flag, and active state but gets a
    // FRESH id (and resets adjustment/priorState to Default so the
    // copy starts clean — the user can re-lock it independently).
    // The new row is inserted directly after its source so it shows
    // adjacent to the original in the list.
    func replicate(id: String) {
        guard let index = mealIngredients.firstIndex(where: { $0.id == id }) else {
            return
        }
        let src = mealIngredients[index]
        let clone = MealIngredient(name: src.name,
                                   originalAmount: src.amount,
                                   amount: src.amount,
                                   active: src.active,
                                   isSupplement: src.isSupplement,
                                   selectedMemberName: src.selectedMemberName,
                                   compositeParts: src.compositeParts)
        mealIngredients.insert(clone, at: index + 1)
    }


    // Change which member of a group this meal row uses. Macros are
    // recomputed by the next generateMeal() (resolution happens
    // there via the row's selectedMemberName). Keyed by the row's
    // unique id so multiple rows of the same Food are independent.
    func setSelectedMember(id: String, member: String) {
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
            mealIngredients[index].selectedMemberName = member
        }
    }


    // Set a meal row's amount directly (used when switching Food
    // variants so the row adopts the new variant's defaultAmount).
    func setAmount(id: String, amount: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
            mealIngredients[index].amount = amount
        }
    }


    // Replace a composite row's resolved parts (variant swap /
    // amount change from the composite editor).
    func setCompositeParts(id: String, parts: [MealCompositePart]) {
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
            mealIngredients[index].compositeParts = parts
        }
    }


    func manualAdjustment(id: String, name: String, amount: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
            mealIngredients[index] = mealIngredients[index].manualAdjustment(amount: amount)
            return
        }

        print("  Creating " + name + " \(amount)")
        create(name: name, amount: amount, adjustment: Constants.Manual, priorState: Constants.Ingredient)
    }


    func undoManualAdjustment(id: String) {
        print("Undo Manual Adjustment for \(id)")
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
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
    // current amount. Keyed by row id so duplicated rows of the same
    // Food lock independently.
    func doneAdjustment(id: String, amount: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
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
    func undoDoneAdjustment(id: String, resetAmount: Bool) {
        print("Undo Done Adjustment for \(id) resetAmount=\(resetAmount)")
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
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
        // list.  Within each group the original insertion order is
        // preserved, since filter is stable.
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


    func setMacroActuals(id: String, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) {
        if let index = mealIngredients.firstIndex(where: { $0.id == id }) {
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


// One resolved component of a composite meal row: which Food, the
// variant currently chosen for it, and how much. Macros/cost come
// from the variant Ingredient at `amount` in its consumption unit.
struct MealCompositePart: Codable, Equatable, Identifiable {
    var id: String { foodName }
    var foodName: String
    var selectedVariantName: String
    var amount: Double
}


struct MealIngredient: Codable, Identifiable {
    var id: String

    var name: String

    var originalAmount: Double
    var amount: Double

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

    // Non-empty ⇒ this meal row represents an ingredient GROUP
    // (`name` holds the group name) and this is the currently
    // selected member ingredient. Macros/cost resolve from the
    // member, not the group name. Empty ⇒ ordinary ingredient row.
    var selectedMemberName: String

    // Non-empty ⇒ this row is a FoodComposite; `name` holds the
    // composite name and macros/cost are the sum of these parts.
    var compositeParts: [MealCompositePart]

    var isComposite: Bool { !compositeParts.isEmpty }


    init(id: String = UUID().uuidString,
         name: String,
         originalAmount: Double = 0,
         amount: Double,
         calories: Double = 0,
         fat: Double = 0,
         fiber: Double = 0,
         netcarbs: Double = 0,
         protein: Double = 0,
         adjustment: Int = Constants.Default,
         priorState: Int = Constants.Active,
         active: Bool = true,
         isSupplement: Bool = false,
         selectedMemberName: String = "",
         compositeParts: [MealCompositePart] = []) {

        self.id = id

        self.name = name

        if originalAmount == 0 {
            self.originalAmount = amount
        } else {
            self.originalAmount = originalAmount
        }
        self.amount = amount

        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netcarbs = netcarbs
        self.protein = protein

        self.adjustment = adjustment
        self.priorState = priorState

        self.active = active
        self.isSupplement = isSupplement
        self.selectedMemberName = selectedMemberName
        self.compositeParts = compositeParts
    }


    // Custom Codable decoder for back-compat: old saved data won't
    // have `isSupplement` so default to false.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decode(String.self, forKey: .id)
        self.name = try c.decode(String.self, forKey: .name)
        self.originalAmount = try c.decode(Double.self, forKey: .originalAmount)
        self.amount = try c.decode(Double.self, forKey: .amount)
        // `meat` was removed from the model. Old saved JSON may still
        // carry a "meat" key; Codable simply ignores unlisted keys, so
        // there is nothing to decode here and old data still loads.
        self.calories = try c.decode(Double.self, forKey: .calories)
        self.fat = try c.decode(Double.self, forKey: .fat)
        self.fiber = try c.decode(Double.self, forKey: .fiber)
        self.netcarbs = try c.decode(Double.self, forKey: .netcarbs)
        self.protein = try c.decode(Double.self, forKey: .protein)
        self.adjustment = try c.decode(Int.self, forKey: .adjustment)
        self.priorState = try c.decode(Int.self, forKey: .priorState)
        self.active = try c.decode(Bool.self, forKey: .active)
        self.isSupplement = try c.decodeIfPresent(Bool.self, forKey: .isSupplement) ?? false
        // Migration-safe: absent in data saved before groups existed.
        self.selectedMemberName = try c.decodeIfPresent(String.self, forKey: .selectedMemberName) ?? ""
        self.compositeParts = try c.decodeIfPresent([MealCompositePart].self, forKey: .compositeParts) ?? []
    }


    // All the methods below return a modified copy. They use
    // `var c = self` and mutate only what changes, so every field
    // (selectedMemberName and any added later) is preserved without
    // having to re-list it at each call site.

    func toggleActive() -> MealIngredient {
        var c = self
        c.active.toggle()
        return c
    }


    func toggleSupplement() -> MealIngredient {
        var c = self
        c.isSupplement.toggle()
        return c
    }


    func setMacroActualsToZero() -> MealIngredient {
        var c = self
        c.calories = 0
        c.fat = 0
        c.fiber = 0
        c.netcarbs = 0
        c.protein = 0
        return c
    }


    func setMacroActuals(calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) -> MealIngredient {
        var c = self
        c.calories += calories
        c.fat += fat
        c.fiber += fiber
        c.netcarbs += netcarbs
        c.protein += protein
        return c
    }


    func manualAdjustment(amount: Double) -> MealIngredient {
        if adjustment == Constants.Automatic {
            undoAdjustment()
        }
        var c = self
        c.amount = amount
        c.adjustment = Constants.Manual
        c.priorState = self.active ? Constants.Active : Constants.Inactive
        c.active = true
        return c
    }


    // Adjust the meal ingredient's amount saving the original value
    // for active and amount to allow the auto adjustment to be
    // removed later.
    // Promote this row to Done (blue / locked complete). Preserves
    // priorState so the prior pre-Done active/inactive flag is
    // recoverable if we ever need it.
    func doneAdjustment(amount: Double) -> MealIngredient {
        var c = self
        c.amount = amount
        c.adjustment = Constants.Done
        c.active = true
        return c
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
        var c = self
        c.amount = resetAmount ? self.originalAmount : self.amount
        c.adjustment = Constants.Default
        return c
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
            var c = self
            c.amount = amount
            c.adjustment = Constants.Automatic
            c.priorState = self.active ? Constants.Active : Constants.Inactive
            c.active = true
            return c
        }

        if adjustment == Constants.Default && active {
            // adjustment: Automatic
            // amount: += amount
            // priorState: self.active
            // active: true
            print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (initial adjustment) (original amount \(originalAmount))")
            var c = self
            c.amount = self.amount + amount
            c.adjustment = Constants.Automatic
            c.priorState = self.active ? Constants.Active : Constants.Inactive
            c.active = true
            return c
        }

        print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (delta adjustment) (original amount \(originalAmount))")
        var c = self
        c.amount = self.amount + amount
        return c
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
        var c = self
        c.amount = self.originalAmount
        c.adjustment = Constants.Default
        c.priorState = Constants.Default
        c.active = restoredActive
        return c
    }


    func update(mealIngredient: MealIngredient) -> MealIngredient {
        print("  Update \(mealIngredient.name)")
        return mealIngredient
    }
}


// Total cost of a composite meal row: sum of each component's
// selected variant cost-per-gram × grams consumed. Components
// without pricing (totalGrams == 0) contribute 0.
func compositeCost(_ mi: MealIngredient, _ ingredientMgr: IngredientMgr) -> Double {
    var total = 0.0
    for part in mi.compositeParts {
        guard let ing = ingredientMgr.getByName(name: part.selectedVariantName) else { continue }
        let grams = ing.effectiveTotalGrams
        guard grams > 0 else { continue }
        let costPerGram = ing.totalCost / grams
        total += costPerGram * (part.amount * ing.consumptionGrams)
    }
    return total
}
