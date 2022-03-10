import SwiftUI

struct MealConfigure: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var baseMgr: BaseMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var profile: Profile

    // @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {

            Form {
                Section {
                    PickerEdit("Meat", $profile.meat, options: ingredientMgr.getMeatOptions())
                    DoubleEdit("Meat Weight", $profile.meatAmount, Unit.gram)
                }
                Section {
                    DoubleEdit("Weight", $profile.weight, Unit.pound, precision: 1)
                    DoubleEdit("Body Fat %", $profile.bodyFat, Unit.percentage, precision: 1)
                    IntEdit("Active Energy", $profile.activeEnergy, Unit.calorie)
                }
                Section {
                    DoubleEdit("Protein Ratio", $profile.proteinRatio, Unit.gramsPerLbm)
                    IntEdit("Calorie Deficit", $profile.calorieDeficit, Unit.percentage)
                    DoubleView("Water", profile.waterLiters, Unit.liter, precision: 1)
                }
                // Section {
                //     ZStack {
                //         NavigationLink(destination: MealView(meal: $meal), tag: "A", selection: $selection) { EmptyView() }
                //         Button("Generate Meal") {
                //             generateMeal()
                //             selection = "A"
                //         }
                //     }
                // }
            }
        }
          .padding([.leading, .trailing], -20)
          .navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  cancel
              }
              ToolbarItem(placement: .primaryAction) {
                  save
              }
          }
    }

    var cancel: some View {
        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
    }

    var save: some View {
        Button("Save",
               action: {
                   withAnimation {
                       profileMgr.update(profile)
                       presentationMode.wrappedValue.dismiss()
                   }
               })
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
