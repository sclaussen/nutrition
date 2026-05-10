import Foundation


// All vitamin/mineral types in a fixed display order.  Mirrors the
// order used by VitaminMineralMgr.getAll().
let vitaminMineralOrder: [VitaminMineralType] = [
    .calcium, .copper, .folate, .folicAcid, .iron, .magnesium,
    .manganese, .niacin, .pantothenicAcid, .phosphorus, .potassium,
    .riboflavin, .selenium, .thiamin, .vitaminA, .vitaminB12,
    .vitaminB6, .vitaminC, .vitaminD, .vitaminE, .vitaminK, .zinc
]


// Total each vitamin/mineral across all *active* meal ingredients.
// Returns a dictionary keyed by VitaminMineralType.  Inactive
// ingredients are skipped.  Ingredients referenced by name but not
// found in the database are skipped (no crash).  Values are in the
// same units as the corresponding fields on Ingredient.
func computeVitaminMineralActuals(
    mealIngredients: [MealIngredient],
    ingredientMgr: IngredientMgr
) -> [VitaminMineralType: Double] {

    var totals: [VitaminMineralType: Double] = [:]

    for mealIngredient in mealIngredients where mealIngredient.active {
        guard let ingredient = ingredientMgr.getByName(name: mealIngredient.name) else {
            continue
        }
        guard ingredient.servingSize > 0 else { continue }
        let servings = (mealIngredient.amount * ingredient.consumptionGrams) / ingredient.servingSize

        for type in vitaminMineralOrder {
            totals[type, default: 0] += nutrientValue(of: ingredient, for: type) * servings
        }
    }

    return totals
}


// One ingredient's contribution to a single vitamin/mineral, used by
// the per-nutrient drill-down view.
struct VitaminMineralContribution: Identifiable {
    let id: String
    let ingredientName: String
    let amount: Double
    let consumptionUnit: Unit
    let contribution: Double
}


// Per-ingredient contributions to a single nutrient, sorted
// descending by contribution.  Ingredients that contribute zero
// (because the nutrient isn't recorded for them) are omitted.
func contributorsTo(
    nutrient: VitaminMineralType,
    mealIngredients: [MealIngredient],
    ingredientMgr: IngredientMgr
) -> [VitaminMineralContribution] {

    var contributions: [VitaminMineralContribution] = []

    for mealIngredient in mealIngredients where mealIngredient.active {
        guard let ingredient = ingredientMgr.getByName(name: mealIngredient.name) else {
            continue
        }
        guard ingredient.servingSize > 0 else { continue }
        let servings = (mealIngredient.amount * ingredient.consumptionGrams) / ingredient.servingSize
        let contribution = nutrientValue(of: ingredient, for: nutrient) * servings

        if contribution > 0 {
            contributions.append(VitaminMineralContribution(
                id: mealIngredient.id,
                ingredientName: mealIngredient.name,
                amount: mealIngredient.amount,
                consumptionUnit: ingredient.consumptionUnit,
                contribution: contribution
            ))
        }
    }

    return contributions.sorted { $0.contribution > $1.contribution }
}


// Pull a nutrient's raw per-serving value off an ingredient.  This
// is the single mapping point between VitaminMineralType and the
// individual fields on Ingredient.
private func nutrientValue(of ingredient: Ingredient, for type: VitaminMineralType) -> Double {
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
