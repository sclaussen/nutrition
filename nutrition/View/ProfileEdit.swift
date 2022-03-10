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
                PickerIntEdit("Gender", $profile.gender, options: Gender.values())
                IntEdit("Height", $profile.height, "in")
                DoubleEdit("Net Carbs Daily Max", $profile.netcarbsGoalUnadjusted, "grams")
            }
            Section {
                DoubleView("Age", profile.age, "yrs", precision: 1)
                DoubleView("Weight", profile.weightKg, "kgs", precision: 0)
                DoubleView("Height", profile.heightCm, "cm", precision: 0)
                DoubleView("Body Mass Index", profile.bodyMassIndex, precision: 1)
                DoubleView("Lean Body Mass", profile.leanBodyMass, "lbs", precision: 0)
                DoubleView("Fat Mass", profile.fatMass, "lbs", precision: 0)
            }
            Section(header: Text("Gross")) {
                DoubleView("Calories", profile.caloriesGoalUnadjusted, "kcals", precision: 0)
                DoubleView("Fat", profile.fatGoalUnadjusted, "grams", precision: 0)
                DoubleView("Fiber", profile.fiberGoalUnadjusted, "grams", precision: 0)
                DoubleView("Net Carbs", profile.netcarbsGoalUnadjusted, "grams", precision: 0)
                DoubleView("Protein", profile.proteinGoalUnadjusted, "grams", precision: 0)
                DoubleView("Fat %", profile.fatGoalPercentageUnadjusted, "%", precision: 0)
                DoubleView("Net Carbs %", profile.netcarbsGoalPercentageUnadjusted, "%", precision: 0)
                DoubleView("Protein %", profile.proteinGoalPercentageUnadjusted, "%", precision: 0)
            }
            Section(header: Text("Net (with the calorie deficit applied)")) {
                DoubleView("Calories", profile.caloriesGoal, "kcals", precision: 0)
                DoubleView("Fat", profile.fatGoal, "grams", precision: 0)
                DoubleView("Fiber", profile.fiberGoal, "grams", precision: 0)
                DoubleView("Net Carbs", profile.netcarbsGoal, "grams", precision: 0)
                DoubleView("Protein", profile.proteinGoal, "grams", precision: 0)
                DoubleView("Fat %", profile.fatGoalPercentage, "%", precision: 0)
                DoubleView("Net Carbs %", profile.netcarbsGoalPercentage, "%", precision: 0)
                DoubleView("Protein %", profile.proteinGoalPercentage, "%", precision: 0)
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .navigationBarItems(trailing: save)
    }

    var save: some View {
        Button("Save",
               action: {
                   withAnimation {
                       profileMgr.update(profile)
                       self.hideKeyboard()
                       presentationMode.wrappedValue.dismiss()
                   }
               })
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
