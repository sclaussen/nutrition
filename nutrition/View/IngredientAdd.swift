import SwiftUI

struct IngredientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr

    @State var name: String = ""

    @State var productBrand: String = ""
    @State var productCost: Double = 0
    @State var productGrams: Double = 0

    @State var servingSize: Double = 0
    @State var calories: Double = 0
    @State var fat: Double = 0
    @State var fiber: Double = 0
    @State var netCarbs: Double = 0
    @State var protein: Double = 0

    @State var consumptionUnit: Unit = .gram
    @State var consumptionGrams: Double = 1.0

    @State var meat: Bool = false
    @State var adjustmentCount = 0
    @State var mealAdjustments: [MealAdjustment] = []

    @State var ingredientAdd: Bool = false
    @State var ingredientAmount: Double = 0

    @State var adjustmentAdd: Bool = false
    @State var adjustmentAmount: Double = 0

    var body: some View {
        Form {
            Section {
                NameValue("Name", $name, edit: true)
            }
            Section(header: Text("Optional Product Details")) {
                NameValue("Name", $productBrand, edit: true)
                NameValue("Cost", $productCost, .dollar, precision: 2, edit: true)
                NameValue("Grams", description: "total ingredient grams in the product", $productGrams, edit: true)
            }
            Section(header: Text("Macronutrients")) {
                NameValue("Serving Size", $servingSize, edit: true)
                NameValue("Calories", $calories, .calorie, edit: true)
                NameValue("Fat", $fat, edit: true)
                NameValue("Fiber", $fiber, edit: true)
                NameValue("Net Carbs", $netCarbs, edit: true)
                NameValue("Protein", $protein, edit: true)
            }
            Section(header: Text("Preparation/Consumption Unit")) {
                NameValue("Consumption Unit", description: "preferred meal prep/consumption unit", $consumptionUnit, options: Unit.ingredientOptions(), control: .picker)
                NameValue("Grams / Unit", description: "grams per each prep/consumption unit", $consumptionGrams, edit: true)
            }
            Section {
                NameValue("Meat", description: "main course", $meat, control: .toggle)
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
                    NameValue("Ingredient Amount", $ingredientAmount, edit: true)
                }
            }

            Section(header: Text("Meal Adjustments Quick Add")) {
                NameValue("Add to Adjustments", $adjustmentAdd, control: .toggle)
                if adjustmentAdd {
                    NameValue("Adjustment Amount", $adjustmentAmount, edit: true)
                }
            }
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
            ingredientMgr.create(name: name, productBrand: productBrand, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netCarbs: netCarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAmount: 0, mealAdjustments: mealAdjustments, available: true, verified: "")
            if ingredientAdd {
                mealIngredientMgr.create(name: name,
                                         defaultAmount: ingredientAmount,
                                         amount: ingredientAmount,
                                         active: false)
            }
            if adjustmentAdd {
                adjustmentMgr.create(name: name,

                                     amount: adjustmentAmount,
                                     active: false)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct IngredientAdd2_Previews: PreviewProvider {

    static var previews: some View {
        IngredientAdd()
    }
}
