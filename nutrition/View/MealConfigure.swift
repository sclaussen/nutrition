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
                NameValue("Meat", $profileMgr.profile.meat, options: ingredientMgr.getAllMeatNames(), control: .picker)
                if profileMgr.profile.meat != "None" {
                    NameValue("Meat Weight", $profileMgr.profile.meatAmount, edit: true)
                }
            }
            Section {
                NameValue("Active Energy Burned", description: "daily exercise calories", $profileMgr.profile.activeEnergyBurned, .calorie, edit: true)
                      .focused($focusedField, equals: .activeEnergyBurned)
                NameValue("Weight", $profileMgr.profile.bodyMass, .pound, precision: 1, edit: true)
                NameValue("Body Fat %", $profileMgr.profile.bodyFatPercentage, .percentage, precision: 1, edit: true)
            }
            Section {
                NameValue("Water Minimum", description: "daily min, weight/2 * ~.03", $profileMgr.profile.waterLiters, .liter, precision: 1)
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
