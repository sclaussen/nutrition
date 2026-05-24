import Foundation


// An ingredient group / variant set. The group (e.g. "Eggs") is
// what gets added to a meal; its members are individual brand
// ingredients whose `Ingredient.foodName` equals this group's
// `name`. One member is the default — used when the group is first
// added to a meal and as the fallback if a selected member is
// later deleted.
//
// Named `Food` (not `Group`) to avoid colliding with
// SwiftUI.Group, which the view layer uses as a container.
struct Food: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    // The Food's category. This is the single source of truth for
    // type: member ingredients inherit it via their foodName, they
    // no longer carry their own type.
    var type: IngredientType
    // Portion config now lives primarily on the Food so one value
    // applies to every variant. Member ingredients keep their own
    // `defaultAmount` / `stepAmount` only as an OPTIONAL OVERRIDE
    // that wins when non-zero (multi-size foods like Avocado). 0 =
    // inherit / no Food-level value.
    var defaultAmount: Double
    var stepAmount: Double
    // The consumption unit (tablespoon / egg / can / gram …) and the
    // grams that one such unit weighs. Unlike defaultAmount these are
    // ALWAYS authoritative on the Food: every member ingredient of
    // the Food is prepped/consumed in the same unit, so there is no
    // "0 = none" sentinel. Member ingredients still carry their own
    // stored consumptionUnit/consumptionGrams (raw value edited on
    // the ingredient form), but meal math reads the Food's value via
    // FoodMgr.consumptionUnit(for:) / .consumptionGrams(for:).
    var consumptionUnit: Unit
    var consumptionGrams: Double
    var currentIngredientName: String

    init(id: String = UUID().uuidString,
         name: String,
         type: IngredientType,
         defaultAmount: Double = 0,
         stepAmount: Double = 0,
         consumptionUnit: Unit = .gram,
         consumptionGrams: Double = 1,
         currentIngredientName: String) {
        self.id = id
        self.name = name
        self.type = type
        self.defaultAmount = defaultAmount
        self.stepAmount = stepAmount
        self.consumptionUnit = consumptionUnit
        self.consumptionGrams = consumptionGrams
        self.currentIngredientName = currentIngredientName
    }
}


class FoodMgr: ObservableObject {

    @Published var foods: [Food] = [] {
        didSet { serialize() }
    }


