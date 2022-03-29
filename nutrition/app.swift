import SwiftUI

@main
struct app: App {
    @StateObject var ingredientMgr: IngredientMgr = IngredientMgr()
    @StateObject var adjustmentMgr: AdjustmentMgr = AdjustmentMgr()
    @StateObject var mealIngredientMgr: MealIngredientMgr = MealIngredientMgr()
    @StateObject var macrosMgr: MacrosMgr = MacrosMgr()
    @StateObject var profileMgr: ProfileMgr = ProfileMgr()

    var body: some Scene {
        return WindowGroup {
            Tabs()
              .environmentObject(ingredientMgr)
              .environmentObject(adjustmentMgr)
              .environmentObject(mealIngredientMgr)
              .environmentObject(macrosMgr)
              .environmentObject(profileMgr)
        }
    }
}
