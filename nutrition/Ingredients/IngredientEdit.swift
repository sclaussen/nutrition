import SwiftUI

struct IngredientEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var ingredient: Ingredient

    var body: some View {
        Form {
            mainSections
            meatSection
            vitaminAndMineralsSection
            per100GramsSection
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
                  HStack {
                      DismissKeyboard()
                      Spacer()
                      Button("Save", action: save)
                        .foregroundColor(Color.theme.blueYellow)
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

//struct IngredientEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            IngredientEdit(ingredient: Ingredient(name: "Chicken", productName: "Butcher Box", servingSize: 200, calories: 180, fat: 2, fiber: 1, netCarbs: 0.5, protein: 10, consumptionUnit: .gram, consumptionGrams: 100))
//        }
//    }
//}


extension IngredientEdit {
    private var mainSections: some View {
        Group {
            Section {
                NameValue("Name", $ingredient.name)
            }
            Section(header: Text("Optional Product Details")) {
                NameValue("Name", $ingredient.brand, edit: true)
                NameValue("Cost", $ingredient.totalCost, .dollar, precision: 2, edit: true)
                NameValue("Grams", description: "total ingredient grams in the product", $ingredient.totalGrams, edit: true)
            }
            Section(header: Text("Macronutrients")) {
                NameValue("Serving Size", $ingredient.servingSize, edit: true)
                NameValue("Calories", $ingredient.calories, .calorie, edit: true)
                NameValue("Fat", $ingredient.fat, edit: true)
                NameValue("Fiber", $ingredient.fiber, edit: true)
                NameValue("Net Carbs", $ingredient.netCarbs, edit: true)
                NameValue("Protein", $ingredient.protein, edit: true)
            }
            Section(header: Text("Preparation/Consumption Unit")) {
                NameValue("Consumption Unit", description: "preferred meal prep/consumption unit", $ingredient.consumptionUnit, options: Unit.ingredientOptions(), control: .picker)
                NameValue("Grams / Consumption Unit", description: "grams per each prep/consumption unit", $ingredient.consumptionGrams, edit: true)
            }
        }
    }

    private var meatSection: some View {
        Group {
            Section {
                NameValue("Meat", description: "main course", $ingredient.meat, control: .toggle)
            }

//            if ingredient.meat {
//                ForEach(0..<ingredient.mealAdjustments.count, id: \.self) { index in
//                    Section(header: Text("Base Meal Adjustment #" + String(index + 1))) {
//                        NameValue("Ingredient", $ingredient.mealAdjustments[index].name, options: ingredientMgr.getNewMeatNames(existing: []), control: .picker)
//                        if ingredient.mealAdjustments[index].name.count > 0 {
//                            NameValue("Amount", $ingredient.mealAdjustments[index].amount, ingredientMgr.getIngredient(name: ingredient.mealAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
//                        }
//                    }
//                }
//
//                Button {
//                    let mealAdustment: MealAdjustment = MealAdjustment(name: "", amount: 0.0, consumptionUnit: .none)
//                    ingredient.mealAdjustments.append(mealAdustment)
//                } label: {
//                    Label("Add a Base Meal Adjustment (Optional)", systemImage: "plus.circle")
//                }
//            }
        }
    }

    //     Spacer()
    //     Button {
    //         print("Delete Button")
    //     } label: {
    //         Label("Delete")
    //     }
    // }) {

    private var per100GramsSection: some View {
        Section {
            NameValue("Calories (per 100g)", $ingredient.calories100)
            NameValue("Fat (per 100g)", $ingredient.fat100)
            NameValue("Fiber (per 100g)", $ingredient.fiber100)
            NameValue("Net Carbs (per 100g)", $ingredient.netCarbs100, precision: 1)
            NameValue("Protein (per 100g)", $ingredient.protein100)
        }
    }

    private var vitaminAndMineralsSection: some View {
        Section(header: Text("Vitamins and Minerals")) {
            NameValue("Add vitamins and minerals", $ingredient.microNutrients, control: .toggle)
            if ingredient.microNutrients {
                Group {
                    NameValue("Omega-3", $ingredient.omega3, edit: true)
                    NameValue("Vitamin D", $ingredient.vitaminD, edit: true)
                    NameValue("Calcium", $ingredient.calcium, edit: true)
                    NameValue("Iron", $ingredient.iron, edit: true)
                    NameValue("Potassium", $ingredient.potassium, edit: true)
                    NameValue("Vitamin A", $ingredient.vitaminA, edit: true)
                    NameValue("Vitamin C", $ingredient.vitaminC, edit: true)
                    NameValue("Vitamin E", $ingredient.vitaminE, edit: true)
                    NameValue("Vitamin K", $ingredient.vitaminK, edit: true)
                    NameValue("Thiamin", $ingredient.thiamin, edit: true)
                }
                Group {
                    NameValue("Vitamin B6", $ingredient.vitaminB6, edit: true)
                    NameValue("Folate", $ingredient.folate, edit: true)
                    NameValue("Vitamin B12", $ingredient.vitaminB12, edit: true)
                    NameValue("Pantothenic Acid", $ingredient.pantothenicAcid, edit: true)
                    NameValue("Phosphorus", $ingredient.phosphorus, edit: true)
                    NameValue("Magnesium", $ingredient.magnesium, edit: true)
                    NameValue("Zinc", $ingredient.zinc, edit: true)
                    NameValue("Selenium", $ingredient.selenium, edit: true)
                    NameValue("Copper", $ingredient.copper, edit: true)
                    NameValue("Manganese", $ingredient.manganese, edit: true)
                }
                Group {
                    NameValue("Niacin", $ingredient.niacin, edit: true)
                }
            }
        }
    }
}
