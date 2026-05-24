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


    // Per-profile id; meal data is namespaced under this id so
    // switching profile swaps meal data. Mutable so `reload` can
    // repoint the manager when the active profile changes.
    private(set) var profileId: String

    // The active profile's display name. Carried alongside profileId
    // so resetMealIngredients() can branch its seed defaults by
    // profile (profileId is a UUID — not human-stable across fresh
    // installs — so the seed switch keys on name instead).
    private(set) var profileName: String

    // Per-profile storage key. Reads and writes go through this so
    // every profile keeps its own meal data under "mealIngredient.<id>".
    // The base string "mealIngredient" is preserved as the prefix for
    // back-compat with the legacy unkeyed key (see migration in load).
    private var storageKey: String { "mealIngredient.\(profileId)" }


    @Published var mealIngredients: [MealIngredient] = [] {
        didSet {
            serialize()
        }
    }


    // Per-profile init: set profileId/Name FIRST so storageKey
    // resolves and resetMealIngredients() can branch by name, then
    // load from per-profile storage (with one-time legacy migration
    // — see load(forProfileId:)). If empty afterwards, seed the
    // default starter meal.
    init(profileId: String, profileName: String) {
        self.profileId = profileId
        self.profileName = profileName
        self.mealIngredients = MealIngredientMgr.load(forProfileId: profileId)
        if mealIngredients.isEmpty { resetMealIngredients() }
    }


    // Repoint this manager at a different profile: swap profileId +
    // profileName, reload from that profile's storage, seed defaults
    // (per-profile via name) if empty so newly-added profiles never
    // land on a blank meal page.
    func reload(forProfileId newId: String, profileName newName: String) {
        self.profileId = newId
        self.profileName = newName
        self.mealIngredients = MealIngredientMgr.load(forProfileId: newId)
        if mealIngredients.isEmpty { resetMealIngredients() }
    }


    // Load meal ingredients for `profileId`.
    //   1. Per-profile data exists? Use it.
    //   2. Else, if this profile hasn't tried migration AND the GLOBAL
    //      "mealIngredient.legacyConsumed" flag is false, try the
    //      legacy unkeyed "mealIngredient" key. The first profile to
    //      load post-refactor claims it; the global flag prevents
    //      other profiles from also claiming it.
    //   3. Else, return [] — caller seeds defaults.
    // Legacy key is never deleted (safety net).
    private static func load(forProfileId profileId: String) -> [MealIngredient] {
        let key = "mealIngredient.\(profileId)"
        let migratedKey = "mealIngredient.migrated.\(profileId)"
        let legacyConsumedKey = "mealIngredient.legacyConsumed"

        if let data = UserDefaults.standard.data(forKey: key),
           let savedItems = try? JSONDecoder().decode([MealIngredient].self, from: data) {
            return savedItems
        }

        if !UserDefaults.standard.bool(forKey: migratedKey) {
            UserDefaults.standard.set(true, forKey: migratedKey)
            if !UserDefaults.standard.bool(forKey: legacyConsumedKey),
               let legacyData = UserDefaults.standard.data(forKey: "mealIngredient"),
               let legacyItems = try? JSONDecoder().decode([MealIngredient].self, from: legacyData) {
                if let encoded = try? JSONEncoder().encode(legacyItems) {
                    UserDefaults.standard.set(encoded, forKey: key)
                }
                UserDefaults.standard.set(true, forKey: legacyConsumedKey)
                return legacyItems
            }
        }

        return []
    }


    func serialize() {
        if let encodedData = try? JSONEncoder().encode(mealIngredients) {
            UserDefaults.standard.set(encodedData, forKey: storageKey)
        }
    }


    func deserialize() {
        guard
          let data = UserDefaults.standard.data(forKey: storageKey),
          let savedItems = try? JSONDecoder().decode([MealIngredient].self, from: data)
        else {
            return
        }

        self.mealIngredients = savedItems
    }


    func resetMealIngredients() {
        print("RESETTING Meal Ingredients for \(profileName)")

        mealIngredients = []

        // Default meal seed branches on profileName so each profile
        // can have its own starter set. Add a new `case` for each
        // additional profile; the `default` arm is the canonical
        // Shane/original seed.
        switch profileName {

        // ---- Caden ----------------------------------------------
        // TODO: customize Caden's starter meal. Until populated,
        // Caden gets an empty meal — open the meal page's eye picker
        // to build it up, or just append rows here.
        case "Caden":
            mealIngredients.append(MealIngredient(name: "Avocado Oil", amount: 1))
            mealIngredients.append(MealIngredient(name: "Eggs", amount: 3))
            mealIngredients.append(MealIngredient(name: "Bread", amount: 2, selectedMemberName: "Dave's Killer Bread Powerseed Thin (20.5 oz)"))
            mealIngredients.append(MealIngredient(name: "Ham", amount: 2))
            mealIngredients.append(MealIngredient(name: "Bell Peppers", amount: 2))
            mealIngredients.append(MealIngredient(name: "Mushrooms", amount: 2))
            mealIngredients.append(MealIngredient(name: "Jelly", amount: 2))
            // Breakfast fruit picker — tap to pick any Food of type
            // .fruit; replaces this placeholder with a real row.
            mealIngredients.append(MealIngredient(name: IngredientType.fruit.label,
                                                  amount: 0,
                                                  foodType: IngredientType.fruit.rawValue))
            mealIngredients.append(MealIngredient(name: "Milk", amount: 1))

            mealIngredients.append(MealIngredient(name: "Bread", amount: 4, selectedMemberName: "Dave's Killer Bread Powerseed Thin (20.5 oz)"))
            mealIngredients.append(MealIngredient(name: "Turkey", amount: 4, selectedMemberName: "Turkey (Trader Joe's Organic Hickory Smoked, 6 oz)"))
            mealIngredients.append(MealIngredient(name: "Cheese Slice", amount: 4))
            mealIngredients.append(MealIngredient(name: "Romaine", amount: 30))  // sandwich lettuce ≈ 2–3 leaves
            mealIngredients.append(MealIngredient(name: "Mustard", amount: 4))

            mealIngredients.append(MealIngredient(name: "Cucumber", amount: 150))
            mealIngredients.append(MealIngredient(name: "String Cheese", amount: 2))
            mealIngredients.append(MealIngredient(name: IngredientType.meat.label,
                                                  amount: 0,
                                                  foodType: IngredientType.meat.rawValue))
            break

        // ---- Shane (and any unrecognized profile name) ----------
        default:
            // The default meal is exactly the rows below. Foods that
            // used to be seeded as inactive "repertoire" placeholders
            // (extra sardine/mackerel variants, String Cheese W, the
            // other cheeses, Peanuts, the berries) are NOT seeded —
            // they are still reachable any day via the Meal page's
            // eye add-list (any active Food not currently in the
            // meal).
            mealIngredients.append(MealIngredient(name: "Coconut Oil", amount: 0.5))
            mealIngredients.append(MealIngredient(name: "Eggs", amount: 5))
            mealIngredients.append(MealIngredient(name: "Broccoli", amount: 150))
            mealIngredients.append(MealIngredient(name: "Cauliflower", amount: 100))
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

            // Category placeholder — a "pick a meat" slot that always
            // renders at the very end of the meal list (sentinel sort
            // rank). It contributes ZERO macros and never resolves to an
            // ingredient. Tapping it lists every Food of type .meat;
            // picking one replaces the placeholder with a normal Food
            // row. It is part of the default meal pattern, so it comes
            // back on Reset Meal even after it's been consumed.
            mealIngredients.append(MealIngredient(name: IngredientType.meat.label,
                                                  amount: 0,
                                                  foodType: IngredientType.meat.rawValue))
        }
    }


    // Create a new meal ingredient and add it to the meal ingredients list.
    // Consumer is the Meal Add dialog.
    func create(name: String,
                amount: Double,
                adjustment: Int = Constants.Default,
                priorState: Int = Constants.Active,
                isSupplement: Bool = false,
                selectedMemberName: String = "",
                compositeParts: [MealCompositePart] = []) {

        let mealIngredient = MealIngredient(name: name,
                                            amount: amount,
                                            adjustment: adjustment,
                                            priorState: priorState,
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


    // Handles 3 cases (2 by automaticAdjustment() and one by create()):
    // 1a. meal ingredient exists, not previously adjusted
    // 1b. meal ingredient exists, previously adjusted
    // 2.  meal ingredient does not exist
    func automaticAdjustment(name: String, amount: Double) {

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


    // Return every present meal ingredient. A meal is exactly the
    // rows that are present (the active/inactive concept was
    // removed). Supplements always render at the very bottom; within
    // each group the original insertion order is preserved since
    // filter is stable.
    func getAllMealIngredients() -> [MealIngredient] {
        return mealIngredients.filter { !$0.isSupplement }
             + mealIngredients.filter { $0.isSupplement }
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
        for mealIngredient in getAllMealIngredients() {
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

    // Non-empty ⇒ this row is a CATEGORY PLACEHOLDER, not a real
    // food. `name` holds the capitalized category label (e.g.
    // "Meat") and `foodType` holds the IngredientType rawValue
    // (e.g. "meat"). It contributes ZERO macros, never resolves to
    // an Ingredient, sorts to the very end of the meal list, and is
    // replaced by a real Food row when the user picks one. Empty ⇒
    // ordinary / composite row.
    var foodType: String

    var isComposite: Bool { !compositeParts.isEmpty }

    var isFoodTypeSlot: Bool { !foodType.isEmpty }


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
         isSupplement: Bool = false,
         selectedMemberName: String = "",
         compositeParts: [MealCompositePart] = [],
         foodType: String = "") {

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

        self.isSupplement = isSupplement
        self.selectedMemberName = selectedMemberName
        self.compositeParts = compositeParts
        self.foodType = foodType
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
        // `active` was removed from the model (a meal is exactly the
        // rows that are present). Old saved JSON may still carry an
        // "active" key; Codable ignores unlisted keys, and the seed is
        // rebuilt each launch anyway, so old data still loads.
        self.isSupplement = try c.decodeIfPresent(Bool.self, forKey: .isSupplement) ?? false
        // Migration-safe: absent in data saved before groups existed.
        self.selectedMemberName = try c.decodeIfPresent(String.self, forKey: .selectedMemberName) ?? ""
        self.compositeParts = try c.decodeIfPresent([MealCompositePart].self, forKey: .compositeParts) ?? []
        // Migration-safe: absent in data saved before category
        // placeholders existed.
        self.foodType = try c.decodeIfPresent(String.self, forKey: .foodType) ?? ""
    }


    // All the methods below return a modified copy. They use
    // `var c = self` and mutate only what changes, so every field
    // (selectedMemberName and any added later) is preserved without
    // having to re-list it at each call site.

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
        var c = self
        c.amount = amount
        c.adjustment = Constants.Manual
        c.priorState = Constants.Active
        return c
    }


    // Promote this row to Done (blue / locked complete).
    func doneAdjustment(amount: Double) -> MealIngredient {
        var c = self
        c.amount = amount
        c.adjustment = Constants.Done
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

        if adjustment == Constants.Default {
            print("  Automatic adjustment of \(self.name) by \(amount) to \(self.amount + amount) (initial adjustment) (original amount \(originalAmount))")
            var c = self
            c.amount = self.amount + amount
            c.adjustment = Constants.Automatic
            c.priorState = Constants.Active
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
        var c = self
        c.amount = self.originalAmount
        c.adjustment = Constants.Default
        c.priorState = Constants.Default
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
func compositeCost(_ mi: MealIngredient, _ ingredientMgr: IngredientMgr, _ foodMgr: FoodMgr) -> Double {
    var total = 0.0
    for part in mi.compositeParts {
        guard let ing = ingredientMgr.getByName(name: part.selectedVariantName) else { continue }
        let grams = ing.effectiveTotalGrams
        guard grams > 0 else { continue }
        let costPerGram = ing.totalCost / grams
        total += costPerGram * (part.amount * foodMgr.consumptionGrams(for: ing))
    }
    return total
}
