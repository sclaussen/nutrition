import SwiftUI

struct ProfileEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @Binding var tab: String

    var body: some View {
        Form {
            Section {
                NVDateEdit("Date of Birth", $profileMgr.profile.dateOfBirth)
                NVPickerGenderEdit("Gender", $profileMgr.profile.gender, options: Gender.values())
                NVIntEdit("Height", $profileMgr.profile.height, Unit.inch)
                NVDoubleEdit("NetCarbs Ceiling", $profileMgr.profile.netcarbsGoalUnadjusted, Unit.gram)
            }
            Section {
                NVDouble("Age", profileMgr.profile.age, Unit.year, precision: 1)
                NVDouble("Weight", profileMgr.profile.bodyMassKg, Unit.kilogram, precision: 0)
                NVDouble("Height", profileMgr.profile.heightCm, Unit.centimeter, precision: 0)
                NVDouble("Body Mass Index", profileMgr.profile.bodyMassIndex, precision: 1)
                NVDouble("Lean Body Mass", profileMgr.profile.leanBodyMass, Unit.pound, precision: 0)
                NVDouble("Fat Mass", profileMgr.profile.fatMass, Unit.pound, precision: 0)
            }
            Section(header: Text("Gross")) {
                NVDouble("Calories", profileMgr.profile.caloriesGoalUnadjusted, Unit.calorie, precision: 0)
                NVDouble("Fat", profileMgr.profile.fatGoalUnadjusted, Unit.gram, precision: 0)
                NVDouble("Fiber", profileMgr.profile.fiberGoalUnadjusted, Unit.gram, precision: 0)
                NVDouble("Net Carbs", profileMgr.profile.netcarbsGoalUnadjusted, Unit.gram, precision: 0)
                NVDouble("Protein", profileMgr.profile.proteinGoalUnadjusted, Unit.gram, precision: 0)
                NVDouble("Fat %", profileMgr.profile.fatGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                NVDouble("Net Carbs %", profileMgr.profile.netcarbsGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                NVDouble("Protein %", profileMgr.profile.proteinGoalPercentageUnadjusted, Unit.percentage, precision: 0)
            }
            Section(header: Text("Net (with the calorie deficit applied)")) {
                NVDouble("Calories", profileMgr.profile.caloriesGoal, Unit.calorie, precision: 0)
                NVDouble("Fat", profileMgr.profile.fatGoal, Unit.gram, precision: 0)
                NVDouble("Fiber", profileMgr.profile.fiberGoal, Unit.gram, precision: 0)
                NVDouble("Net Carbs", profileMgr.profile.netcarbsGoal, Unit.gram, precision: 0)
                NVDouble("Protein", profileMgr.profile.proteinGoal, Unit.gram, precision: 0)
                NVDouble("Fat %", profileMgr.profile.fatGoalPercentage, Unit.percentage, precision: 0)
                NVDouble("Net Carbs %", profileMgr.profile.netcarbsGoalPercentage, Unit.percentage, precision: 0)
                NVDouble("Protein %", profileMgr.profile.proteinGoalPercentage, Unit.percentage, precision: 0)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: {
                                       profileMgr.cancel()
                                       tab = "Meal"
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
                                     tab = "Meal"
                                 }
                             })
                  }
              }
          }
    }
}

//struct ProfileEdit_Previews: PreviewProvider {
//    @StateObject static var profileMgr: ProfileMgr = ProfileMgr()
//
//    static var previews: some View {
//        NavigationView {
//            ProfileEdit(profile: profileMgr.profile!)
//        }
//    }
//}
