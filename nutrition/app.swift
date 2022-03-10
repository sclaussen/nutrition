import SwiftUI

@main
struct app: App {

    @StateObject var starterMgr: BaseMgr = BaseMgr()
    @StateObject var additionMgr: AdjustmentMgr = AdjustmentMgr()
    @StateObject var ingredientMgr: IngredientMgr = IngredientMgr()
    @StateObject var profileMgr: ProfileMgr = ProfileMgr()

    var body: some Scene {
        WindowGroup {
            Tabs()
              .environmentObject(starterMgr)
              .environmentObject(additionMgr)
              .environmentObject(ingredientMgr)
              .environmentObject(profileMgr)
              .environmentObject(profileMgr.profile!)
        }
    }
}
