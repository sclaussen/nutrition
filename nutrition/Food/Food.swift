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
    var currentIngredientName: String

    init(id: String = UUID().uuidString,
         name: String,
         type: IngredientType,
         defaultAmount: Double = 0,
         stepAmount: Double = 0,
         currentIngredientName: String) {
        self.id = id
        self.name = name
        self.type = type
        self.defaultAmount = defaultAmount
        self.stepAmount = stepAmount
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
        // Grouped by IngredientType.sortRank, alphabetical within
        // each group.

        // Boil Broccoli & Cauliflower
        foods.append(Food(name: "Broccoli", type: .produce, defaultAmount: 85, stepAmount: 5, currentIngredientName: "Broccoli (365 by Whole Foods M 32 Ounce)"))
        foods.append(Food(name: "Cauliflower", type: .produce, defaultAmount: 100, stepAmount: 5, currentIngredientName: "Cauliflower (365 by Whole Foods M 12 Ounce)"))

        // Cook Eggs
        foods.append(Food(name: "Coconut Oil", type: .oils, defaultAmount: 14, stepAmount: 5, currentIngredientName: "Coconut Oil (365 by Whole Foods M 14 Fl Oz)"))
        foods.append(Food(name: "Avocado Oil", type: .oils, currentIngredientName: "Avocado Oil"))
        foods.append(Food(name: "Eggs", type: .proteins, defaultAmount: 50, stepAmount: 5, currentIngredientName: "Eggs (365 by Whole Foods M 18 Count)"))

        // Salad
        foods.append(Food(name: "Romaine", type: .produce, stepAmount: 5, currentIngredientName: "Romaine"))
        foods.append(Food(name: "Spinach", type: .produce, defaultAmount: 85, stepAmount: 5, currentIngredientName: "Spinach (365 by Whole Foods M 5 oz)"))
        foods.append(Food(name: "Arugula", type: .produce, defaultAmount: 20, stepAmount: 5, currentIngredientName: "Arugula (365 by Whole Foods M 5 OZ)"))
        foods.append(Food(name: "Mushrooms", type: .produce, defaultAmount: 84, stepAmount: 5, currentIngredientName: "Mushrooms (365 by Whole Foods M 8 Ounce)"))
        foods.append(Food(name: "Radish", type: .produce, defaultAmount: 85, stepAmount: 5, currentIngredientName: "Radish (Whole Foods Market 12 Oz)"))
        foods.append(Food(name: "Avocado", type: .produce, defaultAmount: 50, stepAmount: 5, currentIngredientName: "Avocado (365 by Whole Foods M 4 Count)"))
        foods.append(Food(name: "Pumpkin Seeds", type: .nuts, defaultAmount: 28, stepAmount: 5, currentIngredientName: "Pumpkin Seeds (365 by Whole Foods M 8 Ounce)"))
        foods.append(Food(name: "Nuts", type: .nuts, defaultAmount: 30, stepAmount: 5, currentIngredientName: "Macadamia Nuts (Aurora 6 OZ)"))
        foods.append(Food(name: "Mackerel", type: .proteins, currentIngredientName: "Mackerel (Skinless Boneless)"))
        foods.append(Food(name: "Sardines", type: .proteins, currentIngredientName: "Sardines (H2O)"))
        foods.append(Food(name: "Tuna", type: .proteins, defaultAmount: 85, stepAmount: 5, currentIngredientName: "Tuna (Wild Planet 5 Ounce)"))
        foods.append(Food(name: "Mustard", type: .carbs, defaultAmount: 5, stepAmount: 5, currentIngredientName: "Mustard (Organicville 12 oz)"))
        foods.append(Food(name: "Fish Oil", type: .supplement, currentIngredientName: "Fish Oil"))
        foods.append(Food(name: "Extra Virgin Olive Oil", type: .oils, currentIngredientName: "Extra Virgin Olive Oil"))

        // cheese
        foods.append(Food(name: "Babybel Cheese", type: .cheese, defaultAmount: 20, stepAmount: 5, currentIngredientName: "Babybel Cheese (Babybel 12 Count)"))
        foods.append(Food(name: "Cheese", type: .cheese, currentIngredientName: "Manchego (Corcuera)"))
        foods.append(Food(name: "String Cheese", type: .cheese, currentIngredientName: "String Cheese (365 by Whole Foods M 12 OZ)"))

        // proteins
        foods.append(Food(name: "Starbucks Protein Box", type: .proteins, currentIngredientName: "Eggs & Cheddar Protein Box"))
        foods.append(Food(name: "Turkey", type: .proteins, currentIngredientName: "Turkey W"))

        // fruit
        foods.append(Food(name: "Blackberries", type: .fruit, defaultAmount: 72, stepAmount: 5, currentIngredientName: "Blackberries (Whole Foods Market 6 oz)"))
        foods.append(Food(name: "Blueberries", type: .fruit, defaultAmount: 140, stepAmount: 5, currentIngredientName: "Blueberries (365 by Whole Foods M 32 Ounce)"))

        // carbs
        foods.append(Food(name: "Bread", type: .carbs, currentIngredientName: "Bread (Food for Life 24 OZ)"))
        foods.append(Food(name: "Sunflower Butter", type: .carbs, defaultAmount: 30, stepAmount: 5, currentIngredientName: "Sunflower Butter (Once Again)"))
        foods.append(Food(name: "Peanut Butter", type: .carbs, defaultAmount: 30, stepAmount: 5, currentIngredientName: "Peanut Butter (Once Again)"))
        foods.append(Food(name: "Jelly", type: .carbs, currentIngredientName: "Jelly"))
        foods.append(Food(name: "Latte (Grande Hot)", type: .carbs, currentIngredientName: "Latte (Grande Hot)"))
        foods.append(Food(name: "Latte (Venti Iced)", type: .carbs, currentIngredientName: "Latte (Venti Iced)"))
        foods.append(Food(name: "Starbucks Breakfast Sandwich", type: .carbs, currentIngredientName: "Bacon, Gouda & Egg Sandwich"))
        foods.append(Food(name: "Starbucks Sandwich", type: .carbs, currentIngredientName: "Ham & Swiss on Baguette"))

        // meats
        foods.append(Food(name: "Beef", type: .meat, defaultAmount: 113, stepAmount: 5, currentIngredientName: "Beef (ButcherBox)"))
        foods.append(Food(name: "Bison", type: .meat, currentIngredientName: "Bison"))
        foods.append(Food(name: "Chicken", type: .meat, defaultAmount: 112, stepAmount: 5, currentIngredientName: "Chicken (Mary's Chicken)"))
        foods.append(Food(name: "Lamb", type: .meat, currentIngredientName: "Lamb"))
        foods.append(Food(name: "Pork Chop", type: .meat, currentIngredientName: "Pork Chop"))
        foods.append(Food(name: "Salmon", type: .meat, defaultAmount: 113, stepAmount: 5, currentIngredientName: "Salmon (Whole Foods Market)"))
        foods.append(Food(name: "Top Sirloin Cap", type: .meat, currentIngredientName: "Top Sirloin Cap"))

        // supplements
        foods.append(Food(name: "Thorne Basic Nutrients 2/Day", type: .supplement, currentIngredientName: "Thorne Basic Nutrients 2/Day"))
        foods.append(Food(name: "Creatine", type: .supplement, currentIngredientName: "Creatine HCl"))
        foods.append(Food(name: "Glycine", type: .supplement, currentIngredientName: "Glycine"))
        foods.append(Food(name: "Apigenin", type: .supplement, currentIngredientName: "Apigenin"))
        foods.append(Food(name: "L-Theanine", type: .supplement, currentIngredientName: "L-Theanine"))
        foods.append(Food(name: "SlowMag", type: .supplement, currentIngredientName: "SlowMag"))
        foods.append(Food(name: "Taurine", type: .supplement, currentIngredientName: "Taurine"))
        foods.append(Food(name: "Vitamin D3 (1000 IU)", type: .supplement, currentIngredientName: "Vitamin D3 (1000 IU)"))
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

    // Effective seed amount for a new meal row: ingredient override
    // (!= 0) else the Food-level default (0 = no preset).
    func effectiveDefaultAmount(for i: Ingredient) -> Double {
        i.defaultAmount != 0 ? i.defaultAmount : (getByName(name: i.foodName)?.defaultAmount ?? 0)
    }

    // Raw Food-level step for this ingredient's Food (0 if none).
    // The ingredient-wins + auto-heuristic combination is applied at
    // the step call site (AmountStepper.effectiveStep).
    func foodStepAmount(for i: Ingredient) -> Double {
        getByName(name: i.foodName)?.stepAmount ?? 0
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

    init() {
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

    private let key = "foodComposite"

    func serialize() {
        if let data = try? JSONEncoder().encode(composites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func deserialize() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([FoodComposite].self, from: data)
        else { return }
        self.composites = saved
    }
}
