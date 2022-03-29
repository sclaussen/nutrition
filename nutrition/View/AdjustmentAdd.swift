import SwiftUI

struct AdjustmentAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var name: String = ""
    @State var amount: Float = 0
    @State var constraints: Bool = false
    @State var maximum: Float = 0
    @State var group: String = ""

    var body: some View {
        Form {
            Section {
                NameValue("Ingredient", $name, options: ingredientMgr.getNewMeatNames(existing: adjustmentMgr.getNames()), control: .picker)
                if name.count > 0 {
                    NameValue("Amount", $amount, ingredientMgr.getIngredient(name: name)!.consumptionUnit, edit: true)
                }
            }
            if name.count > 0 {
                Section {
                    NameValue("Constraints", $constraints, control: .toggle)
                    if constraints {
                        NameValue("Maximum", $maximum, edit: true)
                    }
                }
                Section {
                    NameValue("Choice Group", $group, edit: true)
                }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
              }
              ToolbarItem(placement: .primaryAction) {
                  Button("Save",
                         action: {
                             withAnimation {
                                 adjustmentMgr.create(name: name, amount: amount, consumptionUnit: ingredientMgr.getIngredient(name: name)!.consumptionUnit, group: group, active: true)
                                 presentationMode.wrappedValue.dismiss()
                             }
                         })
              }
              ToolbarItemGroup(placement: .keyboard) {
                  DismissKeyboard()
              }
          }
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
