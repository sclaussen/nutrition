import SwiftUI

struct ProfileEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @Binding var tab: String

    var body: some View {
        Form {
            Section {
                NameValue("Date of Birth", $profileMgr.profile.dateOfBirth, control: .date)
                NVPickerGenderEdit("Gender", $profileMgr.profile.gender, options: Gender.values())
                NameValue("Height", $profileMgr.profile.height, Unit.inch, edit: true)
                NameValue("Net Carbs Maximum", description: "consumption max (carbs - fiber)", $profileMgr.profile.netCarbsMaximum, edit: true)
                NameValue("Weight", description: "body mass (from health kit)", $profileMgr.profile.bodyMass, Unit.pound, precision: 1, edit: true)
                NameValue("Body Fat %", description: "from health kit", $profileMgr.profile.bodyFatPercentage, Unit.percentage, precision: 1)
            }
            Section {
                NameValue("Age", $profileMgr.profile.age, Unit.year, precision: 1)
                NameValue("Weight", description: "body mass (from health kit)", $profileMgr.profile.bodyMassKg, Unit.kilogram)
                NameValue("Height", $profileMgr.profile.heightCm, Unit.centimeter)
                NameValue("Body Mass Index", description: "normal <25, fat >25, obese >30", $profileMgr.profile.bodyMassIndex, precision: 1)
                NameValue("Lean Body Mass", description: "non-fat body mass", $profileMgr.profile.leanBodyMass, Unit.pound)
                NameValue("Fat Mass", description: "weight * body fat percentage", $profileMgr.profile.fatMass, Unit.pound)
                NameValue("Water", description: "daily min, weight/2 * ~.03", $profileMgr.profile.waterLiters, Unit.liter, precision: 1)
            }
            Section(header: Text("Gross (without the caloric deficit)")) {
                VStack {
                    NameValue("Base Metabolic Rate", description: "Mifflin-St Jeor", $profileMgr.profile.caloriesBaseMetabolicRate, Unit.calorie)
                    NameValue("Resting Calories", description: "Mifflin-St Jeor BMR * 1.2", $profileMgr.profile.caloriesResting, Unit.calorie)
                    NameValue("Active Energy Burned", description: "daily daily exercise calories", $profileMgr.profile.activeEnergyBurned, Unit.calorie)
                    NameValue("Unadjusted Caloric Goal", description: "resting + active energy burned", $profileMgr.profile.caloriesGoalUnadjusted, Unit.calorie)
                    NameValue("Fat Goal", description: "caloric goal - netCarbs - protein", $profileMgr.profile.fatGoalUnadjusted)
                    NameValue("Fiber Minimum", description: "14g fiber/1k consumed calories", $profileMgr.profile.fiberMinimumUnadjusted)
                    NameValue("Net Carbs Maximum", description: "consumption max (carbs - fiber)", $profileMgr.profile.netCarbsMaximum)
                    NameValue("Protein Goal", description: "lean body mass * protein ratio", $profileMgr.profile.proteinGoalUnadjusted)
                    NameValue("Fat %", description: "percentage of calories from fat", $profileMgr.profile.fatGoalPercentageUnadjusted, Unit.percentage)
                    NameValue("Net Carbs %", description: "percentage of calories from carbs", $profileMgr.profile.netCarbsMaximumPercentageUnadjusted, Unit.percentage)
                }
                NameValue("Protein %", description: "percentage of calories from protein", $profileMgr.profile.proteinGoalPercentageUnadjusted, Unit.percentage)
            }
            Section(header: Text("Net (with the caloric deficit)")) {
                NameValue("Unadjusted Caloric Goal", description: "gross caloric goal", $profileMgr.profile.caloriesGoalUnadjusted, Unit.calorie)
                NameValue("Caloric Deficit", description: "adjustment to daily gross caloric goal", $profileMgr.profile.calorieDeficit, Unit.percentage)
                NameValue("Net Caloric Goal", description: "with calorie deficit applied", $profileMgr.profile.caloriesGoal, Unit.calorie)
                NameValue("Fat Goal", description: "net caloric goal - netCarbs - protein", $profileMgr.profile.fatGoal)
                NameValue("Fiber Minimum", description: "14g fiber/1000 consumed cal", $profileMgr.profile.fiberMinimum)
                NameValue("Net Carbs Maximum", description: "consumption max (carbs - fiber)", $profileMgr.profile.netCarbsMaximum)
                NameValue("Protein Goal", description: "lean body mass * protein ratio", $profileMgr.profile.proteinGoal)
                NameValue("Fat %", description: "percentage of net calories from fat", $profileMgr.profile.fatGoalPercentage, Unit.percentage)
                NameValue("Net Carbs %", description: "percentage of net calories from carbs", $profileMgr.profile.netCarbsMaximumPercentage, Unit.percentage)
                NameValue("Protein %", description: "percentage of net calories from protein", $profileMgr.profile.proteinGoalPercentage, Unit.percentage)
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
