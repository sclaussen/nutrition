import SwiftUI

struct BaseAdd: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var baseMgr: BaseMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var name: String = ""
    @State var defaultAmount: Double = 0

    var body: some View {
        Form {
            Section {
                PickerEdit("Ingredient", $name, options: ingredientMgr.getPickerOptions(existing: baseMgr.getNames()))
                if name.count > 0 {
                    DoubleEdit("Amount", $defaultAmount, ingredientMgr.getIngredient(name: name)!.consumptionUnit)
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
                       baseMgr.create(name: name, defaultAmount: defaultAmount, amount: defaultAmount, consumptionUnit: ingredientMgr.getIngredient(name: name)!.consumptionUnit, active: true)
                       presentationMode.wrappedValue.dismiss()
                   }
               })
    }
}

struct BaseCreate_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BaseAdd()
              .environmentObject(BaseMgr())
        }
    }
}
