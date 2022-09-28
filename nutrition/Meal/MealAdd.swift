import SwiftUI

struct MealAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr

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
                    NameValue("Amount", $defaultAmount, getConsumptionUnit(name), edit: true)
                }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: cancel)
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .primaryAction) {
                  Button("Save", action: save)
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItemGroup(placement: .keyboard) {
                  DismissKeyboard()
                  Spacer()
                  Button("Save", action: save)
                    .foregroundColor(Color.theme.blueYellow)
              }
          }
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

    func getConsumptionUnit(_ name: String) -> Unit {
        return ingredientMgr.getByName(name: name)!.consumptionUnit
    }
}

struct MealIngredientCreate_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealAdd()
              .environmentObject(MealIngredientMgr())
        }
    }
}
