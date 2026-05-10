import SwiftUI


struct VitaminMineralContributors: View {

    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    let nutrient: VitaminMineralType


    var body: some View {
        let contributions = contributorsTo(
            nutrient: nutrient,
            mealIngredients: mealIngredientMgr.mealIngredients,
            ingredientMgr: ingredientMgr
        )
        let total = contributions.reduce(0) { $0 + $1.contribution }
        let vm = VitaminMineral(name: nutrient,
                                age: profileMgr.profile.age,
                                gender: profileMgr.profile.gender)

        return List {
            Section {
                if contributions.isEmpty {
                    Text("No active meal ingredient contributes to \(nutrient.formattedString()).")
                      .font(.callout)
                      .foregroundColor(Color.theme.blackWhiteSecondary)
                } else {
                    ForEach(contributions) { c in
                        HStack {
                            Text(c.ingredientName)
                              .font(.callout)
                            Spacer()
                            Text("\(c.amount.formattedString(0)) \(c.consumptionUnit.pluralForm)")
                              .font(.caption2)
                              .foregroundColor(Color.theme.blackWhiteSecondary)
                            Spacer()
                            Text("\(c.contribution.formattedString(1))")
                              .font(.caption)
                            Text(total > 0 ? "(\(Int((c.contribution / total) * 100))%)" : "")
                              .font(.caption2)
                              .foregroundColor(Color.theme.blackWhiteSecondary)
                              .frame(width: 50, alignment: .trailing)
                        }
                    }
                }
            } header: {
                Text("Contributors")
            } footer: {
                let minStr = vm.min().formattedString(0)
                let maxStr = vm.max() > 0 ? vm.max().formattedString(0) : "—"
                Text("Total \(total.formattedString(1))   |   Min \(minStr)   |   Max \(maxStr)")
                  .font(.caption2)
            }
        }
          .navigationTitle("\(nutrient.formattedString()) Contributors")
    }
}
