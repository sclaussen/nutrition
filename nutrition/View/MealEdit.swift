import SwiftUI

struct MealEdit: View {

    enum Field: Hashable {
        case amount
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @FocusState private var focusedField: Field?

    @State var mealIngredient: MealIngredient

    var body: some View {
        Form {
            Section {
                StringView("Ingredient", mealIngredient.name)
                DoubleEdit("Current Amount", $mealIngredient.amount, mealIngredient.consumptionUnit)
                  .focused($focusedField, equals: .amount)
                DoubleEdit("Default Amount", $mealIngredient.defaultAmount, mealIngredient.consumptionUnit)
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
                                     mealIngredientMgr.update(mealIngredient)
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
    @State static var base = MealIngredient(name: "Arugula", defaultAmount: 145.0, amount: 145.0)

    static var previews: some View {
        NavigationView {
            MealEdit(mealIngredient: base)
        }
    }
}
