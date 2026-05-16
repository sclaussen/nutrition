import SwiftUI


// Meal-cost breakdown. Pushed from the $ icon in the MealList
// compact toolbar. Lists every meal ingredient by how much it
// contributes to the meal's cost, most expensive first, so the
// user can see what's actually driving the grocery bill.
//
// Cost contribution per row:
//   costPerGram   = ingredient.totalCost / ingredient.totalGrams
//   gramsConsumed = mealIngredient.amount × ingredient.consumptionGrams
//   contribution  = costPerGram × gramsConsumed
//
// Ingredients without pricing (totalGrams == 0) contribute 0 and
// sort to the bottom — they're shown so the user knows they're
// unpriced rather than silently dropped. All rows render in the
// primary text color (no active/inactive distinction here).
struct IngredientCostDetail: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr


    var body: some View {
        let rows = sortedRows()
        let total = rows.reduce(0) { $0 + $1.cost }

        List {
            Section(footer:
                HStack {
                    Text("Meal total").font(.callout)
                    Spacer()
                    Text(dollars(total))
                      .font(.callout)
                      .foregroundColor(Color.theme.blueYellow)
                }
                  .padding(.top, 4)
            ) {
                ForEach(rows, id: \.mealIngredient.id) { row in
                    HStack {
                        Text(row.mealIngredient.name)
                          .font(.callout)
                        Spacer()
                        Text(dollars(row.cost))
                          .font(.caption)
                    }
                      .foregroundColor(Color.theme.blackWhite)
                }
            }
        }
          .listStyle(.plain)
          .navigationTitle("Meal Cost")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
              ToolbarItem(placement: .primaryAction) {
                  Button("Done") {
                      presentationMode.wrappedValue.dismiss()
                  }
                    .foregroundColor(Color.theme.blueYellow)
              }
          }
    }


    private func sortedRows() -> [(mealIngredient: MealIngredient, cost: Double)] {
        let pairs: [(mealIngredient: MealIngredient, cost: Double)] =
            mealIngredientMgr.mealIngredients.compactMap { mi in
                if mi.isComposite {
                    return (mi, compositeCost(mi, ingredientMgr))
                }
                guard let ing = ingredientMgr.getByName(name: mi.name) else { return nil }
                return (mi, costContribution(mi, ing))
            }
        return pairs.sorted { $0.cost > $1.cost }
    }


    private func costContribution(_ mi: MealIngredient, _ ing: Ingredient) -> Double {
        guard ing.totalGrams > 0 else { return 0 }
        let costPerGram = ing.totalCost / ing.totalGrams
        let gramsConsumed = mi.amount * ing.consumptionGrams
        return costPerGram * gramsConsumed
    }


    private func dollars(_ v: Double) -> String {
        String(format: "$%.2f", v)
    }
}
