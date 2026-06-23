import SwiftUI

struct MealAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var foodMgr: FoodMgr

    @State var name: String = ""
    @State var defaultAmount: Double = 0

    var body: some View {
        Form {
            Section {
                // Return a list of sorted ingredients that are not:
                // 1. already part of the meal ingredients list
                // 2. that are not categorized as meats
                NameValue("Meal Ingredient", $name, options: ingredientMgr.getNewMealIngredientNames(existingMealIngredientNames: mealIngredientMgr.getNames()), control: .picker)

                // If an ingredient has been selected, the name string
                // will have > 0 characters, in which case present the
                // "Amount" name/value widget.
                if name.count > 0 {
                    NameValue("Amount", $defaultAmount, foodMgr.consumptionUnit(for: name, ingredientMgr: ingredientMgr), edit: true)
                }
            }
        }
          .padding([.leading, .trailing], -20)
          .cancelSaveToolbar(onCancel: cancel, onSave: save)
    }

    func cancel() {
        withAnimation {
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    func save() {
        withAnimation {
            mealIngredientMgr.create(name: name, amount: defaultAmount)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct MealIngredientCreate_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealAdd()
              .environmentObject(MealIngredientMgr(profileId: "preview", profileName: "preview"))
        }
    }
}