    // Seeded in code, exactly like IngredientMgr — the seed is the
    // source of truth and is rebuilt every launch. Each entry is a
    // food and its current (default) member ingredient. Runtime
    // changes (ensure / setCurrent) are serialized but, like
    // ingredient edits, are not read back on the next launch.
    init() {
        // Boil Broccoli & Cauliflower
        foods.append(Food(name: "Broccoli", type: .produce, defaultAmount: 150, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Broccoli (365 by Whole Foods M 32 Ounce)"))
        foods.append(Food(name: "Cauliflower", type: .produce, defaultAmount: 100, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Cauliflower (365 by Whole Foods M 12 Ounce)"))

        // Cook Eggs
        foods.append(Food(name: "Coconut Oil", type: .oils, defaultAmount: 0.5, stepAmount: 0.5, consumptionUnit: .tablespoon, consumptionGrams: 14, currentIngredientName: "Coconut Oil (365 by Whole Foods M 14 Fl Oz)"))
        foods.append(Food(name: "Avocado Oil", type: .oils, defaultAmount: 0.5, stepAmount: 0.5, consumptionUnit: .tablespoon, consumptionGrams: 14, currentIngredientName: "Avocado Oil"))
        foods.append(Food(name: "Eggs", type: .proteins, defaultAmount: 5, stepAmount: 1, consumptionUnit: .egg, consumptionGrams: 50, currentIngredientName: "Eggs (365 by Whole Foods M 18 Count)"))

        // Salad
        foods.append(Food(name: "Romaine", type: .produce, defaultAmount: 175, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Romaine"))
        foods.append(Food(name: "Spinach", type: .produce, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Spinach (365 by Whole Foods M 5 oz)"))
        foods.append(Food(name: "Arugula", type: .produce, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Arugula (365 by Whole Foods M 5 OZ)"))
        foods.append(Food(name: "Mushrooms", type: .produce, defaultAmount: 100, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Mushrooms (365 by Whole Foods M 8 Ounce)"))
        foods.append(Food(name: "Brussels Sprouts", type: .produce, defaultAmount: 100, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Brussels Sprouts (Whole Foods Market 1 lb)"))
        foods.append(Food(name: "Radish", type: .produce, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Radish (Whole Foods Market 12 Oz)"))
        foods.append(Food(name: "Avocado", type: .produce, defaultAmount: 140, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Avocado (365 by Whole Foods M 4 Count)"))
        foods.append(Food(name: "Bell Peppers", type: .produce, defaultAmount: 2, stepAmount: 1, consumptionUnit: .piece, consumptionGrams: 150, currentIngredientName: "Bell Peppers (Whole Foods Market Red)"))
        foods.append(Food(name: "Cucumber", type: .produce, defaultAmount: 150, stepAmount: 25, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Cucumber (Wholesum Organic Mini, 1 lb)"))
        foods.append(Food(name: "Pumpkin Seeds", type: .nuts, defaultAmount: 30, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Pumpkin Seeds (365 by Whole Foods M 8 Ounce)"))
        foods.append(Food(name: "Nuts", type: .nuts, defaultAmount: 20, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Macadamia Nuts (Aurora 6 OZ)"))
        foods.append(Food(name: "Mackerel", type: .proteins, defaultAmount: 1, stepAmount: 1, consumptionUnit: .can, consumptionGrams: 85, currentIngredientName: "Mackerel (Skinless Boneless)"))
        foods.append(Food(name: "Sardines", type: .proteins, defaultAmount: 1, stepAmount: 1, consumptionUnit: .can, consumptionGrams: 85, currentIngredientName: "Sardines (H2O)"))
        foods.append(Food(name: "Tuna", type: .proteins, defaultAmount: 1, stepAmount: 1, consumptionUnit: .can, consumptionGrams: 85, currentIngredientName: "Tuna (Wild Planet 5 Ounce)"))
        foods.append(Food(name: "Mustard", type: .carbs, defaultAmount: 1, stepAmount: 1, consumptionUnit: .tablespoon, consumptionGrams: 15, currentIngredientName: "Mustard (Organicville 12 oz)"))
        foods.append(Food(name: "Fish Oil", type: .supplement, defaultAmount: 1, stepAmount: 0.5, consumptionUnit: .tablespoon, consumptionGrams: 14, currentIngredientName: "Fish Oil"))
        foods.append(Food(name: "Extra Virgin Olive Oil", type: .oils, defaultAmount: 2, stepAmount: 0.5, consumptionUnit: .tablespoon, consumptionGrams: 14, currentIngredientName: "Extra Virgin Olive Oil"))

        // cheese
        foods.append(Food(name: "Cheese", type: .cheese, defaultAmount: 25, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Manchego (Corcuera)"))
        foods.append(Food(name: "String Cheese", type: .cheese, defaultAmount: 5, stepAmount: 1, consumptionUnit: .piece, consumptionGrams: 28, currentIngredientName: "String Cheese (365 by Whole Foods M 12 OZ)"))
        foods.append(Food(name: "Cheese Slice", type: .cheese, defaultAmount: 4, stepAmount: 1, consumptionUnit: .slice, consumptionGrams: 28, currentIngredientName: "Cheese Slice (Trader Joe's Colby Jack, 12 oz)"))

        // proteins
        foods.append(Food(name: "Starbucks Protein Box", type: .proteins, defaultAmount: 1, stepAmount: 1, consumptionUnit: .piece, consumptionGrams: 247, currentIngredientName: "Eggs & Cheddar Protein Box"))
        foods.append(Food(name: "Turkey", type: .proteins, defaultAmount: 1, stepAmount: 1, consumptionUnit: .slice, consumptionGrams: 28, currentIngredientName: "Turkey W"))
        foods.append(Food(name: "Milk", type: .proteins, defaultAmount: 1, stepAmount: 1, consumptionUnit: .cup, consumptionGrams: 240, currentIngredientName: "Milk (Clover Sonoma Pasture Raised Organic Whole, 1 Gal)"))

        // fruit
        foods.append(Food(name: "Blackberries", type: .fruit, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Blackberries (Whole Foods Market 6 oz)"))
        foods.append(Food(name: "Blueberries", type: .fruit, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Blueberries (365 by Whole Foods M 32 Ounce)"))
        foods.append(Food(name: "Strawberries", type: .fruit, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Strawberries (Whole Foods Market 1 lb)"))
        foods.append(Food(name: "Raspberries", type: .fruit, defaultAmount: 50, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Raspberries (Whole Foods Market 6 oz)"))
        foods.append(Food(name: "Orange", type: .fruit, defaultAmount: 140, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Navel Orange (Whole Foods Market)"))
        foods.append(Food(name: "Clementine", type: .fruit, defaultAmount: 74, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Clementine (Whole Foods Market 3 lb Bag)"))

        // carbs
        foods.append(Food(name: "Bread", type: .carbs, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Bread (Food for Life 24 OZ)"))
        foods.append(Food(name: "Sunflower Butter", type: .carbs, defaultAmount: 2, stepAmount: 1, consumptionUnit: .tablespoon, consumptionGrams: 15, currentIngredientName: "Sunflower Butter (Once Again)"))
        foods.append(Food(name: "Peanut Butter", type: .carbs, defaultAmount: 2, stepAmount: 1, consumptionUnit: .tablespoon, consumptionGrams: 15, currentIngredientName: "Peanut Butter (Once Again)"))
        foods.append(Food(name: "Jelly", type: .carbs, consumptionUnit: .tablespoon, consumptionGrams: 18, currentIngredientName: "Jelly"))
        foods.append(Food(name: "Latte (Grande Hot)", type: .carbs, consumptionUnit: .cup, consumptionGrams: 1, currentIngredientName: "Latte (Grande Hot)"))
        foods.append(Food(name: "Latte (Venti Iced)", type: .carbs, consumptionUnit: .cup, consumptionGrams: 1, currentIngredientName: "Latte (Venti Iced)"))
        foods.append(Food(name: "Starbucks Breakfast Sandwich", type: .carbs, consumptionUnit: .piece, consumptionGrams: 120, currentIngredientName: "Bacon, Gouda & Egg Sandwich"))
        foods.append(Food(name: "Starbucks Sandwich", type: .carbs, consumptionUnit: .piece, consumptionGrams: 176, currentIngredientName: "Ham & Swiss on Baguette"))

        // meats
        foods.append(Food(name: "Beef", type: .meat, defaultAmount: 200, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Beef (ButcherBox)"))
        foods.append(Food(name: "Bison", type: .meat, defaultAmount: 400, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Bison"))
        foods.append(Food(name: "Chicken", type: .meat, defaultAmount: 450, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Chicken (Mary's Chicken)"))
        foods.append(Food(name: "Lamb", type: .meat, defaultAmount: 400, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Lamb"))
        foods.append(Food(name: "Pork Chop", type: .meat, defaultAmount: 450, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Pork Chop"))
        foods.append(Food(name: "Salmon", type: .meat, defaultAmount: 425, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Salmon (Whole Foods Market)"))
        foods.append(Food(name: "Top Sirloin Cap", type: .meat, defaultAmount: 425, stepAmount: 5, consumptionUnit: .gram, consumptionGrams: 1, currentIngredientName: "Top Sirloin Cap"))

        // supplements
        foods.append(Food(name: "Thorne Basic Nutrients 2/Day", type: .supplement, consumptionUnit: .pill, consumptionGrams: 1, currentIngredientName: "Thorne Basic Nutrients 2/Day"))
        foods.append(Food(name: "Creatine", type: .supplement, consumptionUnit: .pill, consumptionGrams: 0.75, currentIngredientName: "Creatine HCl"))
        foods.append(Food(name: "Glycine", type: .supplement, consumptionUnit: .pill, consumptionGrams: 3, currentIngredientName: "Glycine"))
        foods.append(Food(name: "Apigenin", type: .supplement, consumptionUnit: .pill, consumptionGrams: 0.05, currentIngredientName: "Apigenin"))
        foods.append(Food(name: "L-Theanine", type: .supplement, consumptionUnit: .pill, consumptionGrams: 0.2, currentIngredientName: "L-Theanine"))
        foods.append(Food(name: "SlowMag", type: .supplement, consumptionUnit: .pill, consumptionGrams: 1, currentIngredientName: "SlowMag"))
        foods.append(Food(name: "Taurine", type: .supplement, consumptionUnit: .pill, consumptionGrams: 1, currentIngredientName: "Taurine"))
        foods.append(Food(name: "Vitamin D3 (1000 IU)", type: .supplement, consumptionUnit: .pill, consumptionGrams: 1, currentIngredientName: "Vitamin D3 (1000 IU)"))
    }


    // Category resolution helpers — type lives only on Food now, so
    // every "is this ingredient a meat / supplement / what type"
    // question routes through here.
    func type(of ingredient: Ingredient) -> IngredientType? {
        getByName(name: ingredient.foodName)?.type
    }

    func isMeat(_ i: Ingredient) -> Bool {
        type(of: i) == .meat
    }

    func isSupplement(_ i: Ingredient) -> Bool {
        type(of: i) == .supplement
    }


    // Seed (append) position of a Food in `foods`. Since `foods`
    // preserves init() append order at runtime, this is the
    // authoritative within-category display order. Unknown name =>
    // Int.max so it sorts last (mirrors the type(of:) helper shape).
    func seedOrder(ofFoodNamed name: String) -> Int {
        foods.firstIndex { $0.name == name } ?? Int.max
    }

    func seedOrder(of ingredient: Ingredient) -> Int {
        seedOrder(ofFoodNamed: ingredient.foodName)
    }


    // Portion-config resolution. The Food owns the primary value;
    // an ingredient's own value is an override that wins when != 0.

    // Effective seed amount for a new meal row. Resolution order:
    //   1. profile per-Food override (profile.defaults[foodName]) — the
    //      ACTIVE profile gets its own meal default per Food. Caller
    //      passes profileMgr.profile so meal-add code can be profile-
    //      aware without coupling Food to ProfileMgr.
    //   2. ingredient.defaultAmount (variant-level override, != 0)
    //   3. Food.defaultAmount (group-level baseline, 0 = no preset)
    func effectiveDefaultAmount(for i: Ingredient, profile: Profile? = nil) -> Double {
        if let p = profile?.defaults[i.foodName], p > 0 { return p }
        return i.defaultAmount != 0
            ? i.defaultAmount
            : (getByName(name: i.foodName)?.defaultAmount ?? 0)
    }

    // Raw Food-level step for this ingredient's Food (0 if none).
    // The ingredient-wins + auto-heuristic combination is applied at
    // the step call site (AmountStepper.effectiveStep).
    func foodStepAmount(for i: Ingredient) -> Double {
        getByName(name: i.foodName)?.stepAmount ?? 0
    }


    // Consumption-unit resolution. Unlike defaultAmount the Food is
    // the authoritative source — every member of a Food is consumed
    // in the same unit, so there is no ingredient-level override that
    // "wins". The ingredient's own stored value is used only as a
    // defensive fallback if the Food can't be found (e.g. an
    // ungrouped ingredient with empty foodName), mirroring the shape
    // of effectiveDefaultAmount(for:).
    func consumptionUnit(for i: Ingredient) -> Unit {
        getByName(name: i.foodName)?.consumptionUnit ?? i.consumptionUnit
    }

    func consumptionGrams(for i: Ingredient) -> Double {
        getByName(name: i.foodName)?.consumptionGrams ?? i.consumptionGrams
    }


    // Foods sorted by category (IngredientType.sortRank) then seed
    // (append) order — the order foods.append(...) appears in
    // init(). Name is only the final stable fallback.
    var foodsSorted: [Food] {
        foods.enumerated().sorted { lhs, rhs in
            let a = lhs.element, b = rhs.element
            if a.type.sortRank != b.type.sortRank {
                return a.type.sortRank < b.type.sortRank
            }
            if lhs.offset != rhs.offset {
                return lhs.offset < rhs.offset
            }
            return a.name < b.name
        }.map { $0.element }
    }

    // Food names in category (sortRank) then name order — the order
    // user-facing Food pickers should present.
    var namesSorted: [String] {
        foodsSorted.map { $0.name }
    }


    func getByName(name: String) -> Food? {
        foods.first { $0.name == name }
    }


    var names: [String] {
        foods.map { $0.name }.sorted()
    }


    // Create the food if it doesn't exist yet (first member added
    // becomes the default). Idempotent — returns the existing food
    // untouched if the name is already known.
    @discardableResult
    func ensure(name: String, defaultMember: String, type: IngredientType) -> Food {
        if let existing = getByName(name: name) { return existing }
        let f = Food(name: name, type: type, currentIngredientName: defaultMember)
        foods.append(f)
        return f
    }


    func setCurrent(food name: String, member: String) {
        guard let idx = foods.firstIndex(where: { $0.name == name }) else { return }
        foods[idx].currentIngredientName = member
    }


    // Drop a food entirely (e.g. its last member was unassigned).
    func remove(name: String) {
        foods.removeAll { $0.name == name }
    }


    func serialize() {
        if let data = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(data, forKey: "food")
        }
    }
}


// ============================================================
// FoodComposite — a named recipe of Food components (PB&J =
// Bread + Peanut Butter + Jelly). A component references a Food
// by name; at meal time it resolves to that Food's currently
// selected variant. `amount` is in that variant's consumption
// unit. Swapping a component's brand/size is just changing the
// referenced Food's selected variant.
// ============================================================
struct CompositeComponent: Codable, Equatable, Identifiable {
    var id: String { foodName }
    var foodName: String
    var amount: Double
}

struct FoodComposite: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var components: [CompositeComponent]

    init(id: String = UUID().uuidString,
         name: String,
         components: [CompositeComponent]) {
        self.id = id
        self.name = name
        self.components = components
    }
}


class FoodCompositeMgr: ObservableObject {

    @Published var composites: [FoodComposite] = [] {
        didSet { serialize() }
    }

    private(set) var profileId: String

    // Per-profile pattern: composites are stored under a per-profile
    // UserDefaults key ("foodComposite.<profileId>") so switching the
    // active profile swaps the composite library. On first load for a
    // given profile, we attempt a one-shot migration from the legacy
    // unkeyed "foodComposite" store (gated by a per-profile flag), then
    // seed defaults if still empty. Use reload(forProfileId:) to swap
    // the active profile at runtime.
    init(profileId: String) {
        self.profileId = profileId
        deserialize()
        if composites.isEmpty { seed() }
    }

    func reload(forProfileId newId: String) {
        self.profileId = newId
        deserialize()
        if composites.isEmpty { seed() }
    }

    func getByName(name: String) -> FoodComposite? {
        composites.first { $0.name == name }
    }

    var names: [String] { composites.map { $0.name }.sorted() }

    @discardableResult
    func create(name: String, components: [CompositeComponent]) -> FoodComposite {
        if let existing = getByName(name: name) { return existing }
        let c = FoodComposite(name: name, components: components)
        composites.append(c)
        return c
    }

    func update(_ composite: FoodComposite) {
        if let i = composites.firstIndex(where: { $0.id == composite.id }) {
            composites[i] = composite
        }
    }

    func remove(name: String) {
        composites.removeAll { $0.name == name }
    }

    // Default composites — the swappable replacements for the
    // retired flat PBJ*/SJ*/…W seed ingredients.
    private func seed() {
        composites = [
            FoodComposite(name: "PB&J", components: [
                CompositeComponent(foodName: "Bread", amount: 2),
                CompositeComponent(foodName: "Peanut Butter", amount: 2),
                CompositeComponent(foodName: "Jelly", amount: 1),
            ]),
            FoodComposite(name: "SunButter & Jelly", components: [
                CompositeComponent(foodName: "Bread", amount: 2),
                CompositeComponent(foodName: "Sunflower Butter", amount: 2),
                CompositeComponent(foodName: "Jelly", amount: 1),
            ]),
            FoodComposite(name: "Wrap", components: [
                CompositeComponent(foodName: "Bread", amount: 1),
                CompositeComponent(foodName: "Turkey", amount: 3),
                CompositeComponent(foodName: "Cheese", amount: 1),
                CompositeComponent(foodName: "String Cheese", amount: 1),
            ]),
        ]
    }

    private var storageKey: String { "foodComposite.\(profileId)" }

    func serialize() {
        if let data = try? JSONEncoder().encode(composites) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    func deserialize() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([FoodComposite].self, from: data) {
            self.composites = saved
            return
        }
        // One-shot migration from the legacy unkeyed "foodComposite"
        // store. Only the FIRST profile to load post-refactor consumes
        // it (gated by the global "foodComposite.legacyConsumed" flag);
        // later profiles fall through to seed() defaults via the
        // caller's "if composites.isEmpty { seed() }" path.
        let migratedFlagKey = "foodComposite.migrated.\(profileId)"
        let legacyConsumedKey = "foodComposite.legacyConsumed"
        if !UserDefaults.standard.bool(forKey: migratedFlagKey) {
            UserDefaults.standard.set(true, forKey: migratedFlagKey)
            if !UserDefaults.standard.bool(forKey: legacyConsumedKey),
               let legacyData = UserDefaults.standard.data(forKey: "foodComposite"),
               let legacy = try? JSONDecoder().decode([FoodComposite].self, from: legacyData) {
                self.composites = legacy
                UserDefaults.standard.set(true, forKey: legacyConsumedKey)
                if let data = try? JSONEncoder().encode(legacy) {
                    UserDefaults.standard.set(data, forKey: storageKey)
                }
                return
            }
        }
        self.composites = []
    }
}
