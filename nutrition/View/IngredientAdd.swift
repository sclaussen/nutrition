import SwiftUI

struct IngredientAdd: View {
    //     var body: some View {
    //         Text("Hello")
    //     }
    // }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr

    @State var name: String = ""

    @State var servingSize: Double = 0
    @State var calories: Double = 0
    @State var fat: Double = 0
    @State var fiber: Double = 0
    @State var netcarbs: Double = 0
    @State var protein: Double = 0

    @State var consumptionUnit: Unit = Unit.gram
    @State var consumptionGrams: Double = 0

    @State var meat: Bool = false
    @State var meatAmount: Double = 200
    @State var adjustmentCount = 0
    @State var meatAdjustments: [MeatAdjustment] = []

    var body: some View {
        Form {
            Section {
                StringEdit("Name", $name)
                  .autocapitalization(UITextAutocapitalizationType.words)
            }
            Section {
                DoubleEdit("Serving Size", $servingSize, Unit.gram)
                DoubleEdit("Calories", $calories, Unit.calorie)
                DoubleEdit("Fat", $fat, Unit.gram)
                DoubleEdit("Fiber", $fiber, Unit.gram)
                DoubleEdit("Net Carbs", $netcarbs, Unit.gram)
                DoubleEdit("Protein", $protein, Unit.gram)
            }
            Section(header: Text("Ingredient Consumption")) {
                PickerUnitEdit("Consumption Unit", $consumptionUnit, options: Unit.ingredientOptions())
                DoubleEdit("Grams / Unit", $consumptionGrams, Unit.gram)
            }
            Section {
                ToggleEdit("Meat", $meat)
                if meat {
                    DoubleEdit("Meat Amount", $meatAmount, Unit.gram)
                }
            }
            if meat {
                ForEach(0..<adjustmentCount, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment " + String(index + 1))) {
                        PickerEdit("Ingredient", $meatAdjustments[index].name, options: ingredientMgr.getPickerOptions(existing: []))
                        if meatAdjustments[index].name.count > 0 {
                            DoubleEdit("Amount", $meatAdjustments[index].amount, ingredientMgr.getIngredient(name: meatAdjustments[index].name)!.consumptionUnit, negative: true)
                        }
                    }
                }
                Button {
                    adjustmentCount += 1
                    let meadAdustment: MeatAdjustment = MeatAdjustment(name: "", amount: 0.0, consumptionUnit: Unit.none)
                    meatAdjustments.append(meadAdustment)
                } label: {
                    Label("New Meal Ingredient Adjustment", systemImage: "plus.circle")
                }
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
                                   ingredientMgr.create(name: name, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAmount: meatAmount, meatAdjustments: meatAdjustments, active: true)
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
