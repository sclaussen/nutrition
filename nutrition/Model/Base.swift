import Foundation

class BaseMgr: ObservableObject {

    @Published var bases: [Base] = [] {
        didSet {
            serialize()
        }
    }

    init() {
        bases.append(Base(name: "Coconut Oil", defaultAmount: 1, amount: 1, consumptionUnit: Unit.tablespoon))
        bases.append(Base(name: "Eggs", defaultAmount: 5, amount: 5, consumptionUnit: Unit.egg))
        bases.append(Base(name: "Serrano Pepper", defaultAmount: 70, amount: 70, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Broccoli", defaultAmount: 60, amount: 60, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Cauliflower", defaultAmount: 60, amount: 60, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Arugula", defaultAmount: 145, amount: 145, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Romaine", defaultAmount: 200, amount: 200, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Collared Greens", defaultAmount: 50, amount: 50, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Mushrooms", defaultAmount: 100, amount: 100, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Radish", defaultAmount: 100, amount: 100, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Avocado", defaultAmount: 140, amount: 140, consumptionUnit: Unit.gram))
        bases.append(Base(name: "Mackerel", defaultAmount: 1, amount: 1, consumptionUnit: Unit.can, active: false))
        bases.append(Base(name: "Sardines", defaultAmount: 1, amount: 1, consumptionUnit: Unit.can, active: false))
        bases.append(Base(name: "Smoked Sardines", defaultAmount: 1, amount: 1, consumptionUnit: Unit.can, active: false))
        bases.append(Base(name: "Mustard", defaultAmount: 4, amount: 4, consumptionUnit: Unit.tablespoon))
        bases.append(Base(name: "Fish Oil", defaultAmount: 1, amount: 1, consumptionUnit: Unit.tablespoon))
        bases.append(Base(name: "Extra Virgin Olive Oil", defaultAmount: 3, amount: 3, consumptionUnit: Unit.tablespoon))
    }

    func serialize() {
        print("Serializing base...")
        if let encodedData = try? JSONEncoder().encode(bases) {
            UserDefaults.standard.set(encodedData, forKey: "base")
        }
    }

    func deserialize() {
        print("Deserializing base...")
        guard
          let data = UserDefaults.standard.data(forKey: "base"),
          let savedItems = try? JSONDecoder().decode([Base].self, from: data)
        else {
            return
        }

        self.bases = savedItems
    }

    func create(name: String, defaultAmount: Double, amount: Double, consumptionUnit: Unit, active: Bool) {
        let base = Base(name: name, defaultAmount: defaultAmount, amount: amount, consumptionUnit: consumptionUnit, active: active)
        bases.append(base)
    }

    func get(includeInactive: Bool) -> [Base] {
        if includeInactive {
            return bases
        }
        return bases.filter({ $0.active == true })
    }

    func getPickerOptions(existing: [String]) -> [String] {
        let existingSet = Set(existing)
        var basesSet = Set(bases.map { $0.name })
        basesSet.subtract(existingSet)
        var pickerOptions = [String](basesSet)
        pickerOptions.sort()
        return pickerOptions
    }

    func inactiveIngredientsExist() -> Bool {
        let inactiveIngredients = bases.filter({ $0.active == false })
        print("Inactive ingredient count: " + String(inactiveIngredients.count))
        return inactiveIngredients.count > 0
    }

    func getNames() -> [String] {
        return bases.map { $0.name }
    }

    func update(_ base: Base) {
        if let index = bases.firstIndex(where: { $0.id == base.id }) {
            bases[index] = base.update(base: base)
        }
    }

    func deactivate(_ name: String) {
        if let index = bases.firstIndex(where: { $0.name == name }) {
            if bases[index].active {
                bases[index] = bases[index].toggleActive()
            }
        }
    }

    func toggleActive(_ base: Base) -> Base? {
        if let index = bases.firstIndex(where: { $0.id == base.id }) {
            bases[index] = base.toggleActive()
            return bases[index]
        }
        return nil
    }

    func move(from: IndexSet, to: Int) {
        bases.move(fromOffsets: from, toOffset: to)
    }

    func deleteSet(indexSet: IndexSet) {
        bases.remove(atOffsets: indexSet)
    }

    func delete(_ base: Base) {
        if let index = bases.firstIndex(where: { $0.id == base.id }) {
            bases.remove(at: index)
        }
    }
}

struct Base: Codable, Identifiable {
    var id: String

    var name: String
    var defaultAmount: Double
    var amount: Double
    var consumptionUnit: Unit

    var active: Bool

    init(id: String = UUID().uuidString, name: String, defaultAmount: Double, amount: Double, consumptionUnit: Unit, active: Bool = true) {
        self.id = id
        self.name = name
        self.defaultAmount = defaultAmount
        self.amount = amount
        self.consumptionUnit = consumptionUnit
        self.active = active
    }

    func toggleActive() -> Base {
        return Base(id: id, name: name, defaultAmount: defaultAmount, amount: amount, consumptionUnit: consumptionUnit, active: !active);
    }

    func update(base: Base) -> Base {
        return Base(id: base.id, name: base.name, defaultAmount: base.defaultAmount, amount: base.amount, consumptionUnit: base.consumptionUnit, active: base.active);
    }
}
