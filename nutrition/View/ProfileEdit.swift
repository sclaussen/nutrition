import SwiftUI

struct ProfileEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var profile: Profile

    @State var metric: Bool = false
    @State var height: Double = 0

    var body: some View {
        Form {
            Section {
                DateEdit("Date of Birth", $profile.dateOfBirth)
                PickerGenderEdit("Gender", $profile.gender, options: Gender.values())
                IntEdit("Height", $profile.height, Unit.inch)
                DoubleEdit("Net Carbs Daily Max", $profile.netcarbsGoalUnadjusted, Unit.gram)
            }
            Section {
                DoubleView("Age", profile.age, Unit.year, precision: 1)
                DoubleView("Weight", profile.weightKg, Unit.kilogram, precision: 0)
                DoubleView("Height", profile.heightCm, Unit.centimeter, precision: 0)
                DoubleView("Body Mass Index", profile.bodyMassIndex, precision: 1)
                DoubleView("Lean Body Mass", profile.leanBodyMass, Unit.pound, precision: 0)
                DoubleView("Fat Mass", profile.fatMass, Unit.pound, precision: 0)
            }
            Section(header: Text("Gross")) {
                DoubleView("Calories", profile.caloriesGoalUnadjusted, Unit.calorie, precision: 0)
                DoubleView("Fat", profile.fatGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Fiber", profile.fiberGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Net Carbs", profile.netcarbsGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Protein", profile.proteinGoalUnadjusted, Unit.gram, precision: 0)
                DoubleView("Fat %", profile.fatGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                DoubleView("Net Carbs %", profile.netcarbsGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                DoubleView("Protein %", profile.proteinGoalPercentageUnadjusted, Unit.percentage, precision: 0)
            }
            Section(header: Text("Net (with the calorie deficit applied)")) {
                DoubleView("Calories", profile.caloriesGoal, Unit.calorie, precision: 0)
                DoubleView("Fat", profile.fatGoal, Unit.gram, precision: 0)
                DoubleView("Fiber", profile.fiberGoal, Unit.gram, precision: 0)
                DoubleView("Net Carbs", profile.netcarbsGoal, Unit.gram, precision: 0)
                DoubleView("Protein", profile.proteinGoal, Unit.gram, precision: 0)
                DoubleView("Fat %", profile.fatGoalPercentage, Unit.percentage, precision: 0)
                DoubleView("Net Carbs %", profile.netcarbsGoalPercentage, Unit.percentage, precision: 0)
                DoubleView("Protein %", profile.proteinGoalPercentage, Unit.percentage, precision: 0)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
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
                                     profileMgr.update(profile)
                                     presentationMode.wrappedValue.dismiss()
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
