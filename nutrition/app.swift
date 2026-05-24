import SwiftUI


@main
struct app: App {

    // The three per-profile managers (MealIngredientMgr,
    // AdjustmentMgr, FoodCompositeMgr) need ProfileMgr's active id at
    // construction time, and need their `reload(forProfileId:)` wired
    // to ProfileMgr.onProfileSwitch. The custom init below assembles
    // them in order, threads the active id, and installs the reload
    // callback so switching the profile swaps all three managers'
    // data in lock-step. Shared managers (Ingredient/Food/Macros/V&M/
    // DayLog) stay singletons because their data isn't per-profile.
    @StateObject var ingredientMgr: IngredientMgr
    @StateObject var adjustmentMgr: AdjustmentMgr
    @StateObject var mealIngredientMgr: MealIngredientMgr
    @StateObject var macrosMgr: MacrosMgr
    @StateObject var profileMgr: ProfileMgr
    @StateObject var vitaminMineralMgr: VitaminMineralMgr
    @StateObject var foodMgr: FoodMgr
    @StateObject var foodCompositeMgr: FoodCompositeMgr
    @StateObject var dayLogMgr: DayLogMgr


    init() {
        let pm = ProfileMgr()
        let activeId = pm.profile.id
        let mim = MealIngredientMgr(profileId: activeId)
        let am  = AdjustmentMgr(profileId: activeId)
        let fcm = FoodCompositeMgr(profileId: activeId)
        // [weak] avoids retaining the managers via the closure they
        // hand to ProfileMgr (each is already retained by the
        // StateObject wrappers below).
        pm.onProfileSwitch = { [weak mim, weak am, weak fcm] newId in
            mim?.reload(forProfileId: newId)
            am?.reload(forProfileId: newId)
            fcm?.reload(forProfileId: newId)
        }
        _profileMgr        = StateObject(wrappedValue: pm)
        _mealIngredientMgr = StateObject(wrappedValue: mim)
        _adjustmentMgr     = StateObject(wrappedValue: am)
        _foodCompositeMgr  = StateObject(wrappedValue: fcm)
        _ingredientMgr     = StateObject(wrappedValue: IngredientMgr())
        _macrosMgr         = StateObject(wrappedValue: MacrosMgr())
        _vitaminMineralMgr = StateObject(wrappedValue: VitaminMineralMgr())
        _foodMgr           = StateObject(wrappedValue: FoodMgr())
        _dayLogMgr         = StateObject(wrappedValue: DayLogMgr())
    }


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
              .environmentObject(dayLogMgr)
        }
    }
}
