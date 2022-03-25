import SwiftUI

struct MealConfigure: View {

    enum Field: Hashable {
        case activeEnergyBurned
        case meatAmount
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    @FocusState var focusedField: Field?


    var body: some View {
        Form {
            Section {
                NVDoubleEdit("Active Energy Burned", description: "daily exercise calories", $profileMgr.profile.activeEnergyBurned, Unit.calorie, precision: 0)
                      .focused($focusedField, equals: .activeEnergyBurned)
                NVPickerEdit("Meat", $profileMgr.profile.meat, options: ingredientMgr.getMeatOptions())
                if profileMgr.profile.meat != "None" {
                    NVDoubleEdit("Meat Weight", $profileMgr.profile.meatAmount, Unit.gram)
                }
            }
            // Section {
            //     NVDoubleEdit("Weight", $profileMgr.profile.bodyMass, Unit.pound, precision: 1)
            //     NVDoubleEdit("Body Fat %", $profileMgr.profile.bodyFatPercentage, Unit.percentage, precision: 1)
            // }
            Section {
                NVDoubleEdit("Protein Ratio", description: "protein grams/pound of lbm", $profileMgr.profile.proteinRatio, Unit.gramsPerLbm)
                NVIntEdit("Caloric Deficit", description: "adjustment to daily gross caloric goal", $profileMgr.profile.calorieDeficit, Unit.percentage)
                NVDouble("Water", description: "daily min, weight/2 * ~.03", profileMgr.profile.waterLiters, Unit.liter, precision: 1)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: {
                                       profileMgr.cancel()
                                       self.presentationMode.wrappedValue.dismiss()
                                   })
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
                                     profileMgr.serialize()
                                     presentationMode.wrappedValue.dismiss()
                                 }
                             })
                  }
              }
          }
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                  self.focusedField = .activeEnergyBurned
              }
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
