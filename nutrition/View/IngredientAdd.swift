import SwiftUI

struct IngredientAdd: View {

    enum Field: Hashable {
        case name
        case servingSize
        case calories
        case fat
        case fiber
        case netcarbs
        case protein
        case consumptionUnit
        case consumptionGrams
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var baseMgr: BaseMgr
    @FocusState private var focusedField: Field?

    @State var name: String = ""

    @State var servingSize: Double = 0
    @State var calories: Double = 0
    @State var fat: Double = 0
    @State var fiber: Double = 0
    @State var netcarbs: Double = 0
    @State var protein: Double = 0

    @State var consumptionUnit: String = Unit.Gram.rawValue
    @State var consumptionGrams: Double = 0

    @State var meat: Bool = false
    @State var adjustmentCount = 0
    @State var meatAdjustments: [MeatAdjustment] = []

    var body: some View {
        Form {
            Section {
                StringEdit("Name", $name)
                  .focused($focusedField, equals: .name)
                  .autocapitalization(UITextAutocapitalizationType.words)
            }
            Section {
                DoubleEdit("Serving Size", $servingSize, "grams")
                  .focused($focusedField, equals: .calories)
                DoubleEdit("Calories", $calories, "kcals")
                  .focused($focusedField, equals: .calories)
                DoubleEdit("Fat", $fat, "grams")
                  .focused($focusedField, equals: .fat)
                DoubleEdit("Fiber", $fiber, "grams")
                  .focused($focusedField, equals: .fiber)
                DoubleEdit("Net Carbs", $netcarbs, "grams")
                  .focused($focusedField, equals: .netcarbs)
                DoubleEdit("Protein", $protein, "grams")
                  .focused($focusedField, equals: .protein)
            }
            Section(header: Text("Consumption")) {
                PickerEdit("Unit", $consumptionUnit, options: Unit.values())
                  .focused($focusedField, equals: .consumptionUnit)
                DoubleEdit("Grams per", $consumptionGrams)
                  .focused($focusedField, equals: .consumptionGrams)
            }
            Section {
                ToggleEdit("Meat", $meat)
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
                           let meadAdustment: MeatAdjustment = MeatAdjustment(name: "", amount: 0.0, consumptionUnit: "")
                           meatAdjustments.append(meadAdustment)
                       } label: {
                           Label("Add a Base Meal Adjustment (Optional)", systemImage: "plus.circle")
                       }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .navigationBarItems(leading: cancel)
          .navigationBarItems(trailing: save)
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  self.focusedField = Field.servingSize
              }
          }
    }

    var cancel: some View {
        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
    }

    var save: some View {
        Button("Save",
               action: {
                   withAnimation {
                       ingredientMgr.create(name: name, servingSize: servingSize, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, consumptionUnit: consumptionUnit, consumptionGrams: consumptionGrams, meat: meat, meatAdjustments: meatAdjustments, active: true)
                       presentationMode.wrappedValue.dismiss()
                   }
               })
    }
}

struct IngredientCreate_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientAdd()
              .environmentObject(IngredientMgr())
        }
    }
}
