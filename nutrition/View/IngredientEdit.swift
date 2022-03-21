import SwiftUI

struct IngredientEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var ingredient: Ingredient

    var body: some View {
        Form {
            Section {
                NVStringEdit("Name", $ingredient.name)
            }
            Section {
                NVDoubleEdit("Serving Size", $ingredient.servingSize, Unit.gram)
                NVDoubleEdit("Calories", $ingredient.calories, Unit.calorie)
                NVDoubleEdit("Fat", $ingredient.fat, Unit.gram)
                NVDoubleEdit("Fiber", $ingredient.fiber, Unit.gram)
                NVDoubleEdit("Net Carbs", $ingredient.netcarbs, Unit.gram)
                NVDoubleEdit("Protein", $ingredient.protein, Unit.gram)
            }
            Section(header: Text("Ingredient Consumption")) {
                NVPickerUnitEdit("Consumption Unit", $ingredient.consumptionUnit, options: Unit.ingredientOptions())
                NVDoubleEdit("Grams / Unit", $ingredient.consumptionGrams, Unit.gram)
            }
            Section {
                NVToggleEdit("Meat", $ingredient.meat)
                if ingredient.meat {
                    NVDoubleEdit("Meat Amount", $ingredient.meatAmount, Unit.gram)
                }
            }
            if ingredient.meat {
                ForEach(0..<ingredient.meatAdjustments.count, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment " + String(index + 1))) {
                        NVPickerEdit("Ingredient", $ingredient.meatAdjustments[index].name, options: ingredientMgr.getPickerOptions(existing: []))
                        if ingredient.meatAdjustments[index].name.count > 0 {
                            NVDoubleEdit("Amount", $ingredient.meatAdjustments[index].amount, ingredientMgr.getIngredient(name: ingredient.meatAdjustments[index].name)!.consumptionUnit, negative: true)
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
                NVDouble("Calories (per 100g)", ingredient.calories100, Unit.gram, precision: 1)
                NVDouble("Fat (per 100g)", ingredient.fat100, Unit.gram, precision: 1)
                NVDouble("Fiber (per 100g)", ingredient.fiber100, Unit.gram, precision: 1)
                NVDouble("Net Carbs (per 100g)", ingredient.netcarbs100, Unit.gram, precision: 1)
                NVDouble("Protein (per 100g)", ingredient.protein100, Unit.gram, precision: 1)
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
            IngredientEdit(ingredient: Ingredient(name: "Chicken", servingSize: 200, calories: 180, fat: 2, fiber: 1, netcarbs: 0.5, protein: 10, consumptionUnit: Unit.gram, consumptionGrams: 100))
        }
    }
}
