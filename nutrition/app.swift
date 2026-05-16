import SwiftUI


@main
struct app: App {

    @StateObject var ingredientMgr: IngredientMgr = IngredientMgr()
    @StateObject var adjustmentMgr: AdjustmentMgr = AdjustmentMgr()
    @StateObject var mealIngredientMgr: MealIngredientMgr = MealIngredientMgr()
    @StateObject var macrosMgr: MacrosMgr = MacrosMgr()
    @StateObject var profileMgr: ProfileMgr = ProfileMgr()
    @StateObject var vitaminMineralMgr: VitaminMineralMgr = VitaminMineralMgr()
    @StateObject var foodMgr: FoodMgr = FoodMgr()
    @StateObject var foodCompositeMgr: FoodCompositeMgr = FoodCompositeMgr()


    var body: some Scene {
        return WindowGroup {
            Tabs()
              .environmentObject(ingredientMgr)
              .environmentObject(adjustmentMgr)
              .environmentObject(mealIngredientMgr)
              .environmentObject(macrosMgr)
              .environmentObject(profileMgr)
              .environmentObject(vitaminMineralMgr)
              .environmentObject(foodMgr)
              .environmentObject(foodCompositeMgr)
              .onAppear {
                  foodMgr.ensureSeededFoods(from: ingredientMgr.getAll())
              }
        }
    }
}
