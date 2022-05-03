import SwiftUI

struct IngredientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr

    @State var name: String = ""

    @State var url: String = ""
    @State var company: String = ""
    @State var product: String = ""
    @State var cost: Double = 0
    @State var grams: Double = 0

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

    @State var vitaminsAndMinerals: Bool = false
    @State var omega3: Double = 0
    @State var vitaminD: Double = 0
    @State var calcium: Double = 0
    @State var iron: Double = 0
    @State var potassium: Double = 0
    @State var vitaminA: Double = 0
    @State var vitaminC: Double = 0
    @State var vitaminE: Double = 0
    @State var vitaminK: Double = 0
    @State var thiamin: Double = 0
    @State var niacin: Double = 0
    @State var vitaminB6: Double = 0
    @State var folate: Double = 0
    @State var vitaminB12: Double = 0
    @State var pantothenicAcid: Double = 0
    @State var phosphorus: Double = 0
    @State var magnesium: Double = 0
    @State var zinc: Double = 0
    @State var selenium: Double = 0
    @State var copper: Double = 0
    @State var manganese: Double = 0

    var body: some View {
        Form {
            mainSections
            meatSection
            quickAddSection
            vitaminAndMineralsSection
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
            ingredientMgr.create(name: name,
                                 servingSize: servingSize,
                                 calories: calories,
                                 fat: fat,
                                 fiber: fiber,
                                 netCarbs: netCarbs,
                                 protein: protein,
                                 consumptionUnit: consumptionUnit,
                                 consumptionGrams: consumptionGrams,
                                 meat: meat,
                                 meatAmount: 0,
                                 mealAdjustments: mealAdjustments,
                                 available: true,
                                 verified: "")
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

extension IngredientAdd {
    private var mainSections: some View {
        Group {
            Section {
                NameValue("Name", $name, edit: true)
            }
            Section(header: Text("Optional Product Details")) {
                NameValue("URL", $url, edit: true)
                NameValue("Company", $company, edit: true)
                NameValue("Product", $product, edit: true)
                NameValue("Cost", $cost, .dollar, precision: 2, edit: true)
                NameValue("Grams", description: "total ingredient grams in the product", $grams, edit: true)
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
        }
    }

    private var meatSection: some View {
        Group {
            Section {
                NameValue("Meat", description: "main course", $meat, control: .toggle)
            }

            if meat {
                ForEach(0..<adjustmentCount, id: \.self) { index in
                    Section(header: Text("Base Meal Adjustment #" + String(index + 1))) {
                        // TODO: Update this to exclude existing meal adjustments, or, should this be fetching all ingredients (which is what it appears to do...)?
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
        }
    }

    private var quickAddSection: some View {
        Group {
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
    }

    private var vitaminAndMineralsSection: some View {
        Section(header: Text("Vitamins and Minerals")) {
            NameValue("Add vitamins and minerals", $vitaminsAndMinerals, control: .toggle)
            if vitaminsAndMinerals {
                Group {
                    NameValue("Omega-3", $omega3, edit: true)
                    NameValue("Vitamin D", $vitaminD, edit: true)
                    NameValue("Calcium", $calcium, edit: true)
                    NameValue("Iron", $iron, edit: true)
                    NameValue("Potassium", $potassium, edit: true)
                    NameValue("Vitamin A", $vitaminA, edit: true)
                    NameValue("Vitamin C", $vitaminC, edit: true)
                    NameValue("Vitamin E", $vitaminE, edit: true)
                    NameValue("Vitamin K", $vitaminK, edit: true)
                    NameValue("Thiamin", $thiamin, edit: true)
                }
                Group {
                    NameValue("Vitamin B6", $vitaminB6, edit: true)
                    NameValue("Folate", $folate, edit: true)
                    NameValue("Vitamin B12", $vitaminB12, edit: true)
                    NameValue("Pantothenic Acid", $pantothenicAcid, edit: true)
                    NameValue("Phosphorus", $phosphorus, edit: true)
                    NameValue("Magnesium", $magnesium, edit: true)
                    NameValue("Zinc", $zinc, edit: true)
                    NameValue("Selenium", $selenium, edit: true)
                    NameValue("Copper", $copper, edit: true)
                    NameValue("Manganese", $manganese, edit: true)
                }
                Group {
                    NameValue("Niacin", $niacin, edit: true)
                }
            }
        }
    }
}
