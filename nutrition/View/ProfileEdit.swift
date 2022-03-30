import SwiftUI

struct ProfileEdit: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @Binding var tab: String

    var body: some View {
        Form {
            Section {
                NameValue("Date of Birth", $profileMgr.profile.dateOfBirth, control: .date)
                NameValue("Gender", $profileMgr.profile.gender, options: Gender.allCases, control: .picker)
                NameValue("Height", $profileMgr.profile.height, .inch, edit: true)
                NameValue("Net Carbs Maximum", description: "daily consumption maximum (carbs - fiber)", $profileMgr.profile.netCarbsMaximum, edit: true)
                NameValue("Weight", description: "body mass (from apple health kit)", $profileMgr.profile.bodyMass, .pound, precision: 1)
                NameValue("Body Fat %", description: "from apple health kit", $profileMgr.profile.bodyFatPercentage, .percentage, precision: 1)
            }
            Section {
                NameValue("Age", $profileMgr.profile.age, .year, precision: 1)
                NameValue("Weight", description: "body mass (from health kit)", $profileMgr.profile.bodyMassKg, .kilogram)
                NameValue("Height", $profileMgr.profile.heightCm, .centimeter)
                NameValue("Body Mass Index", description: "normal <25, fat >25, obese >30", $profileMgr.profile.bodyMassIndex, precision: 1)
                NameValue("Lean Body Mass", description: "non-fat body mass", $profileMgr.profile.leanBodyMass, .pound)
                NameValue("Fat Mass", description: "weight * body fat percentage", $profileMgr.profile.fatMass, .pound)
                NameValue("Water", description: "daily consumption minimum, weight/2 * ~.03", $profileMgr.profile.waterLiters, .liter, precision: 1)
            }
            Section(header: Text("Gross (without the caloric deficit)")) {
                Group {
                    NameValue("Base Metabolic Rate", description: "Mifflin-St Jeor", $profileMgr.profile.caloriesBaseMetabolicRate, .calorie)
                    NameValue("Resting Calories", description: "Mifflin-St Jeor BMR * 1.2", $profileMgr.profile.caloriesResting, .calorie)
                    NameValue("Active Calories Burned", description: "daily calories burned due to exercise/movement", $profileMgr.profile.activeCaloriesBurned, .calorie)
                    NameValue("Unadjusted Caloric Goal", description: "resting + active energy burned", $profileMgr.profile.caloriesGoalUnadjusted, .calorie)
                    NameValue("Fat Goal", description: "caloric goal - netCarbs - protein", $profileMgr.profile.fatGoalUnadjusted)
                    NameValue("Fiber Minimum", description: "14g fiber/1k consumed calories", $profileMgr.profile.fiberMinimumUnadjusted)
                    NameValue("Net Carbs Maximum", description: "consumption max (carbs - fiber)", $profileMgr.profile.netCarbsMaximum)
                    NameValue("Protein Goal", description: "lean body mass * protein ratio", $profileMgr.profile.proteinGoalUnadjusted)
                    NameValue("Fat %", description: "percentage of calories from fat", $profileMgr.profile.fatGoalPercentageUnadjusted, .percentage)
                    NameValue("Net Carbs %", description: "percentage of calories from carbs", $profileMgr.profile.netCarbsMaximumPercentageUnadjusted, .percentage)
                }
                NameValue("Protein %", description: "percentage of calories from protein", $profileMgr.profile.proteinGoalPercentageUnadjusted, .percentage)
            }
            Section(header: Text("Net (with the caloric deficit)")) {
                NameValue("Unadjusted Caloric Goal", description: "gross caloric goal", $profileMgr.profile.caloriesGoalUnadjusted, .calorie)
                NameValue("Caloric Deficit", description: "adjustment to daily gross caloric goal", $profileMgr.profile.calorieDeficit, .percentage)
                NameValue("Net Caloric Goal", description: "with calorie deficit applied", $profileMgr.profile.caloriesGoal, .calorie)
                NameValue("Fat Goal", description: "net caloric goal - netCarbs - protein", $profileMgr.profile.fatGoal)
                NameValue("Fiber Minimum", description: "14g fiber/1000 consumed cal", $profileMgr.profile.fiberMinimum)
                NameValue("Net Carbs Maximum", description: "consumption max (carbs - fiber)", $profileMgr.profile.netCarbsMaximum)
                NameValue("Protein Goal", description: "lean body mass * protein ratio", $profileMgr.profile.proteinGoal)
                NameValue("Fat %", description: "percentage of net calories from fat", $profileMgr.profile.fatGoalPercentage, .percentage)
                NameValue("Net Carbs %", description: "percentage of net calories from carbs", $profileMgr.profile.netCarbsMaximumPercentage, .percentage)
                NameValue("Protein %", description: "percentage of net calories from protein", $profileMgr.profile.proteinGoalPercentage, .percentage)
            }
        }
        // .environment(\.defaultMinListRowHeight, 60)
        // .environment(\.defaultMinListHeaderHeight, 45)
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  Button("Cancel", action: cancel)
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItem(placement: .primaryAction) {
                  Button("Save", action: save)
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItemGroup(placement: .keyboard) {
                  HStack {
                      DismissKeyboard()
                      Spacer()
                      Button("Save", action: save)
                        .foregroundColor(Color("Blue"))
                  }
              }
          }
    }

    func cancel() {
        withAnimation {
            profileMgr.cancel()
            tab = "Meal"
        }
    }

    func save() {
        withAnimation {
            profileMgr.serialize()
            tab = "Meal"
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
