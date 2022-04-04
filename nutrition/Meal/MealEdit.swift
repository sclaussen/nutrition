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
                NameValue("Ingredient", $mealIngredient.name)
                NameValue("Current Amount", $mealIngredient.amount, getConsumptionUnit(mealIngredient.name), edit: true)
                  .focused($focusedField, equals: .amount)
                NameValue("Default Amount", $mealIngredient.defaultAmount, getConsumptionUnit(mealIngredient.name), edit: true)
            }
        }
          .onSubmit {
              mealIngredientMgr.update(mealIngredient)
              presentationMode.wrappedValue.dismiss()
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
            mealIngredientMgr.update(mealIngredient)
            presentationMode.wrappedValue.dismiss()
        }
    }

    func getConsumptionUnit(_ name: String) -> Unit {
        return ingredientMgr.getIngredient(name: name)!.consumptionUnit
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
