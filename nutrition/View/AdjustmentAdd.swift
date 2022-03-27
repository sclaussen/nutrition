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
                NVPickerEdit("Ingredient", $name, options: ingredientMgr.getPickerOptions(existing: adjustmentMgr.getNames()))
                if name.count > 0 {
                    NameValue("Amount", $amount, ingredientMgr.getIngredient(name: name)!.consumptionUnit, edit: true)
                }
            }
            if name.count > 0 {
                Section {
                    NVToggleEdit("Constraints", $constraints)
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
                                     adjustmentMgr.create(name: name, amount: amount, consumptionUnit: ingredientMgr.getIngredient(name: name)!.consumptionUnit, group: group, active: true)
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

struct AdjustmentCreate_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdjustmentAdd()
              .environmentObject(AdjustmentMgr())
        }
    }
}
