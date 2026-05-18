import Foundation


// All vitamin/mineral types in a fixed display order.  Mirrors the
// order used by VitaminMineralMgr.getAll().
let vitaminMineralOrder: [VitaminMineralType] = [
    .calcium, .copper, .folate, .folicAcid, .iron, .magnesium,
    .manganese, .niacin, .pantothenicAcid, .phosphorus, .potassium,
    .riboflavin, .selenium, .thiamin, .vitaminA, .vitaminB12,
    .vitaminB6, .vitaminC, .vitaminD, .vitaminE, .vitaminK, .zinc
]


// Total each vitamin/mineral across all meal ingredients (a meal is
// exactly the rows present). Returns a dictionary keyed by
// VitaminMineralType.  Ingredients referenced by name but not found
// in the database are skipped (no crash).  Values are in the same
// units as the corresponding fields on Ingredient.
func computeVitaminMineralActuals(
    mealIngredients: [MealIngredient],
    ingredientMgr: IngredientMgr,
    foodMgr: FoodMgr
) -> [VitaminMineralType: Double] {

    var totals: [VitaminMineralType: Double] = [:]

    for mealIngredient in mealIngredients {
        // Category placeholders are not real foods — contribute no
        // vitamins/minerals.
        if mealIngredient.isFoodTypeSlot { continue }
        guard let ingredient = ingredientMgr.getByName(name: mealIngredient.name) else {
            continue
        }
        guard ingredient.servingSize > 0 else { continue }
        let servings = (mealIngredient.amount * foodMgr.consumptionGrams(for: ingredient)) / ingredient.servingSize

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
    ingredientMgr: IngredientMgr,
    foodMgr: FoodMgr
) -> [VitaminMineralContribution] {

    var contributions: [VitaminMineralContribution] = []

    for mealIngredient in mealIngredients {
        // Category placeholders are not real foods — no contribution.
        if mealIngredient.isFoodTypeSlot { continue }
        guard let ingredient = ingredientMgr.getByName(name: mealIngredient.name) else {
            continue
        }
        guard ingredient.servingSize > 0 else { continue }
        let servings = (mealIngredient.amount * foodMgr.consumptionGrams(for: ingredient)) / ingredient.servingSize
        let contribution = nutrientValue(of: ingredient, for: nutrient) * servings

        if contribution > 0 {
            contributions.append(VitaminMineralContribution(
                id: mealIngredient.id,
                ingredientName: mealIngredient.name,
                amount: mealIngredient.amount,
                consumptionUnit: foodMgr.consumptionUnit(for: ingredient),
                contribution: contribution
            ))
        }
    }

    return contributions.sorted { $0.contribution > $1.contribution }
}


// One row in the "all sources" table — every ingredient in the
// database that records a non-zero amount of this nutrient, ranked
// by per-gram density. Tells the user *what to eat more of* to hit
// the RDA when their current meal is short.
struct IngredientNutrientDensity: Identifiable {
    let id: String           // ingredient name (unique within db)
    let name: String
    let gramsForMin: Double  // grams of this ingredient to hit RDA min;
                             // 0 when min is undefined (use sentinel)
    let perHundredGrams: Double  // amount of nutrient per 100g
}


// All ingredients in the database that contribute to `nutrient`,
// sorted most → least dense (per-gram). `rdaMin` is used to compute
// "grams of X to reach minimum"; pass 0 when no min applies and the
// caller renders a "—" instead.
func allContributorsFor(
    nutrient: VitaminMineralType,
    rdaMin: Double,
    ingredientMgr: IngredientMgr
) -> [IngredientNutrientDensity] {

    var rows: [IngredientNutrientDensity] = []

    for ingredient in ingredientMgr.ingredients {
        guard ingredient.servingSize > 0 else { continue }
        let perServing = nutrientValue(of: ingredient, for: nutrient)
        guard perServing > 0 else { continue }

        let densityPerGram = perServing / ingredient.servingSize
        let gramsForMin = rdaMin > 0 ? rdaMin / densityPerGram : 0
        let per100g = densityPerGram * 100

        rows.append(IngredientNutrientDensity(
            id: ingredient.name,
            name: ingredient.name,
            gramsForMin: gramsForMin,
            perHundredGrams: per100g
        ))
    }

    // Descending by per-gram density — top of the list is the best
    // source per gram. Equivalent to ascending by gramsForMin.
    return rows.sorted { $0.perHundredGrams > $1.perHundredGrams }
}


// Pull a nutrient's raw per-serving value off an ingredient and
// return it in the unit reported by VitaminMineral.unit() — the same
// unit min()/max() use, so callers can compare freely.
//
// Two ingredient fields are stored in a different unit than what NIH
// reports the RDA/UL in, and both need converting here so the row's
// min ≤ actual ≤ max comparison is unit-consistent:
//   - copper:    Ingredient stores mg, NIH reports mcg → ×1000
//   - vitaminD:  Ingredient stores mcg, NIH reports IU → ×40
//                (1 mcg vitamin D = 40 IU)
// Internal (not file-private) so MealIngredientDetail can reuse the
// same mapping + unit conversions when showing per-ingredient
// contributions; otherwise the detail page double-shows raw mg/mcg
// for copper and raw mcg for vitamin D, breaking unit consistency.
func nutrientValue(of ingredient: Ingredient, for type: VitaminMineralType) -> Double {
    switch type {
    case .calcium:         return ingredient.calcium
    case .copper:          return ingredient.copper * 1000     // mg → mcg
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
    case .vitaminD:        return ingredient.vitaminD * 40     // mcg → IU
    case .vitaminE:        return ingredient.vitaminE
    case .vitaminK:        return ingredient.vitaminK
    case .zinc:            return ingredient.zinc
    }
}
