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
    var defaultMemberName: String

    init(id: String = UUID().uuidString,
         name: String,
         defaultMemberName: String) {
        self.id = id
        self.name = name
        self.defaultMemberName = defaultMemberName
    }
}


class FoodMgr: ObservableObject {

    @Published var groups: [Food] = [] {
        didSet { serialize() }
    }

    init() {
        deserialize()
    }


    func getByName(name: String) -> Food? {
        groups.first { $0.name == name }
    }


    var names: [String] {
        groups.map { $0.name }.sorted()
    }


    // Create the group if it doesn't exist yet (first member added
    // becomes the default). Idempotent — returns the existing group
    // untouched if the name is already known.
    @discardableResult
    func ensure(name: String, defaultMember: String) -> Food {
        if let existing = getByName(name: name) { return existing }
        let g = Food(name: name, defaultMemberName: defaultMember)
        groups.append(g)
        return g
    }


    func setDefault(group name: String, member: String) {
        guard let idx = groups.firstIndex(where: { $0.name == name }) else { return }
        groups[idx].defaultMemberName = member
    }


    // Drop a group entirely (e.g. its last member was unassigned).
    func remove(name: String) {
        groups.removeAll { $0.name == name }
    }


    // Create the Food entities implied by the seeded ingredients.
    // For each distinct non-empty foodName, the alphabetically-first
    // member becomes the default. ensure() is idempotent, so a user's
    // later default change is preserved across launches.
    func ensureSeededFoods(from ingredients: [Ingredient]) {
        let names = Set(ingredients.map { $0.foodName }.filter { !$0.isEmpty })
        for n in names {
            let members = ingredients.filter { $0.foodName == n }
                                     .map { $0.name }.sorted()
            if let first = members.first {
                ensure(name: n, defaultMember: first)
            }
        }
    }


    // ============================================================
    // Persistence — UserDefaults JSON, same shape as the other
    // managers. Unlike IngredientMgr, FoodMgr DOES deserialize on
    // init (groups are pure user data, not seeded in code).
    // ============================================================
    private let key = "food"
    private let legacyKey = "group"   // pre-rename data

    func serialize() {
        if let data = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func deserialize() {
        let data = UserDefaults.standard.data(forKey: key)
                 ?? UserDefaults.standard.data(forKey: legacyKey)
        guard
            let data = data,
            let saved = try? JSONDecoder().decode([Food].self, from: data)
        else { return }
        self.groups = saved
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
                CompositeComponent(foodName: "Hummus", amount: 2),
                CompositeComponent(foodName: "Turkey", amount: 3),
                CompositeComponent(foodName: "Cheddar Cheese", amount: 1),
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
