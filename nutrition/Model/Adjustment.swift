import Foundation

class AdjustmentMgr: ObservableObject {

    @Published var adjustments: [Adjustment] = [] {
        didSet {
            serialize()
        }
    }

    init() {
        adjustments.append(Adjustment(name: "Eggs", amount: 1, consumptionUnit: "eggs", constraints: true, minimum: 4, maximum: 7))
        adjustments.append(Adjustment(name: "Mackerel", amount: 1, consumptionUnit: "cans", constraints: true, maximum: 2))
        adjustments.append(Adjustment(name: "Sardines", amount: 1, consumptionUnit: "cans", constraints: true, maximum: 2))
        adjustments.append(Adjustment(name: "Smoked Sardines", amount: 1, consumptionUnit: "cans", constraints: true, maximum: 2))
        adjustments.append(Adjustment(name: "Broccoli", amount: 25, consumptionUnit: "grams", maximum: 250))
        adjustments.append(Adjustment(name: "String Cheese", amount: 1, consumptionUnit: "sticks"))
        adjustments.append(Adjustment(name: "Extra Virgin Olive Oil", amount: 0.25, consumptionUnit: "tbsp", constraints: true, minimum: 2.5, maximum: 5))
        adjustments.append(Adjustment(name: "Pumpkin Seeds", amount: 5, consumptionUnit: "grams"))
        adjustments.append(Adjustment(name: "Macadamia Nuts", amount: 5, consumptionUnit: "grams", active: false))
  // - type: randomize
  //   select: 1
  //   adjustments:
  //     Cauliflower: 10
  //     Broccoli: 20
    }

    func serialize() {
        print("Serializing adjustment...")
        if let encodedData = try? JSONEncoder().encode(adjustments) {
            UserDefaults.standard.set(encodedData, forKey: "adjustment")
        }
    }

    func deserialize() {
        print("Deserializing adjustment...")
        guard
          let data = UserDefaults.standard.data(forKey: "adjustment"),
          let savedItems = try? JSONDecoder().decode([Adjustment].self, from: data)
        else {
            return
        }

        self.adjustments = savedItems
    }

    func create(name: String, amount: Double, consumptionUnit: String, active: Bool) {
        let adjustment = Adjustment(name: name, amount: amount, consumptionUnit: consumptionUnit, active: active)
        adjustments.append(adjustment)
    }

    func get(includeInactive: Bool) -> [Adjustment] {
        if includeInactive {
            return adjustments
        }

        return adjustments.filter({ $0.active == true })
    }

    func inactiveIngredientsExist() -> Bool {
        let inactiveIngredients = adjustments.filter({ $0.active == false })
        print("Inactive ingredient count: " + String(inactiveIngredients.count))
        return inactiveIngredients.count > 0
    }

    func getNames() -> [String] {
        return adjustments.map { $0.name }
    }

    func update(_ adjustment: Adjustment) {
        if let index = adjustments.firstIndex(where: { $0.id == adjustment.id }) {
            adjustments[index] = adjustment.update(adjustment: adjustment)
        }
    }

    func deactivate(_ name: String) {
        if let index = adjustments.firstIndex(where: { $0.name == name }) {
            if adjustments[index].active {
                adjustments[index] = adjustments[index].toggleActive()
            }
        }
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

// enum AdjustmentType: String, Codable {
//     case Normal:
//     case Random:
// }

// struct AdjustmentIngredient: Codable {
//     var name: String
//     var amount: Double
//     var consumptionUnit: String

//     var constraints : Bool
//     var minimum: Double
//     var maximum: Double
// }

struct Adjustment: Codable, Identifiable {
    var id: String
    var name: String
    var amount: Double
    var consumptionUnit: String

    var constraints : Bool
    var minimum: Double
    var maximum: Double
    var active: Bool
    // var type: AdjustmentType
    // var adjustmentIngredients: [AdjustmentIngredient] = []

    // init(id: String = UUID().uuidString, type: AdjustmentType, active: active) {
    //     self.id = id
    //     self.type = type
    //     self.adjustmentIngredients = adjustmentIngredients
    //     self.active = active
    // }

    // init(id: String = UUID().uuidString, type: AdjustmentType, active: active, adjustmentIngredients: [AdjustmentIngredient]) {
    //     self.id = id
    //     self.type = type
    //     self.adjustmentIngredients = adjustmentIngredients
    //     self.active = active
    // }

    init(id: String = UUID().uuidString, name: String, amount: Double, consumptionUnit: String, constraints: Bool = false, minimum: Double = 0, maximum: Double = 0, active: Bool = true) {
        self.id = id
        self.name = name
        self.amount = amount
        self.consumptionUnit = consumptionUnit
        self.constraints = constraints
        self.minimum = minimum
        self.maximum = maximum
        self.active = active
    }

    func toggleActive() -> Adjustment {
        return Adjustment(id: id, name: name, amount: amount, consumptionUnit: consumptionUnit, constraints: constraints, minimum: minimum, maximum: maximum, active: !active)
    }

    func update(adjustment: Adjustment) -> Adjustment {
        return Adjustment(id: adjustment.id, name: adjustment.name, amount: adjustment.amount, consumptionUnit: adjustment.consumptionUnit, constraints: adjustment.constraints, minimum: adjustment.minimum, maximum: adjustment.maximum, active: adjustment.active)
    }
}
