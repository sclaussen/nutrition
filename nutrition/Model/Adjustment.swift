import Foundation

class AdjustmentMgr: ObservableObject {

    @Published var adjustments: [Adjustment] = [] {
        didSet {
            serialize()
        }
    }

    init() {
        adjustments.append(Adjustment(name: "Mackerel", amount: 1, consumptionUnit: Unit.can, group: "fish", constraints: true, maximum: 2))
        adjustments.append(Adjustment(name: "Sardines", amount: 1, consumptionUnit: Unit.can, group: "fish", constraints: true, maximum: 2))
        adjustments.append(Adjustment(name: "Smoked Sardines", amount: 1, consumptionUnit: Unit.can, group: "fish", constraints: true, maximum: 2))
        adjustments.append(Adjustment(name: "Eggs", amount: 1, consumptionUnit: Unit.egg, constraints: true, maximum: 7))
        adjustments.append(Adjustment(name: "Extra Virgin Olive Oil", amount: 0.5, consumptionUnit: Unit.tablespoon, constraints: true, maximum: 4.5))
        adjustments.append(Adjustment(name: "Broccoli", amount: 20, group: "vege", constraints: true, maximum: 300))
        adjustments.append(Adjustment(name: "Cauliflower", amount: 20, group: "vege", constraints: true, maximum: 300))
        adjustments.append(Adjustment(name: "Pumpkin Seeds", amount: 10, group: "vege"))
        adjustments.append(Adjustment(name: "String Cheese", amount: 1, consumptionUnit: Unit.stick))
        adjustments.append(Adjustment(name: "Macadamia Nuts", amount: 5))
        adjustments.append(Adjustment(name: "Dark Chocolate (Divine)", amount: 1, consumptionUnit: Unit.piece))
    }

    func serialize() {
        if let encodedData = try? JSONEncoder().encode(adjustments) {
            UserDefaults.standard.set(encodedData, forKey: "adjustment")
        }
    }

    func deserialize() {
        guard
          let data = UserDefaults.standard.data(forKey: "adjustment"),
          let savedItems = try? JSONDecoder().decode([Adjustment].self, from: data)
        else {
            return
        }

        self.adjustments = savedItems
    }

    func create(name: String,
                amount: Float,
                consumptionUnit: Unit,
                group: String = "",
                active: Bool = true) {
        let adjustment = Adjustment(name: name,
                                    amount: amount,
                                    consumptionUnit: consumptionUnit,
                                    group: group,
                                    active: active)
        adjustments.append(adjustment)
    }

    func get(includeInactive: Bool = false) -> [Adjustment] {
        if includeInactive {
            return adjustments
        }
        return adjustments.filter({ $0.active == true })
    }

    func getNames() -> [String] {
        return adjustments.map { $0.name }
    }

    func update(_ adjustment: Adjustment) {
        if let index = adjustments.firstIndex(where: { $0.id == adjustment.id }) {
            adjustments[index] = adjustment.update(adjustment: adjustment)
        }
    }

    func activate(_ name: String) {
        if let index = adjustments.firstIndex(where: { $0.name == name }) {
            if !adjustments[index].active {
                adjustments[index] = adjustments[index].toggleActive()
            }
            print("  \(adjustments[index].name) active: \(adjustments[index].active) (adjustment)")
        }
    }

    func deactivate(_ name: String) {
        if let index = adjustments.firstIndex(where: { $0.name == name }) {
            if adjustments[index].active {
                adjustments[index] = adjustments[index].toggleActive()
            }
            print("  \(adjustments[index].name) active: \(adjustments[index].active) (adjustment)")
        }
    }

    func inactiveIngredientsExist() -> Bool {
        let inactiveIngredients = adjustments.filter({ $0.active == false })
        return inactiveIngredients.count > 0
    }

    func toggleActive(_ adjustment: Adjustment) -> Adjustment? {
        if let index = adjustments.firstIndex(where: { $0.id == adjustment.id }) {
            adjustments[index] = adjustment.toggleActive()
            return adjustments[index]
        }
        return nil
    }

    func move(from: IndexSet, to: Int) {
        adjustments.move(fromOffsets: from, toOffset: to)
    }

    func deleteSet(indexSet: IndexSet) {
        adjustments.remove(atOffsets: indexSet)
    }

    func delete(_ adjustment: Adjustment) {
        if let index = adjustments.firstIndex(where: { $0.id == adjustment.id }) {
            adjustments.remove(at: index)
        }
    }
}

struct Adjustment: Codable, Identifiable {
    var id: String
    var name: String
    var amount: Float
    var consumptionUnit: Unit

    var group: String

    var constraints : Bool
    var maximum: Float
    var active: Bool

    init(id: String = UUID().uuidString, name: String, amount: Float, consumptionUnit: Unit = Unit.gram, group: String = "", constraints: Bool = false, maximum: Float = 0, active: Bool = true) {
        self.id = id
        self.name = name
        self.amount = amount
        self.consumptionUnit = consumptionUnit
        self.group = group
        self.constraints = constraints
        self.maximum = maximum
        self.active = active
    }

    func toggleActive() -> Adjustment {
        return Adjustment(id: id, name: name, amount: amount, consumptionUnit: consumptionUnit, group: group, constraints: constraints, maximum: maximum, active: !active)
    }

    func update(adjustment: Adjustment) -> Adjustment {
        return Adjustment(id: adjustment.id, name: adjustment.name, amount: adjustment.amount, consumptionUnit: adjustment.consumptionUnit, group: adjustment.group, constraints: adjustment.constraints, maximum: adjustment.maximum, active: adjustment.active)
    }
}
