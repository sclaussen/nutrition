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
                NameValue("Ingredient", $adjustment.name)
                NameValue("Amount", description: "Amount added per adjustment", $adjustment.amount, getConsumptionUnit(adjustment.name), edit: true)
                  .focused($focusedField, equals: .amount)
            }
            Section {
                NameValue("Constraints", $adjustment.constraints, control: .toggle)
                if adjustment.constraints {
                    NameValue("Maximum", description: "Maximum auto-added to meal", $adjustment.maximum, getConsumptionUnit(adjustment.name), edit: true)
                }
            }
            Section {
                NameValue("Choice Group", description: "Random selection group", $adjustment.group, edit: true)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: cancel)
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItem(placement: .primaryAction) {
                  Button("Save", action: save)
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItemGroup(placement: .keyboard) {
                  HStack {
                      DismissKeyboard()
                      Spacer()
                      Button("Save", action: save)
                        .foregroundColor(Color("Blue"))
                  }
              }
          }
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                  self.focusedField = .amount
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
            adjustmentMgr.update(adjustment)
            presentationMode.wrappedValue.dismiss()
        }
    }

    func getConsumptionUnit(_ name: String) -> Unit {
        return ingredientMgr.getIngredient(name: name)!.consumptionUnit
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
