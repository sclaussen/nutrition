import SwiftUI


struct AdjustmentAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var foodMgr: FoodMgr

    @State var name: String = ""
    @State var amount: Double = 0
    @State var constraints: Bool = false
    @State var maximum: Double = 0
    @State var group: String = ""


    var body: some View {
        Form {
            Section {
                NameValue("Ingredient", $name, options: ingredientMgr.getNewMealIngredientNames(existingMealIngredientNames: adjustmentMgr.getNames()), control: .picker)
                if name.count > 0 {
                    NameValue("Amount", $amount, getConsumptionUnit(name), edit: true)
                }
            }
            //            if name.count > 0 {
            //                Section {
            //                    NameValue("Constraints", $constraints, control: .toggle)
            //                    if constraints {
            //                        NameValue("Maximum", $maximum, edit: true)
            //                    }
            //                }
            //                Section {
            //                    NameValue("Choice Group", $group, edit: true)
            //                }
            //            }
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
            adjustmentMgr.create(name: name, amount: amount, group: group, active: true)
            presentationMode.wrappedValue.dismiss()
        }
    }


    // `name` is a Food name (an adjustment targets a Food). Resolve
    // via FoodMgr to the Food's current member; never force-unwraps
    // (the bare canonical ingredients are gone).
    func getConsumptionUnit(_ name: String) -> Unit {
        if let f = foodMgr.getByName(name: name),
           let ing = ingredientMgr.getByName(name: f.currentIngredientName) {
            return foodMgr.consumptionUnit(for: ing)
        }
        if let ing = ingredientMgr.getByName(name: name) {
            return foodMgr.consumptionUnit(for: ing)
        }
        return .gram
    }
}


struct AdjustmentCreate_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            AdjustmentAdd()
              .environmentObject(AdjustmentMgr())
        }
    }
}
