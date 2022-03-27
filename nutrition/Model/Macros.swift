import Foundation

class MacrosMgr: ObservableObject {

    @Published var macros: Macros

    init() {
        macros = Macros()
    }

    func setGoals(caloriesGoalUnadjusted: Float, caloriesGoal: Float, fatGoal: Float, fiberMinimum: Float, netCarbsMaximum: Float, proteinGoal: Float) {
        self.macros = macros.setGoals(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberMinimum: fiberMinimum, netCarbsMaximum: netCarbsMaximum, proteinGoal: proteinGoal)
    }

    func addMacros(name: String, calories: Float, fat: Float, fiber: Float, netCarbs: Float, protein: Float) {
        self.macros = macros.addMacros(calories: calories, fat: fat, fiber: fiber, netCarbs: netCarbs, protein: protein)
    }
}

struct Macros {
    var caloriesGoalUnadjusted: Float

    var caloriesGoal: Float
    var fatGoal: Float
    var fiberMinimum: Float
    var netCarbsMaximum: Float
    var proteinGoal: Float

    var calories: Float
    var fat: Float
    var fiber: Float
    var netCarbs: Float
    var protein: Float

    init(caloriesGoalUnadjusted: Float = 0, caloriesGoal: Float = 0, fatGoal: Float = 0, fiberMinimum: Float = 0, netCarbsMaximum: Float = 0, proteinGoal: Float = 0, calories: Float = 0, fat: Float = 0, fiber: Float = 0, netCarbs: Float = 0, protein: Float = 0) {
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

    func setGoals(caloriesGoalUnadjusted: Float, caloriesGoal: Float, fatGoal: Float, fiberMinimum: Float, netCarbsMaximum: Float, proteinGoal: Float) -> Macros {
        return Macros(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberMinimum: fiberMinimum, netCarbsMaximum: netCarbsMaximum, proteinGoal: proteinGoal)
    }

    func addMacros(calories: Float, fat: Float, fiber: Float, netCarbs: Float, protein: Float) -> Macros {
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
