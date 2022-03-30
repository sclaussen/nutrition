import SwiftUI

struct IngredientEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var ingredient: Ingredient

    var body: some View {
        Form {
            Section {
                NameValue("Name", $ingredient.name)
            }
            Section(header: Text("Optional Details")) {
                NameValue("Brand", $ingredient.brand, edit: true)
                NameValue("Cost", $ingredient.cost, edit: true)
                NameValue("Cost/Gram", $ingredient.costPerGram, edit: true)
            }
            Section(header: Text("Macronutrient Details")) {
                NameValue("Serving Size", $ingredient.servingSize, edit: true)
                NameValue("Calories", $ingredient.calories, .calorie, edit: true)
                NameValue("Fat", $ingredient.fat, edit: true)
                NameValue("Fiber", $ingredient.fiber, edit: true)
                NameValue("Net Carbs", $ingredient.netCarbs, edit: true)
                NameValue("Protein", $ingredient.protein, edit: true)
            }
            Section(header: Text("Ingredient Consumption")) {
                NameValue("Consumption Unit", $ingredient.consumptionUnit, options: Unit.ingredientOptions(), control: .picker)
                NameValue("Grams / Unit", $ingredient.consumptionGrams, edit: true)
            }
            Section {
                NameValue("Meat", $ingredient.meat, control: .toggle)
                if ingredient.meat {
                    NameValue("Meat Amount", $ingredient.meatAmount, edit: true)
                }
            }

            if ingredient.meat {
                ForEach(0..<ingredient.mealAdjustments.count, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment #" + String(index + 1))) {
                        NameValue("Ingredient", $ingredient.mealAdjustments[index].name, options: ingredientMgr.getNewMeatNames(existing: []), control: .picker)
                        if ingredient.mealAdjustments[index].name.count > 0 {
                            NameValue("Amount", $ingredient.mealAdjustments[index].amount, ingredientMgr.getIngredient(name: ingredient.mealAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
                        }
                    }
                }
                Button {
                    let mealAdustment: MealAdjustment = MealAdjustment(name: "", amount: 0.0, consumptionUnit: .none)
                    ingredient.mealAdjustments.append(mealAdustment)
                } label: {
                    Label("Add a Base Meal Adjustment (Optional)", systemImage: "plus.circle")
                }
            }

            // Section {
            //     NameValue("Calories (per 100g)", $ingredient.calories100)
            //     NameValue("Fat (per 100g)", $ingredient.fat100)
            //     NameValue("Fiber (per 100g)", $ingredient.fiber100)
            //     NameValue("Net Carbs (per 100g)", $ingredient.netCarbs100, precision: 1)
            //     NameValue("Protein (per 100g)", $ingredient.protein100)
            // }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: cancel)
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItem(placement: .primaryAction) {
                  Button("Save", action: save)
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItemGroup(placement: .keyboard) {
                  HStack {
                      DismissKeyboard()
                      Spacer()
                      Button("Save", action: save)
                        .foregroundColor(Color("Blue"))
                  }
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
            ingredientMgr.update(ingredient)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct IngredientEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientEdit(ingredient: Ingredient(name: "Chicken", brand: "Butcher Box", servingSize: 200, calories: 180, fat: 2, fiber: 1, netCarbs: 0.5, protein: 10, consumptionUnit: .gram, consumptionGrams: 100))
        }
    }
}
