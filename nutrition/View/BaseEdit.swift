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
          .navigationBarItems(leading: cancel)
          .navigationBarItems(trailing: save)
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  self.focusedField = .amount
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
                       baseMgr.update(base)
                       presentationMode.wrappedValue.dismiss()
                   }
               })
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
