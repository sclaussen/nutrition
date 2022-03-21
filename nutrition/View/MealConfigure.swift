import SwiftUI

struct MealConfigure: View {

    enum Field: Hashable {
        case bodyMass
        case meatAmount
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    @FocusState var focusedField: Field?


    var body: some View {
        VStack(spacing: 0) {

            Form {
                Section {
                    NVDoubleEdit("Weight", $profileMgr.profile.bodyMass, Unit.pound, precision: 1)
                      .focused($focusedField, equals: .bodyMass)
                    NVDoubleEdit("Body Fat %", $profileMgr.profile.bodyFatPercentage, Unit.percentage, precision: 1)
                    NVIntEdit("Active Energy", $profileMgr.profile.activeEnergy, Unit.calorie)
                }
                Section {
                    NVPickerEdit("Meat", $profileMgr.profile.meat, options: ingredientMgr.getMeatOptions())
                    if profileMgr.profile.meat != "None" {
                        NVDoubleEdit("Meat Weight", $profileMgr.profile.meatAmount, Unit.gram)
                    }
                }
                Section {
                    NVDoubleEdit("Protein Ratio", $profileMgr.profile.proteinRatio, Unit.gramsPerLbm)
                    NVIntEdit("Calorie Deficit", $profileMgr.profile.calorieDeficit, Unit.percentage)
                    NVDouble("Water", profileMgr.profile.waterLiters, Unit.liter, precision: 1)
                }
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
                  self.focusedField = .meatAmount
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
