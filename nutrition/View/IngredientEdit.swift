import SwiftUI

struct IngredientEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var ingredient: Ingredient

    var body: some View {
        Form {
            Section {
                NameValue("Name", $ingredient.name, .none)
            }
            Section {
                NameValue("Serving Size", $ingredient.servingSize, edit: true)
                NameValue("Calories", $ingredient.calories, Unit.calorie, edit: true)
                NameValue("Fat", $ingredient.fat, edit: true)
                NameValue("Fiber", $ingredient.fiber, edit: true)
                NameValue("Net Carbs", $ingredient.netCarbs, edit: true)
                NameValue("Protein", $ingredient.protein, edit: true)
            }
            Section(header: Text("Ingredient Consumption")) {
                NVPickerUnitEdit("Consumption Unit", $ingredient.consumptionUnit, options: Unit.ingredientOptions())
                NameValue("Grams / Unit", $ingredient.consumptionGrams, edit: true)
            }
            Section {
                NameValue("Meat", $ingredient.meat, control: .toggle)
                if ingredient.meat {
                    NameValue("Meat Amount", $ingredient.meatAmount, edit: true)
                }
            }
            if ingredient.meat {
                ForEach(0..<ingredient.meatAdjustments.count, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment " + String(index + 1))) {
                        NVPickerEdit("Ingredient", $ingredient.meatAdjustments[index].name, options: ingredientMgr.getPickerOptions(existing: []))
                        if ingredient.meatAdjustments[index].name.count > 0 {
                            NameValue("Amount", $ingredient.meatAdjustments[index].amount, ingredientMgr.getIngredient(name: ingredient.meatAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
                        }
                    }
                }
                Button {
                    let meadAdustment: MeatAdjustment = MeatAdjustment(name: "", amount: 0.0, consumptionUnit: Unit.none)
                    ingredient.meatAdjustments.append(meadAdustment)
                } label: {
                    Label("Add a Base Meal Adjustment (Optional)", systemImage: "plus.circle")
                }
            }
            Section {
                NameValue("Calories (per 100g)", $ingredient.calories100)
                NameValue("Fat (per 100g)", $ingredient.fat100)
                NameValue("Fiber (per 100g)", $ingredient.fiber100)
                NameValue("Net Carbs (per 100g)", $ingredient.netCarbs100, precision: 1)
                NameValue("Protein (per 100g)", $ingredient.protein100)
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
                                     ingredientMgr.update(ingredient)
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

struct IngredientEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientEdit(ingredient: Ingredient(name: "Chicken", servingSize: 200, calories: 180, fat: 2, fiber: 1, netCarbs: 0.5, protein: 10, consumptionUnit: Unit.gram, consumptionGrams: 100))
        }
    }
}
