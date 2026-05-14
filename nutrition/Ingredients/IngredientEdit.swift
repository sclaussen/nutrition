import SwiftUI

struct IngredientEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var ingredient: Ingredient
    @State private var showAutoAdjust: Bool = false

    var body: some View {
        Form {
            mainSections
            meatSection
            supplementSection
            autoAdjustSection
            vitaminAndMineralsSection
            per100GramsSection
        }
          .sheet(isPresented: $showAutoAdjust) {
              AutoAdjustEditor(ingredient: ingredient)
                .environmentObject(adjustmentMgr)
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
                NameValue("Step amount", description: "0 = auto by unit & serving size", $ingredient.stepAmount, ingredient.consumptionUnit, edit: true)
            }
        }
    }

    private var supplementSection: some View {
        Section {
            NameValue("Supplement", description: "hidden in meal list by default",
                      $ingredient.supplement, control: .toggle)
        }
    }

    // Auto-adjust rule for this ingredient. Tapping opens
    // AutoAdjustEditor (inlined at the bottom of this file). When a
    // rule already exists, the label shows the per-cycle amount; when
    // none exists, the label invites the user to configure one.
    private var autoAdjustSection: some View {
        Section {
            Button {
                showAutoAdjust = true
            } label: {
                if let rule = adjustmentMgr.getByName(name: ingredient.name) {
                    Label("Auto-adjust: +\(Int(rule.amount)) per cycle",
                          systemImage: "gearshape.fill")
                      .foregroundColor(Color.theme.blueYellow)
                } else {
                    Label("Configure auto-adjust\u{2026}",
                          systemImage: "gearshape")
                      .foregroundColor(Color.theme.blueYellow)
                }
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
        // V&M fields are always visible — the previous "Add vitamins
        // and minerals" toggle hid them by default, which made it
        // hard to discover that V&M data could be entered at all.
        // Now they show inline; leave a field blank to record nothing.
        Section(header: Text("Vitamins and Minerals")) {
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
                NameValue("Riboflavin", $ingredient.riboflavin, edit: true)
            }
        }
    }
}


// =============================================================
// AutoAdjustEditor — moved here from IngredientList.swift so it
// stays in the same compile unit as the screen that presents it
// (IngredientEdit now hosts the gear button + sheet).
// =============================================================
//
// Sheet for configuring (or disabling) the auto-adjust rule for one
// ingredient. Maps directly to AdjustmentMgr's `setAuto` / `clearAuto`.
struct AutoAdjustEditor: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    let ingredient: Ingredient

    @State private var amountText: String = ""
    @State private var maxText: String = ""
    @State private var hasRule: Bool = false


    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Add per cycle")
                          .font(.callout)
                        Spacer()
                        TextField("amount", text: $amountText)
                          .keyboardType(.decimalPad)
                          .multilineTextAlignment(.trailing)
                          .frame(maxWidth: 100)
                        Text(unitLabel)
                          .font(.caption)
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    }
                    HStack {
                        Text("Max (optional)")
                          .font(.callout)
                        Spacer()
                        TextField("none", text: $maxText)
                          .keyboardType(.decimalPad)
                          .multilineTextAlignment(.trailing)
                          .frame(maxWidth: 100)
                        Text(unitLabel)
                          .font(.caption)
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    }
                } footer: {
                    Text("Generate-meal will add this amount per pass to \(ingredient.name) until the max (if set) is hit, macro goals are reached, or the ingredient is locked to Manual/Done.")
                      .font(.caption2)
                }

                if hasRule {
                    Section {
                        Button(role: .destructive) {
                            adjustmentMgr.clearAuto(name: ingredient.name)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("Disable auto-adjust", systemImage: "trash")
                        }
                    }
                }
            }
              .navigationTitle("Auto-adjust: \(ingredient.name)")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .navigation) {
                      Button("Cancel") {
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
                  ToolbarItem(placement: .primaryAction) {
                      Button("Save") {
                          save()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                        .disabled(Double(amountText) == nil)
                  }
              }
              .onAppear {
                  if let rule = adjustmentMgr.getByName(name: ingredient.name) {
                      hasRule = true
                      amountText = formatNumber(rule.amount)
                      maxText = rule.constraints ? formatNumber(rule.maximum) : ""
                  }
              }
        }
    }


    private func save() {
        guard let amount = Double(amountText) else { return }
        // Empty maxText = no cap.
        let maximum: Double? = {
            let trimmed = maxText.trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty ? nil : Double(trimmed)
        }()
        adjustmentMgr.setAuto(name: ingredient.name, amount: amount, maximum: maximum)
        presentationMode.wrappedValue.dismiss()
    }


    // "grams" / "tablespoons" / "pieces" — matches the units the
    // meal-list stepper shows so the user sees the same vocabulary.
    private var unitLabel: String {
        ingredient.consumptionUnit.pluralForm
    }


    private func formatNumber(_ value: Double) -> String {
        if value == value.rounded() {
            return String(Int(value))
        }
        return String(value)
    }
}
