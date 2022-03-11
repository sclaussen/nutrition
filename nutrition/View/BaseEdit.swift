import SwiftUI

struct BaseEdit: View {

    enum Field: Hashable {
        case amount
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var baseMgr: BaseMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @FocusState private var focusedField: Field?

    @State var base: Base

    var body: some View {
        Form {
            Section {
                StringView("Ingredient", base.name)
                DoubleEdit("Current Amount", $base.amount, base.consumptionUnit)
                  .focused($focusedField, equals: .amount)
                DoubleEdit("Default Amount", $base.defaultAmount, base.consumptionUnit)
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
                                     baseMgr.update(base)
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

struct BaseUpdate_Previews: PreviewProvider {
    @State static var base = Base(name: "Arugula", defaultAmount: 145.0, amount: 145.0, consumptionUnit: Unit.gram, active: true)

    static var previews: some View {
        NavigationView {
            BaseEdit(base: base)
        }
    }
}
