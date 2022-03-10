import SwiftUI

struct AdjustmentAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var name: String = ""
    @State var amount: Double = 0
    @State var constraints: Bool = false
    @State var minimum: Double = 0
    @State var maximum: Double = 0

    var body: some View {
        Form {
            Section {
                PickerEdit("Ingredient", $name, options: ingredientMgr.getPickerOptions(existing: adjustmentMgr.getNames()))
                if name.count > 0 {
                    DoubleEdit("Amount", $amount, ingredientMgr.getIngredient(name: name)!.consumptionUnit)
                }
            }
            if name.count > 0 {
                Section {
                    ToggleEdit("Constraints", $constraints)
                    if constraints {
                        DoubleEdit("Minimum", $minimum)
                        DoubleEdit("Maximum", $maximum)
                    }
                }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .navigationBarItems(leading: cancel)
          .navigationBarItems(trailing: save)
    }

    var cancel: some View {
        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
    }

    var save: some View {
        Button("Save",
               action: {
                   withAnimation {
                       adjustmentMgr.create(name: name, amount: amount, consumptionUnit: ingredientMgr.getIngredient(name: name)!.consumptionUnit, active: true)
                       presentationMode.wrappedValue.dismiss()
                   }
               })
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
