import Foundation

class MacrosMgr: ObservableObject {

    @Published var macros: Macros

    init() {
        macros = Macros()
    }

    func setMacroGoals(caloriesGoalUnadjusted: Double, caloriesGoal: Double, fatGoal: Double, fiberMinimum: Double, netCarbsMaximum: Double, proteinGoal: Double) {
        self.macros = macros.setMacroGoals(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberMinimum: fiberMinimum, netCarbsMaximum: netCarbsMaximum, proteinGoal: proteinGoal)
    }

    func addMacroActuals(name: String, calories: Double, fat: Double, fiber: Double, netCarbs: Double, protein: Double) {
        self.macros = macros.addMacroActuals(calories: calories, fat: fat, fiber: fiber, netCarbs: netCarbs, protein: protein)
    }
}

struct Macros {
    var caloriesGoalUnadjusted: Double

    var caloriesGoal: Double
    var fatGoal: Double
    var fiberMinimum: Double
    var netCarbsMaximum: Double
    var proteinGoal: Double

    var calories: Double
    var fat: Double
    var fiber: Double
    var netCarbs: Double
    var protein: Double

    init(caloriesGoalUnadjusted: Double = 0, caloriesGoal: Double = 0, fatGoal: Double = 0, fiberMinimum: Double = 0, netCarbsMaximum: Double = 0, proteinGoal: Double = 0, calories: Double = 0, fat: Double = 0, fiber: Double = 0, netCarbs: Double = 0, protein: Double = 0) {
        self.caloriesGoalUnadjusted = caloriesGoalUnadjusted

        self.caloriesGoal = caloriesGoal
        self.fatGoal = fatGoal
        self.fiberMinimum = fiberMinimum
        self.netCarbsMaximum = netCarbsMaximum
        self.proteinGoal = proteinGoal

        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netCarbs = netCarbs
        self.protein = protein
    }

    func setMacroGoals(caloriesGoalUnadjusted: Double, caloriesGoal: Double, fatGoal: Double, fiberMinimum: Double, netCarbsMaximum: Double, proteinGoal: Double) -> Macros {
        return Macros(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberMinimum: fiberMinimum, netCarbsMaximum: netCarbsMaximum, proteinGoal: proteinGoal)
    }

    func addMacroActuals(calories: Double, fat: Double, fiber: Double, netCarbs: Double, protein: Double) -> Macros {
        return Macros(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberMinimum: fiberMinimum, netCarbsMaximum: netCarbsMaximum, proteinGoal: proteinGoal, calories: self.calories + calories, fat: self.fat + fat, fiber: self.fiber + fiber, netCarbs: self.netCarbs + netCarbs, protein: self.protein + protein)
    }

    func p() {
        print(caloriesGoal)
        print(fatGoal)
        print(fiberMinimum)
        print(netCarbsMaximum)
        print(proteinGoal)
        print(calories)
        print(fat)
        print(fiber)
        print(netCarbs)
        print(protein)
    }
}
