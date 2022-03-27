import SwiftUI

struct AdjustmentEdit: View {

    enum Field: Hashable {
        case amount
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @FocusState private var focusedField: Field?

    @State var adjustment: Adjustment

    var body: some View {
        Form {
            Section {
                NameValue("Ingredient", $adjustment.name, .none)
                NameValue("Amount", description: "Amount added per adjustment", $adjustment.amount, adjustment.consumptionUnit, edit: true)
                  .focused($focusedField, equals: .amount)
            }
            Section {
                NVToggleEdit("Constraints", $adjustment.constraints)
                if adjustment.constraints {
                    NameValue("Maximum", description: "Maximum auto-added to meal", $adjustment.maximum, .can, edit: true)
                }
            }
            Section {
                NameValue("Choice Group", description: "Random selection group", $adjustment.group, .none, edit: true)
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
                                     adjustmentMgr.update(adjustment)
                                     presentationMode.wrappedValue.dismiss()
                                 }
                             })
                  }
              }
          }
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                  self.focusedField = .amount
              }
          }
    }

    var cancel: some View {
        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
    }
}

struct AdjustmentUpdate_Previews: PreviewProvider {
    @State static var adjustment = Adjustment(name: "Arugula", amount: 145)

    static var previews: some View {
        NavigationView {
            AdjustmentEdit(adjustment: adjustment)
        }
    }
}
