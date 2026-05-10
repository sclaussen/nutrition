import SwiftUI


struct VitaminMineralList: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var vitaminMineralMgr: VitaminMineralMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr


    var body: some View {
        let actuals = computeVitaminMineralActuals(
            mealIngredients: mealIngredientMgr.mealIngredients,
            ingredientMgr: ingredientMgr
        )

        return List {
            VitaminMineralRowHeader()
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))

            ForEach(vitaminMineralMgr.getAll(age: profileMgr.profile.age, gender: profileMgr.profile.gender)) { vitaminMineral in
                NavigationLink(destination: VitaminMineralContributors(nutrient: vitaminMineral.name)) {
                    VitaminMineralRow(name: vitaminMineral.name,
                                      min: vitaminMineral.min(),
                                      max: vitaminMineral.max(),
                                      actual: actuals[vitaminMineral.name] ?? 0,
                                      unit: Unit.gram)
                }
            }
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        }
    }
}
