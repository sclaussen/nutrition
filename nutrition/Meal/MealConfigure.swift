import SwiftUI

struct MealConfigure: View {

    enum Field: Hashable {
        case activeCaloriesBurned
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
            // Meat picker / weight removed — meat is now an ordinary
            // grouped Food. Add it to the meal from the Prep page or
            // the Meal Add dialog; duplicate any row by double-tapping
            // it; switch a row's member via long-press.
        }
          .padding([.leading, .trailing], -20)
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                  self.focusedField = .activeCaloriesBurned
              }
          }
          .cancelSaveToolbar(onCancel: cancel, onSave: save)
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
