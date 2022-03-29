import SwiftUI

struct IngredientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr

    @State var name: String = ""
    @State var brand: String = ""

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
    @State var adjustmentAdd: Bool = false

    var body: some View {
        Form {
            Section {
                NameValue("Name", $name, edit: true)
                  .autocapitalization(UITextAutocapitalizationType.words)
                NameValue("Brand", $brand, edit: true)
            }
            Section {
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

            if meat {
                ForEach(0..<adjustmentCount, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment #" + String(index + 1))) {
                        // TODO: Update this to exclude existing meat adjustments, or, should this be fetching all ingredients (which is what it appears to do...)?
                        NameValue("Ingredient", $mealAdjustments[index].name, options: ingredientMgr.getNewMeatNames(existing: []), control: .picker)
                        if mealAdjustments[index].name.count > 0 {
                            NameValue("Amount", $mealAdjustments[index].amount, ingredientMgr.getIngredient(name: mealAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
                        }
                    }
                }
                Button {
                    adjustmentCount += 1
                    let meadAdustment: MealAdjustment = MealAdjustment(name: "", amount: 0.0, consumptionUnit: .none)
                    mealAdjustments.append(meadAdustment)
                } label: {
                    Label("New Meal Ingredient Adjustment", systemImage: "plus.circle")
                }
            }

            Section(header: Text("Quick Add")) {
                NameValue("Add to Adjustments", $adjustmentAdd, control: .toggle)
                NameValue("Add to Meal Ingredients", $ingredientAdd, control: .toggle)
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
                                     ingredientMgr.create(name: name, brand: brand, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netCarbs: netCarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAmount: meatAmount, mealAdjustments: mealAdjustments, available: true, verified: "")
                                     if adjustmentAdd {
                                         adjustmentMgr.create(name: name,
                                                              amount: 1,
                                                              consumptionUnit: consumptionUnit,
                                                              active: false)
                                     }
                                     if ingredientAdd {
                                         mealIngredientMgr.create(name: name,
                                                                  defaultAmount: 1,
                                                                  amount: 1,
                                                                  consumptionUnit: consumptionUnit,
                                                                  active: false)
                                     }
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

struct IngredientAdd2_Previews: PreviewProvider {

    static var previews: some View {
        IngredientAdd()
    }
}
