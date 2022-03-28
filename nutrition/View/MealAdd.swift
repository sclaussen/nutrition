import SwiftUI

struct MealAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var name: String = ""
    @State var defaultAmount: Float = 0

    var body: some View {
        Form {
            Section {
                NameValue("Meal Ingredient", $name, options: ingredientMgr.getNewMeatNames(existing: mealIngredientMgr.getNames()), control: .picker)
                if name.count > 0 {
                    NameValue("Amount", $defaultAmount, ingredientMgr.getIngredient(name: name)!.consumptionUnit, edit: true)
                }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  cancel
              }
              ToolbarItem(placement: .primaryAction) {
                  HStack {
                      Button {
                          self.hideKeyboard()
                      } label: {
                          Label("Keyboard Down", systemImage: "keyboard.chevron.compact.down")
                      }
                      Button("Save",
                             action: {
                                 withAnimation {
                                     mealIngredientMgr.create(name: name, defaultAmount: defaultAmount, amount: defaultAmount, consumptionUnit: ingredientMgr.getIngredient(name: name)!.consumptionUnit)
                                     presentationMode.wrappedValue.dismiss()
                                 }
                             })
                  }
              }
          }
    }

    var cancel: some View {
        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
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
