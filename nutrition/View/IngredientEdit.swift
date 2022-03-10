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
                DoubleEdit("Serving Size", $ingredient.servingSize, "grams")
                DoubleEdit("Calories", $ingredient.calories, "kcals")
                DoubleEdit("Fat", $ingredient.fat, "grams")
                DoubleEdit("Fiber", $ingredient.fiber, "grams")
                DoubleEdit("Net Carbs", $ingredient.netcarbs, "grams")
                DoubleEdit("Protein", $ingredient.protein, "grams")
            }
            Section(header: Text("Consumption")) {
                PickerEdit("Unit", $ingredient.consumptionUnit, options: Unit.values())
                DoubleEdit("Grams per", $ingredient.consumptionGrams)
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
                    let meadAdustment: MeatAdjustment = MeatAdjustment(name: "", amount: 0.0, consumptionUnit: "")
                    ingredient.meatAdjustments.append(meadAdustment)
                } label: {
                    Label("Add a Base Meal Adjustment (Optional)", systemImage: "plus.circle")
                }
            }
            Section {
                DoubleView("Fat (per 100g)", ingredient.fat100, "grams", precision: 1)
                DoubleView("Fiber (per 100g)", ingredient.fiber100, "grams", precision: 1)
                DoubleView("Net Carbs (per 100g)", ingredient.netcarbs100, "grams", precision: 1)
                DoubleView("Protein (per 100g)", ingredient.protein100, "grams", precision: 1)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .navigationBarItems(leading: cancel)
          .navigationBarItems(trailing: save)
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
            IngredientEdit(ingredient: Ingredient(name: "Chicken", servingSize: 200, calories: 180, fat: 2, fiber: 1, netcarbs: 0.5, protein: 10, consumptionUnit: Unit.Gram.rawValue, consumptionGrams: 100))
        }
    }
}
