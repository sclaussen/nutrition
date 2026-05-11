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
        let goal = profile.caloriesGoal
        let actual = macros.calories
        let pct = goal > 0 ? Int((actual / goal) * 100) : 0

        NavigationView {
            VStack(alignment: .leading, spacing: 10) {

                // Calories
                VStack(alignment: .leading, spacing: 3) {
                    sectionLabel("CALORIES")
                    HStack {
                        Text("\(Int(actual)) / \(Int(goal))").font(.title3)
                        Spacer()
                        Text("\(pct)%").font(.title3).foregroundColor(Color.theme.blueYellow)
                    }
                    ProgressView(value: min(actual / max(goal, 1), 1.5))
                }

                // Macros (2x2)
                VStack(alignment: .leading, spacing: 3) {
                    sectionLabel("MACROS")
                    HStack(spacing: 8) {
                        valueCell("Fat",       "\(Int(macros.fat)) / \(Int(macros.fatGoal)) g")
                        valueCell("Fiber",     "\(Int(macros.fiber)) / \(Int(macros.fiberMinimum)) g")
                    }
                    HStack(spacing: 8) {
                        valueCell("NetCarbs",  "\(Int(macros.netCarbs)) / \(Int(macros.netCarbsMaximum)) g")
                        valueCell("Protein",   "\(Int(macros.protein)) / \(Int(macros.proteinGoal)) g")
                    }
                }

                // Body (2x2)
                VStack(alignment: .leading, spacing: 3) {
                    sectionLabel("BODY")
                    HStack(spacing: 8) {
                        valueCell("Weight",     "\(profile.bodyMass.formattedString(1)) lb")
                        valueCell("Body Fat",   "\(profile.bodyFatPercentage.formattedString(1)) %")
                    }
                    HStack(spacing: 8) {
                        valueCell("BMI",        profile.bodyMassIndex.formattedString(1))
                        valueCell("Active Cal", "\(Int(profile.activeCaloriesBurned))")
                    }
                }

                // V&M — only out-of-range
                VStack(alignment: .leading, spacing: 3) {
                    sectionLabel("VITAMINS & MINERALS")
                    let warnings = vitaminMineralWarnings()
                    if warnings.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                              .foregroundColor(Color.theme.green)
                              .font(.caption)
                            Text("All within range").font(.caption)
                        }
                    } else {
                        ForEach(warnings, id: \.name) { w in
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                  .foregroundColor(Color.theme.red)
                                  .font(.caption2)
                                Text(w.name).font(.caption)
                                Text(w.direction)
                                  .font(.caption2)
                                  .foregroundColor(Color.theme.blackWhiteSecondary)
                                Spacer()
                                Text(w.values)
                                  .font(.caption2)
                                  .foregroundColor(Color.theme.blackWhiteSecondary)
                            }
                        }
                    }
                }

                Spacer(minLength: 0)
            }
              .padding(.horizontal, 16)
              .padding(.top, 8)
              .padding(.bottom, 8)
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
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
          .font(.caption2)
          .foregroundColor(Color.theme.blackWhiteSecondary)
          .padding(.top, 2)
    }


    @ViewBuilder
    private func valueCell(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.caption)
            Spacer()
            Text(value).font(.callout)
        }
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(Color.theme.blackWhite.opacity(0.04))
          .cornerRadius(6)
          .frame(maxWidth: .infinity)
    }


    private struct VMWarning {
        let name: String      // e.g., "Calcium"
        let direction: String // "below min" or "above max"
        let values: String    // "150 / 1,000"
    }


    // Returns one warning entry per nutrient that's below min or
    // above a defined max.  Nutrients with no min and no max are
    // skipped.  Used by the V&M section above.
    private func vitaminMineralWarnings() -> [VMWarning] {
        let actuals = computeVitaminMineralActuals(
            mealIngredients: mealIngredientMgr.mealIngredients,
            ingredientMgr: ingredientMgr
        )
        let age = profileMgr.profile.age
        let gender = profileMgr.profile.gender

        var warnings: [VMWarning] = []

        for type in vitaminMineralOrder {
            let vm = VitaminMineral(name: type, age: age, gender: gender)
            let actual = actuals[type] ?? 0
            let min = vm.min()
            let max = vm.max()
            let label = type.formattedString()

            if min > 0 && actual < min {
                warnings.append(VMWarning(
                    name: label,
                    direction: "below min",
                    values: "\(actual.formattedString(0)) / \(min.formattedString(0))"
                ))
                continue
            }
            if max > 0 && actual > max {
                warnings.append(VMWarning(
                    name: label,
                    direction: "above max",
                    values: "\(actual.formattedString(0)) / \(max.formattedString(0))"
                ))
            }
        }

        return warnings
    }
}
