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
                    NameValue("Amount", $amount, foodMgr.consumptionUnit(for: name, ingredientMgr: ingredientMgr), edit: true)
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
          .cancelSaveToolbar(onCancel: cancel, onSave: save)
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
}


struct AdjustmentCreate_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            AdjustmentAdd()
              .environmentObject(AdjustmentMgr(profileId: "preview"))
        }
    }
}
