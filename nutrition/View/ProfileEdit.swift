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
                NVDoubleEdit("Net Carbs Maximum", description: "consumption max (carbs - fiber)", $profileMgr.profile.netcarbsGoalUnadjusted, Unit.gram)
                NVDouble("Weight", description: "body mass (from health kit)", profileMgr.profile.bodyMass, Unit.pound, precision: 1)
                NVDouble("Body Fat %", description: "from health kit", profileMgr.profile.bodyFatPercentage, Unit.percentage, precision: 1)
            }
            Section {
                NVDouble("Age", profileMgr.profile.age, Unit.year, precision: 1)
                NVDouble("Weight", description: "body mass (from health kit)", profileMgr.profile.bodyMassKg, Unit.kilogram, precision: 0)
                NVDouble("Height", profileMgr.profile.heightCm, Unit.centimeter, precision: 0)
                NVDouble("Body Mass Index", description: "normal <25, fat >25, obese >30", profileMgr.profile.bodyMassIndex, precision: 1)
                NVDouble("Lean Body Mass", description: "non-fat body mass", profileMgr.profile.leanBodyMass, Unit.pound, precision: 0)
                NVDouble("Fat Mass", description: "weight * body fat percentage", profileMgr.profile.fatMass, Unit.pound, precision: 0)
                NVDouble("Water", description: "daily min, weight/2 * ~.03", profileMgr.profile.waterLiters, Unit.liter, precision: 1)
            }
            Section(header: Text("Gross (without the caloric deficit)")) {
                VStack {
                    NVDouble("Base Metabolic Rate", description: "Mifflin-St Jeor", profileMgr.profile.caloriesBaseMetabolicRate, Unit.calorie, precision: 0)
                    NVDouble("Resting Calories", description: "Mifflin-St Jeor BMR * 1.2", profileMgr.profile.caloriesResting, Unit.calorie, precision: 0)
                    NVDouble("Active Energy Burned", description: "daily daily exercise calories", profileMgr.profile.activeEnergyBurned, Unit.calorie, precision: 0)
                    NVDouble("Unadjusted Caloric Goal", description: "resting + active energy burned", profileMgr.profile.caloriesGoalUnadjusted, Unit.calorie, precision: 0)
                    NVDouble("Fat Goal", description: "caloric goal - netcarbs - protein", profileMgr.profile.fatGoalUnadjusted, Unit.gram, precision: 0)
                    NVDouble("Fiber Minimum", description: "14g fiber/1k consumed calories", profileMgr.profile.fiberGoalUnadjusted, Unit.gram, precision: 0)
                    NVDouble("Net Carbs Maximum", description: "consumption max (carbs - fiber)", profileMgr.profile.netcarbsGoalUnadjusted, Unit.gram, precision: 0)
                    NVDouble("Protein Goal", description: "lean body mass * protein ratio", profileMgr.profile.proteinGoalUnadjusted, Unit.gram, precision: 0)
                    NVDouble("Fat %", description: "percentage of calories from fat", profileMgr.profile.fatGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                    NVDouble("Net Carbs %", description: "percentage of calories from carbs", profileMgr.profile.netcarbsGoalPercentageUnadjusted, Unit.percentage, precision: 0)
                }
                NVDouble("Protein %", description: "percentage of calories from protein", profileMgr.profile.proteinGoalPercentageUnadjusted, Unit.percentage, precision: 0)
            }
            Section(header: Text("Net (with the caloric deficit)")) {
                NVDouble("Unadjusted Caloric Goal", description: "gross caloric goal", profileMgr.profile.caloriesGoalUnadjusted, Unit.calorie, precision: 0)
                NVInt("Caloric Deficit", description: "adjustment to daily gross caloric goal", profileMgr.profile.calorieDeficit, Unit.percentage)
                NVDouble("Net Caloric Goal", description: "with calorie deficit applied", profileMgr.profile.caloriesGoal, Unit.calorie, precision: 0)
                NVDouble("Fat Goal", description: "net caloric goal - netcarbs - protein", profileMgr.profile.fatGoal, Unit.gram, precision: 0)
                NVDouble("Fiber Minimum", description: "14g fiber/1000 consumed cal", profileMgr.profile.fiberGoal, Unit.gram, precision: 0)
                NVDouble("Net Carbs Maximum", description: "consumption max (carbs - fiber)", profileMgr.profile.netcarbsGoal, Unit.gram, precision: 0)
                NVDouble("Protein Goal", description: "lean body mass * protein ratio", profileMgr.profile.proteinGoal, Unit.gram, precision: 0)
                NVDouble("Fat %", description: "percentage of net calories from fat", profileMgr.profile.fatGoalPercentage, Unit.percentage, precision: 0)
                NVDouble("Net Carbs %", description: "percentage of net calories from carbs", profileMgr.profile.netcarbsGoalPercentage, Unit.percentage, precision: 0)
                NVDouble("Protein %", description: "percentage of net calories from protein", profileMgr.profile.proteinGoalPercentage, Unit.percentage, precision: 0)
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
