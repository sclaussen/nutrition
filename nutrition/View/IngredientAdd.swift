import SwiftUI

struct IngredientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr

    @State var name: String = ""

    @State var brand: String = ""
    @State var cost: Float = 0
    @State var costPerGram: Float = 0

    @State var servingSize: Float = 0
    @State var calories: Float = 0
    @State var fat: Float = 0
    @State var fiber: Float = 0
    @State var netCarbs: Float = 0
    @State var protein: Float = 0

    @State var consumptionUnit: Unit = .gram
    @State var consumptionGrams: Float = 1.0

    @State var meat: Bool = false
    @State var meatAmount: Float = 200
    @State var adjustmentCount = 0
    @State var mealAdjustments: [MealAdjustment] = []

    @State var ingredientAdd: Bool = false
    @State var ingredientAmount: Float = 0

    @State var adjustmentAdd: Bool = false
    @State var adjustmentAmount: Float = 0

    var body: some View {
        Form {
            Section {
                NameValue("Name", $name, edit: true)
            }
            Section(header: Text("Optional Details")) {
                NameValue("Brand", $brand, edit: true)
                NameValue("Cost", $cost, edit: true)
                NameValue("Cost/Gram", $costPerGram, edit: true)
            }
            Section(header: Text("Macronutrient Details")) {
                NameValue("Serving Size", $servingSize, edit: true)
                NameValue("Calories", $calories, .calorie, edit: true)
                NameValue("Fat", $fat, edit: true)
                NameValue("Fiber", $fiber, edit: true)
                NameValue("Net Carbs", $netCarbs, edit: true)
                NameValue("Protein", $protein, edit: true)
            }
            Section(header: Text("Ingredient Consumption")) {
                NameValue("Consumption Unit", $consumptionUnit, options: Unit.ingredientOptions(), control: .picker)
                NameValue("Grams / Unit", $consumptionGrams, edit: true)
            }
            Section {
                NameValue("Meat", description: "main course", $meat, control: .toggle)
                if meat {
                    NameValue("Meat Amount", $meatAmount, edit: true)
                }
            }

//            if meat {
//                ForEach(0..<adjustmentCount, id: \.self) { index in
//                    Section(header: Text("Base Meal Adjustment #" + String(index + 1))) {
//                        // TODO: Update this to exclude existing meal adjustments, or, should this be fetching all ingredients (which is what it appears to do...)?
//                        NameValue("Ingredient", $mealAdjustments[index].name, options: ingredientMgr.getNewMeatNames(existing: []), control: .picker)
//                        if mealAdjustments[index].name.count > 0 {
//                            NameValue("Amount", $mealAdjustments[index].amount, ingredientMgr.getIngredient(name: mealAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
//                        }
//                    }
//                }
//                Button {
//                    adjustmentCount += 1
//                    let meadAdustment: MealAdjustment = MealAdjustment(name: "", amount: 0.0, consumptionUnit: .none)
//                    mealAdjustments.append(meadAdustment)
//                } label: {
//                    Label("New Meal Ingredient Adjustment", systemImage: "plus.circle")
//                }
//            }

            Section(header: Text("Meal Ingredients Quick Add")) {
                NameValue("Add to Meal Ingredients", $ingredientAdd, control: .toggle)
                if ingredientAdd {
                    NameValue("Ingredient Amount", $ingredientAmount)
                }
            }

            Section(header: Text("Meal Adjustments Quick Add")) {
                NameValue("Add to Adjustments", $adjustmentAdd, control: .toggle)
                if adjustmentAdd {
                    NameValue("Adjustment Amount", $adjustmentAmount)
                }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
              }
              ToolbarItem(placement: .primaryAction) {
                  Button("Save",
                         action: {
                             withAnimation {
                                 ingredientMgr.create(name: name, brand: brand, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netCarbs: netCarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAmount: meatAmount, mealAdjustments: mealAdjustments, available: true, verified: "")
                                 if ingredientAdd {
                                     mealIngredientMgr.create(name: name,
                                                              defaultAmount: ingredientAmount,
                                                              amount: ingredientAmount,
                                                              consumptionUnit: consumptionUnit,
                                                              active: false)
                                 }
                                 if adjustmentAdd {
                                     adjustmentMgr.create(name: name,
                                                          amount: adjustmentAmount,
                                                          consumptionUnit: consumptionUnit,
                                                          active: false)
                                 }
                                 presentationMode.wrappedValue.dismiss()
                             }
                         })
              }
              ToolbarItemGroup(placement: .keyboard) {
                  DismissKeyboard()
              }
          }
    }
}

struct IngredientAdd2_Previews: PreviewProvider {

    static var previews: some View {
        IngredientAdd()
    }
}
