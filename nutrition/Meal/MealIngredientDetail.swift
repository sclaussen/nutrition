import SwiftUI


// Read-only detail view for a single meal ingredient.  Shows the
// per-ingredient macro contribution and the per-ingredient
// vitamin/mineral contribution with % of RDA.  Replaces the
// previous MealEdit page (which only allowed amount editing,
// now handled by the in-line stepper + NumberEntrySheet on
// MealList).
struct MealIngredientDetail: View {

    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    let mealIngredient: MealIngredient


    var body: some View {
        let ingredient = ingredientMgr.getByName(name: mealIngredient.name)

        List {

            Section(header: Text("Amount")) {
                HStack {
                    Text(mealIngredient.name)
                    Spacer()
                    Text("\(mealIngredient.amount.formattedString(1)) \(ingredient?.consumptionUnit.pluralForm ?? "")")
                }
            }


            Section(header: Text("Macros contributed")) {
                macroRow("Calories", mealIngredient.calories, unit: "")
                macroRow("Fat",      mealIngredient.fat,      unit: "g")
                macroRow("Fiber",    mealIngredient.fiber,    unit: "g")
                macroRow("NetCarbs", mealIngredient.netcarbs, unit: "g")
                macroRow("Protein",  mealIngredient.protein,  unit: "g")
            }


            Section(header: Text("Vitamins & Minerals contributed")) {
                if let ing = ingredient {
                    let entries = vitaminMineralEntries(for: ing)
                    if entries.isEmpty {
                        Text("None recorded.")
                          .font(.callout)
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    } else {
                        ForEach(entries, id: \.name) { e in
                            HStack {
                                Text(e.name.formattedString())
                                  .font(.callout)
                                Spacer()
                                Text("\(e.value.formattedString(1))")
                                  .font(.caption)
                                Text(e.unitLabel)
                                  .font(.caption2)
                                  .foregroundColor(Color.theme.blackWhiteSecondary)
                                  .frame(width: 40, alignment: .leading)
                                Text(e.percentLabel)
                                  .font(.caption2)
                                  .foregroundColor(Color.theme.blackWhiteSecondary)
                                  .frame(width: 70, alignment: .trailing)
                            }
                        }
                    }
                } else {
                    Text("Ingredient not found.")
                      .font(.callout)
                      .foregroundColor(Color.theme.red)
                }
            }
        }
          .navigationTitle(mealIngredient.name)
          .navigationBarTitleDisplayMode(.inline)
    }


    @ViewBuilder
    private func macroRow(_ label: String, _ value: Double, unit: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(unit.isEmpty ? "\(Int(value))" : "\(value.formattedString(1)) \(unit)")
        }
    }


    private struct VMEntry {
        let name: VitaminMineralType
        let value: Double
        let unitLabel: String      // "mg" / "mcg" / "IU"
        let percentLabel: String   // "5 % of min" or "<1 %" or ""
    }


    // Compute this single meal-ingredient's contribution to each
    // vitamin/mineral.  Returns only entries with a non-zero
    // contribution, in `vitaminMineralOrder`.
    private func vitaminMineralEntries(for ingredient: Ingredient) -> [VMEntry] {
        let servings = ingredient.servingSize > 0
            ? (mealIngredient.amount * ingredient.consumptionGrams) / ingredient.servingSize
            : 0
        if servings == 0 { return [] }

        let age = profileMgr.profile.age
        let gender = profileMgr.profile.gender

        var entries: [VMEntry] = []

        for type in vitaminMineralOrder {
            let raw = rawValue(of: ingredient, for: type)
            let contribution = raw * servings
            if contribution <= 0 { continue }

            let vm = VitaminMineral(name: type, age: age, gender: gender)
            let min = vm.min()
            let percent: String
            if min > 0 {
                let pct = (contribution / min) * 100
                if pct >= 1 {
                    percent = "\(Int(pct)) % of min"
                } else {
                    percent = "<1 %"
                }
            } else {
                percent = ""
            }

            entries.append(VMEntry(
                name: type,
                value: contribution,
                unitLabel: unitLabel(for: type),
                percentLabel: percent
            ))
        }

        return entries
    }


    private func rawValue(of ingredient: Ingredient, for type: VitaminMineralType) -> Double {
        switch type {
        case .calcium:         return ingredient.calcium
        case .copper:          return ingredient.copper
        case .folate:          return ingredient.folate
        case .folicAcid:       return ingredient.folicAcid
        case .iron:            return ingredient.iron
        case .magnesium:       return ingredient.magnesium
        case .manganese:       return ingredient.manganese
        case .niacin:          return ingredient.niacin
        case .pantothenicAcid: return ingredient.pantothenicAcid
        case .phosphorus:      return ingredient.phosphorus
        case .potassium:       return ingredient.potassium
        case .riboflavin:      return ingredient.riboflavin
        case .selenium:        return ingredient.selenium
        case .thiamin:         return ingredient.thiamin
        case .vitaminA:        return ingredient.vitaminA
        case .vitaminB12:      return ingredient.vitaminB12
        case .vitaminB6:       return ingredient.vitaminB6
        case .vitaminC:        return ingredient.vitaminC
        case .vitaminD:        return ingredient.vitaminD
        case .vitaminE:        return ingredient.vitaminE
        case .vitaminK:        return ingredient.vitaminK
        case .zinc:            return ingredient.zinc
        }
    }


    // Display unit for each nutrient (matches the NIH factsheet units
    // also documented inline in VitaminMineral.swift).
    private func unitLabel(for type: VitaminMineralType) -> String {
        switch type {
        case .calcium, .iron, .magnesium, .manganese, .niacin,
             .pantothenicAcid, .phosphorus, .potassium, .riboflavin,
             .thiamin, .vitaminB6, .vitaminC, .vitaminE, .zinc:
            return "mg"
        case .copper, .folate, .folicAcid, .selenium, .vitaminA,
             .vitaminB12, .vitaminK:
            return "mcg"
        case .vitaminD:
            return "IU"
        }
    }
}
