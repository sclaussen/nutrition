import SwiftUI

struct ProfileEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @Binding var tab: String

    var body: some View {
        Form {
            Section {
                DateEdit("Date of Birth", $profileMgr.profile.dateOfBirth)
                PickerGenderEdit("Gender", $profileMgr.profile.gender, options: Gender.values())
                IntEdit("Height", $profileMgr.profile.height, Unit.inch)
                DoubleEdit("NetCarbs Ceiling", $profileMgr.profile.netcarbsGoalUnadjusted, Unit.gram)
            }
            Section {
                DoubleView("Age", profileMgr.profile.age, Unit.year, precision: 1)
                DoubleView("Weight", profileMgr.profile.weightKg, Unit.kilogram, precision: 0)
                DoubleView("Height", profileMgr.profile.heightCm, Unit.centimeter, precision: 0)
                DoubleView("Body Mass Index", profileMgr.profile.bodyMassIndex, precision: 1)
                DoubleView("Lean Body Mass", profileMgr.profile.leanBodyMass, Unit.pound, precision: 0)
                DoubleView("Fat Mass", profileMgr.profile.fatMass, Unit.pound, precision: 0)
            }
            Section(header: Text("Gross")) {
                DoubleView("Calories", profileMgr.profile.caloriesGoalUnadjusted, Unit.calorie, precision: 0)
                DoubleView("Fat", profileMgr.profile.fatGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Fiber", profileMgr.profile.fiberGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Net Carbs", profileMgr.profile.netcarbsGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Protein", profileMgr.profile.proteinGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Fat %", profileMgr.profile.fatGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                DoubleView("Net Carbs %", profileMgr.profile.netcarbsGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                DoubleView("Protein %", profileMgr.profile.proteinGoalPercentageUnadjusted, Unit.percentage, precision: 0)
            }
            Section(header: Text("Net (with the calorie deficit applied)")) {
                DoubleView("Calories", profileMgr.profile.caloriesGoal, Unit.calorie, precision: 0)
                DoubleView("Fat", profileMgr.profile.fatGoal, Unit.gram, precision: 0)
                DoubleView("Fiber", profileMgr.profile.fiberGoal, Unit.gram, precision: 0)
                DoubleView("Net Carbs", profileMgr.profile.netcarbsGoal, Unit.gram, precision: 0)
                DoubleView("Protein", profileMgr.profile.proteinGoal, Unit.gram, precision: 0)
                DoubleView("Fat %", profileMgr.profile.fatGoalPercentage, Unit.percentage, precision: 0)
                DoubleView("Net Carbs %", profileMgr.profile.netcarbsGoalPercentage, Unit.percentage, precision: 0)
                DoubleView("Protein %", profileMgr.profile.proteinGoalPercentage, Unit.percentage, precision: 0)
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
                                     profileMgr.save()
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
