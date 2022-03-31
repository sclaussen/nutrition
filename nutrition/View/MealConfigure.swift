import SwiftUI

struct MealConfigure: View {

    enum Field: Hashable {
        case activeCaloriesBurned
        case meatAmount
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    @FocusState var focusedField: Field?


    var body: some View {
        Form {
            Section {
                NameValue("Active Calories Burned", description: "daily calories burned due to exercise/movement", $profileMgr.profile.activeCaloriesBurned, .calorie, edit: true)
                  .focused($focusedField, equals: .activeCaloriesBurned)
                if !profileMgr.profile.bodyMassFromHealthKit {
                    NameValue("Weight", $profileMgr.profile.bodyMass, .pound, precision: 1, edit: true)
                }
                if !profileMgr.profile.bodyFatPercentageFromHealthKit {
                    NameValue("Body Fat %", $profileMgr.profile.bodyFatPercentage, .percentage, precision: 1, edit: true)
                }
                NameValue("Protein Ratio", description: "daily protein grams required / lb of lean body mass", $profileMgr.profile.proteinRatio, precision: 2, edit: true)
                NameValue("Caloric Deficit", description: "percentage to adjust daily caloric and macro goals", $profileMgr.profile.calorieDeficit, .percentage, edit: true)
                NameValue("Water Minimum", description: "daily consumption mininimum, weight/2 * ~.03", $profileMgr.profile.waterLiters, .liter, precision: 1)
            }
            Section {
                NameValue("Meat", description: "main course", $profileMgr.profile.meat, options: ingredientMgr.getAllMeatNames(), control: .picker)
//                  .onChange(of: $profileMgr.profile.meat) { (newValue) in
//                      print("Meat changed", newValue)
//                  }
                if profileMgr.profile.meat != "None" {
                    NameValue("Meat Weight", $profileMgr.profile.meatAmount, edit: true)
                }
                //                    ForEach(ingredientMgr.getIngredient(name: $profileMgr.profile.meat), id: \.self) { ingredient in
                //                        print(ingredient.name)
                //                        // Section(header: Text("Base Meal Adjustment #" + String(index + 1))) {
                //                        //     NameValue("Ingredient", $ingredient.mealAdjustments[index].name)
                //                        //     NameValue("Amount", $ingredient.mealAdjustments[index].amount, ingredientMgr.getIngredient(name: ingredient.mealAdjustments[index].name)!.consumptionUnit, negative: true, edit: true)
                //                        // }
                //                    }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                  self.focusedField = .activeCaloriesBurned
              }
          }
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
                  DismissKeyboard()
                  Spacer()
                  Button("Save", action: save)
                    .foregroundColor(Color("Blue"))
              }
          }
    }

    func cancel() {
        withAnimation {
            profileMgr.cancel()
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    func save() {
        withAnimation {
            profileMgr.serialize()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct PrepView_Previews: PreviewProvider {
//
//    @StateObject static var profileMgr: ProfileMgr = ProfileMgr()
//
//    static var previews: some View {
//        NavigationView {
//            Daily(profile: profileMgr.profile!)
//        }
//    }
//}
