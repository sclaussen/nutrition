import SwiftUI

struct IngredientEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var ingredient: Ingredient

    var body: some View {
        Form {
            Section {
                StringEdit("Name", $ingredient.name)
            }
            Section {
                DoubleEdit("Serving Size", $ingredient.servingSize, Unit.gram)
                DoubleEdit("Calories", $ingredient.calories, Unit.calorie)
                DoubleEdit("Fat", $ingredient.fat, Unit.gram)
                DoubleEdit("Fiber", $ingredient.fiber, Unit.gram)
                DoubleEdit("Net Carbs", $ingredient.netcarbs, Unit.gram)
                DoubleEdit("Protein", $ingredient.protein, Unit.gram)
            }
            Section(header: Text("Ingredient Consumption")) {
                PickerUnitEdit("Consumption Unit", $ingredient.consumptionUnit, options: Unit.ingredientOptions())
                DoubleEdit("Grams / Unit", $ingredient.consumptionGrams, Unit.gram)
            }
            Section {
                ToggleEdit("Meat", $ingredient.meat)
            }
            if ingredient.meat {
                ForEach(0..<ingredient.meatAdjustments.count, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment " + String(index + 1))) {
                        PickerEdit("Ingredient", $ingredient.meatAdjustments[index].name, options: ingredientMgr.getPickerOptions(existing: []))
                        if ingredient.meatAdjustments[index].name.count > 0 {
                            DoubleEdit("Amount", $ingredient.meatAdjustments[index].amount, ingredientMgr.getIngredient(name: ingredient.meatAdjustments[index].name)!.consumptionUnit, negative: true)
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
                DoubleView("Fat (per 100g)", ingredient.fat100, Unit.gram, precision: 1)
                DoubleView("Fiber (per 100g)", ingredient.fiber100, Unit.gram, precision: 1)
                DoubleView("Net Carbs (per 100g)", ingredient.netcarbs100, Unit.gram, precision: 1)
                DoubleView("Protein (per 100g)", ingredient.protein100, Unit.gram, precision: 1)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  cancel
              }
              ToolbarItem(placement: .primaryAction) {
                  save
              }
          }
    }

    var cancel: some View {
        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
    }

    var save: some View {
        Button("Save",
               action: {
                   withAnimation {
                       ingredientMgr.update(ingredient)
                       presentationMode.wrappedValue.dismiss()
                   }
               })
    }
}

struct IngredientEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientEdit(ingredient: Ingredient(name: "Chicken", servingSize: 200, calories: 180, fat: 2, fiber: 1, netcarbs: 0.5, protein: 10, consumptionUnit: Unit.gram, consumptionGrams: 100))
        }
    }
}
