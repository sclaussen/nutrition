import SwiftUI

struct MealView: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var baseMgr: BaseMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var profile: Profile

    @State var meal: Meal = Meal()

    var body: some View {
        VStack {

            // NavigationLink("Configure", destination: MealConfigure())

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
          .toolbar {
              ToolbarItem(placement: .primaryAction) {
                  configure
              }
          }
          .onAppear {
              generateMeal()
          }
    }

    var configure: some View {
        NavigationLink("Configure", destination: MealConfigure())
    }

    func generateMeal() {

        // Update the profile
        profileMgr.update(profile)
        print("Height: " + String(profile.height))

        // Copy data from the profile into the meal
        meal = Meal()
        print("Setting macro goals")
        meal.setMacroGoals(caloriesGoalUnadjusted: profile.caloriesGoalUnadjusted, caloriesGoal: profile.caloriesGoal, fatGoal: profile.fatGoal, fiberGoal: profile.fiberGoal, netcarbsGoal: profile.netcarbsGoal, proteinGoal: profile.proteinGoal)

        // Add all the base ingredients to the meal
        print("Adding base meal ingredients")
        addBaseMealIngredients(meal: meal)

        // Add the meat to the meal
        if profile.meat != "None" {
            print("Adding meat ingredient")
            addBaseMealIngredient(name: profile.meat, amount: profile.meatAmount, adjustment: true)
            let ingredient = ingredientMgr.getIngredient(name: profile.meat)!
            for meatAdjustment in ingredient.meatAdjustments {
                print("Adjusting meat adjustments")
                if !adjustMeal(meal: meal, name: meatAdjustment.name, amount: meatAdjustment.amount) {
                    print("Failed for some reason")
                }
            }
        }

        // Now add all the adjustments to up to, but w/out exceeding,
        // the macro goals
        print("Trying adjustments")
        while tryAddingAdjustments(meal: meal) {
        }

        meal.p()
    }

    func addBaseMealIngredients(meal: Meal) {
        for baseIngredient in baseMgr.get(includeInactive: false) {
            if baseIngredient.amount != baseIngredient.defaultAmount {
                addBaseMealIngredient(name: baseIngredient.name, amount: baseIngredient.amount, adjustment: true)
            } else {
                addBaseMealIngredient(name: baseIngredient.name, amount: baseIngredient.amount, adjustment: false)
            }
        }
    }

    func addBaseMealIngredient(name: String, amount: Double, adjustment: Bool) {
        if amount <= 0 {
            return
        }
        let ingredient = ingredientMgr.getIngredient(name: name)!
        let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize
        let calories: Double = ingredient.calories * servings
        let fat: Double = ingredient.fat * servings
        let fiber: Double = ingredient.fiber * servings
        let netcarbs: Double = ingredient.netcarbs * servings
        let protein: Double = ingredient.protein * servings
        meal.addOrUpdateMealIngredient(name: name, amount: amount, consumptionUnit: ingredient.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment)
    }

    func tryAddingAdjustments(meal: Meal) -> Bool {
        for adjustment in adjustmentMgr.get(includeInactive: false) {
            if tryAddingAdjustment(meal: meal, adjustment: adjustment) {
                return true
            }
        }
        return false
    }

    func tryAddingAdjustment(meal: Meal, adjustment: Adjustment) -> Bool {
        let mealIngredient = meal.getMealIngredient(name: adjustment.name)
        if adjustment.constraints && mealIngredient != nil {
            let amountAfterAdjustment = mealIngredient!.amount + adjustment.amount
            if amountAfterAdjustment < adjustment.minimum || amountAfterAdjustment > adjustment.maximum {
                return false
            }
        }

        return adjustMeal(meal: meal, name: adjustment.name, amount: adjustment.amount)
    }

    func adjustMeal(meal: Meal, name: String, amount: Double) -> Bool {
        let ingredient = ingredientMgr.getIngredient(name: name)!
        let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize
        let calories: Double = ingredient.calories * servings
        let fat: Double = ingredient.fat * servings
        let fiber: Double = ingredient.fiber * servings
        let netcarbs: Double = ingredient.netcarbs * servings
        let protein: Double = ingredient.protein * servings

        if meal.fatGoal < meal.fat + fat ||
             meal.netcarbsGoal < meal.netcarbs + netcarbs ||
             meal.proteinGoal < meal.protein + protein {
            return false
        }

        meal.addOrUpdateMealIngredient(name: name, amount: amount, consumptionUnit: ingredient.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: true)
        return true
    }
}

// struct MealView_Previews: PreviewProvider {
//     static var previews: some View {
//         MealView()
//     }
// }
