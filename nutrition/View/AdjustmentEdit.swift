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
                StringView("Ingredient", adjustment.name)
                DoubleEdit("Amount", $adjustment.amount, adjustment.consumptionUnit)
                  .focused($focusedField, equals: .amount)
            }
            Section {
                ToggleEdit("Constraints", $adjustment.constraints)
                if adjustment.constraints {
                    DoubleEdit("Minimum", $adjustment.minimum)
                    DoubleEdit("Maximum", $adjustment.maximum)
                }
            }
            Section {
                StringEdit("Group", $adjustment.group)
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
