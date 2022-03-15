import SwiftUI

struct MealConfigure: View {

    enum Field: Hashable {
        case weight
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
                    DoubleEdit("Weight", $profileMgr.profile.weight, Unit.pound, precision: 1)
                      .focused($focusedField, equals: .weight)
                    DoubleEdit("Body Fat %", $profileMgr.profile.bodyFat, Unit.percentage, precision: 1)
                    IntEdit("Active Energy", $profileMgr.profile.activeEnergy, Unit.calorie)
                }
                Section {
                    PickerEdit("Meat", $profileMgr.profile.meat, options: ingredientMgr.getMeatOptions())
                    DoubleEdit("Meat Weight", $profileMgr.profile.meatAmount, Unit.gram)
                }
                Section {
                    DoubleEdit("Protein Ratio", $profileMgr.profile.proteinRatio, Unit.gramsPerLbm)
                    IntEdit("Calorie Deficit", $profileMgr.profile.calorieDeficit, Unit.percentage)
                    DoubleView("Water", profileMgr.profile.waterLiters, Unit.liter, precision: 1)
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
                                     profileMgr.save()
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
