import Foundation

class MacrosMgr: ObservableObject {

    @Published var macros: Macros

    init() {
        macros = Macros()
    }

    func setGoals(caloriesGoalUnadjusted: Double, caloriesGoal: Double, fatGoal: Double, fiberGoal: Double, netcarbsGoal: Double, proteinGoal: Double) {
        self.macros = macros.setGoals(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberGoal: fiberGoal, netcarbsGoal: netcarbsGoal, proteinGoal: proteinGoal)
    }

    func addMacros(name: String, calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) {
        self.macros = macros.addMacros(calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
    }
}

struct Macros {
    var caloriesGoalUnadjusted: Double

    var caloriesGoal: Double
    var fatGoal: Double
    var fiberGoal: Double
    var netcarbsGoal: Double
    var proteinGoal: Double

    var calories: Double
    var fat: Double
    var fiber: Double
    var netcarbs: Double
    var protein: Double

    init(caloriesGoalUnadjusted: Double = 0, caloriesGoal: Double = 0, fatGoal: Double = 0, fiberGoal: Double = 0, netcarbsGoal: Double = 0, proteinGoal: Double = 0, calories: Double = 0, fat: Double = 0, fiber: Double = 0, netcarbs: Double = 0, protein: Double = 0) {
        self.caloriesGoalUnadjusted = caloriesGoalUnadjusted

        self.caloriesGoal = caloriesGoal
        self.fatGoal = fatGoal
        self.fiberGoal = fiberGoal
        self.netcarbsGoal = netcarbsGoal
        self.proteinGoal = proteinGoal

        self.calories = calories
        self.fat = fat
        self.fiber = fiber
        self.netcarbs = netcarbs
        self.protein = protein
    }

    func setGoals(caloriesGoalUnadjusted: Double, caloriesGoal: Double, fatGoal: Double, fiberGoal: Double, netcarbsGoal: Double, proteinGoal: Double) -> Macros {
        return Macros(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberGoal: fiberGoal, netcarbsGoal: netcarbsGoal, proteinGoal: proteinGoal)
    }

    func addMacros(calories: Double, fat: Double, fiber: Double, netcarbs: Double, protein: Double) -> Macros {
        return Macros(caloriesGoalUnadjusted: caloriesGoalUnadjusted, caloriesGoal: caloriesGoal, fatGoal: fatGoal, fiberGoal: fiberGoal, netcarbsGoal: netcarbsGoal, proteinGoal: proteinGoal, calories: self.calories + calories, fat: self.fat + fat, fiber: self.fiber + fiber, netcarbs: self.netcarbs + netcarbs, protein: self.protein + protein)
    }

    func p() {
        print(caloriesGoal)
        print(fatGoal)
        print(fiberGoal)
        print(netcarbsGoal)
        print(proteinGoal)
        print(calories)
        print(fat)
        print(fiber)
        print(netcarbs)
        print(protein)
    }
}
