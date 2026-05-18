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
    @EnvironmentObject var foodMgr: FoodMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    let mealIngredient: MealIngredient


    // Every meal row is a Food; resolve to that Food's current
    // ingredient (global selection), else any surviving member.
    private func resolvedIngredient() -> Ingredient? {
        if let f = foodMgr.getByName(name: mealIngredient.name),
           let i = ingredientMgr.getByName(name: f.currentIngredientName) {
            return i
        }
        if let i = ingredientMgr.getByName(name: mealIngredient.name) {
            return i
        }
        return ingredientMgr.getAll().first { $0.foodName == mealIngredient.name }
    }

    var body: some View {
        let ingredient = resolvedIngredient()

        List {

            Section(header: Text("Amount & Cost")) {
                HStack {
                    Text(mealIngredient.name)
                    Spacer()
                    Text("\(mealIngredient.amount.formattedString(1)) \(ingredient.map { foodMgr.consumptionUnit(for: $0).pluralForm } ?? "")")
                }
                if let ing = ingredient {
                    // servings = amount in grams ÷ serving size;
                    // costs derive from the resolved ingredient.
                    let grams = mealIngredient.amount * foodMgr.consumptionGrams(for: ing)
                    let servings = ing.servingSize > 0 ? grams / ing.servingSize : 0
                    let hasCost = ing.effectiveTotalGrams > 0
                    let costPerGram = hasCost ? ing.totalCost / ing.effectiveTotalGrams : 0
                    let costPerServing = costPerGram * ing.servingSize
                    let contributed = costPerGram * grams
                    HStack {
                        Text("Serving size")
                        Spacer()
                        Text("\(ing.servingSize.formattedString(1)) g")
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    }
                    if hasCost {
                        HStack {
                            Text("Cost per serving")
                            Spacer()
                            Text(String(format: "$%.2f", costPerServing))
                              .foregroundColor(Color.theme.blackWhiteSecondary)
                        }
                    }
                    HStack {
                        Text("Servings")
                        Spacer()
                        Text(servings.formattedString(2))
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    }
                    if hasCost {
                        HStack {
                            Text("Serving cost")
                            Spacer()
                            Text(String(format: "$%.2f", contributed))
                              .foregroundColor(Color.theme.blueYellow)
                        }
                    }
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
            ? (mealIngredient.amount * foodMgr.consumptionGrams(for: ingredient)) / ingredient.servingSize
            : 0
        if servings == 0 { return [] }

        let age = profileMgr.profile.age
        let gender = profileMgr.profile.gender

        var entries: [VMEntry] = []

        for type in vitaminMineralOrder {
            // Use the shared mapping from VitaminMineralActuals so the
            // unit conversions (copper mg→mcg ×1000, vitamin D mcg→IU
            // ×40) are applied — otherwise the detail page reports raw
            // ingredient values that don't match the unit label below.
            let perServing = nutrientValue(of: ingredient, for: type)
            let contribution = perServing * servings
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
