import SwiftUI

struct MealView: View {

    @Binding var meal: Meal

    var body: some View {
        VStack {

            MyGaugeDashboard(
              caloriesGoalUnadjusted: meal.caloriesGoalUnadjusted,
              caloriesGoal: meal.caloriesGoal,
              fatGoal: meal.fatGoal,
              fiberGoal: meal.fiberGoal,
              netcarbsGoal: meal.netcarbsGoal,
              proteinGoal: meal.proteinGoal,
              calories: meal.calories,
              fat: meal.fat,
              fiber: meal.fiber,
              netcarbs: meal.netcarbs,
              protein: meal.protein
            )

            List {
                ForEach(meal.mealIngredients) { mealIngredient in
                    HStack {
                        Image(mealIngredient.name)
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(maxWidth: 50)
                        DoubleView(mealIngredient.name, mealIngredient.amount, mealIngredient.consumptionUnit)
                          .foregroundColor(mealIngredient.adjustment ? .blue : .black)
                    }.frame(height: 20)
                }
            }
        }
          .padding([.leading, .trailing], -20)
    }
}

// struct MealView_Previews: PreviewProvider {
//     static var previews: some View {
//         MealView()
//     }
// }
