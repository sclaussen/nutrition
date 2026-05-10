import SwiftUI


struct DailySummary: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var macrosMgr: MacrosMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var vitaminMineralMgr: VitaminMineralMgr


    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }


    var body: some View {
        let macros = macrosMgr.macros
        let profile = profileMgr.profile

        NavigationView {
            List {

                Section(header: Text("Calories")) {
                    let goal = profile.caloriesGoal
                    let actual = macros.calories
                    let pct = goal > 0 ? Int((actual / goal) * 100) : 0
                    HStack {
                        Text("\(Int(actual)) / \(Int(goal))")
                          .font(.title3)
                        Spacer()
                        Text("\(pct)%")
                          .font(.title3)
                          .foregroundColor(Color.theme.blueYellow)
                    }
                    ProgressView(value: min(actual / max(goal, 1), 1.5))
                }


                Section(header: Text("Macros")) {
                    summaryRow("Fat",       actual: macros.fat,       goal: macros.fatGoal,         unit: "g")
                    summaryRow("Fiber",     actual: macros.fiber,     goal: macros.fiberMinimum,    unit: "g")
                    summaryRow("NetCarbs",  actual: macros.netCarbs,  goal: macros.netCarbsMaximum, unit: "g")
                    summaryRow("Protein",   actual: macros.protein,   goal: macros.proteinGoal,     unit: "g")
                }


                Section(header: Text("Body")) {
                    HStack { Text("Weight");      Spacer(); Text("\(profile.bodyMass.formattedString(1)) lb") }
                    HStack { Text("Body Fat");    Spacer(); Text("\(profile.bodyFatPercentage.formattedString(1)) %") }
                    HStack { Text("BMI");         Spacer(); Text(profile.bodyMassIndex.formattedString(1)) }
                    HStack { Text("Active Cal");  Spacer(); Text("\(Int(profile.activeCaloriesBurned))") }
                }


                Section(header: Text("Vitamins & Minerals")) {
                    let warnings = vitaminMineralWarnings()
                    if warnings.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(Color.theme.green)
                            Text("All within range")
                        }
                    } else {
                        ForEach(warnings, id: \.self) { line in
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.theme.red)
                                Text(line)
                            }
                        }
                    }
                }
            }
              .navigationTitle(todayString)
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .primaryAction) {
                      Button("Done") {
                          presentationMode.wrappedValue.dismiss()
                      }
                  }
              }
        }
    }


    @ViewBuilder
    private func summaryRow(_ label: String, actual: Double, goal: Double, unit: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(Int(actual)) / \(Int(goal)) \(unit)")
        }
    }


    // Returns one warning string per nutrient that is below min or
    // above a defined max.  Skips nutrients whose actual is 0 AND
    // whose min is 0 (i.e., not really tracked in the user's data).
    private func vitaminMineralWarnings() -> [String] {
        let actuals = computeVitaminMineralActuals(
            mealIngredients: mealIngredientMgr.mealIngredients,
            ingredientMgr: ingredientMgr
        )
        let age = profileMgr.profile.age
        let gender = profileMgr.profile.gender

        var warnings: [String] = []

        for type in vitaminMineralOrder {
            let vm = VitaminMineral(name: type, age: age, gender: gender)
            let actual = actuals[type] ?? 0
            let min = vm.min()
            let max = vm.max()

            if min > 0 && actual < min {
                warnings.append("\(type.formattedString()) below min (\(actual.formattedString(0)) / \(min.formattedString(0)))")
                continue
            }
            if max > 0 && actual > max {
                warnings.append("\(type.formattedString()) above max (\(actual.formattedString(0)) / \(max.formattedString(0)))")
            }
        }

        return warnings
    }
}
