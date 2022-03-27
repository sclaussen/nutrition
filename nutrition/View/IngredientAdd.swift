import SwiftUI

struct IngredientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr

    @State var name: String = ""

    @State var servingSize: Float = 0
    @State var calories: Float = 0
    @State var fat: Float = 0
    @State var fiber: Float = 0
    @State var netCarbs: Float = 0
    @State var protein: Float = 0

    @State var consumptionUnit: Unit = Unit.gram
    @State var consumptionGrams: Float = 1.0

    @State var meat: Bool = false
    @State var meatAmount: Float = 200
    @State var adjustmentCount = 0
    @State var meatAdjustments: [MeatAdjustment] = []

    @State var ingredientAdd: Bool = false
    @State var adjustmentAdd: Bool = false

    var body: some View {
        Form {
            Section {
                NameValue("Name", $name, .none, edit: true)
                  .autocapitalization(UITextAutocapitalizationType.words)
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
                NVPickerUnitEdit("Consumption Unit", $consumptionUnit, options: Unit.ingredientOptions())
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
                    Section(header: Text("Base Meal Adjustment " + String(index + 1))) {
                        NVPickerEdit("Ingredient", $meatAdjustments[index].name, options: ingredientMgr.getPickerOptions(existing: []))
                        if meatAdjustments[index].name.count > 0 {
                            NameValue("Amount", $meatAdjustments[index].amount, ingredientMgr.getIngredient(name: meatAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
                        }
                    }
                }
                Button {
                    adjustmentCount += 1
                    let meadAdustment: MeatAdjustment = MeatAdjustment(name: "", amount: 0.0, consumptionUnit: .none)
                    meatAdjustments.append(meadAdustment)
                } label: {
                    Label("New Meal Ingredient Adjustment", systemImage: "plus.circle")
                }
            }
            Section(header: Text("Quick Add")) {
                NameValue("Add to Meal Ingredients", $ingredientAdd, control: .toggle)
                NameValue("Add to Adjustments", $adjustmentAdd, control: .toggle)
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
                                   ingredientMgr.create(name: name, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netCarbs: netCarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAmount: meatAmount, meatAdjustments: meatAdjustments, available: true, verified: "")
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
