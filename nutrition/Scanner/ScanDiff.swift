import Foundation

// ============================================================
// ScanDiff — what changes if we apply a `ParsedIngredient` to an
// existing `Ingredient`. Pure data; no UI, no I/O.
//
// We only diff fields the LLM actually filled in (non-nil on the
// parsed side). A nil parsed value means "not visible on the
// label", not "set to zero" — so we skip it.
// ============================================================
struct ScanDiff: Equatable {

    struct Change: Equatable, Identifiable {
        let id: String           // field name, used as Identifiable id
        let field: String        // human-readable label
        let oldValue: String
        let newValue: String
    }


    let changes: [Change]


    var isEmpty: Bool { changes.isEmpty }


    // ============================================================
    // Compute the diff between an existing ingredient and a parsed
    // result. Returns one Change per field that would actually
    // change value.
    //
    // Number comparisons use a small epsilon — the LLM round-trips
    // through JSON Doubles, so 0 vs 0.0000001 is noise.
    // ============================================================
    static func compute(existing: Ingredient, parsed: ParsedIngredient) -> ScanDiff {
        var out: [Change] = []

        // Identity / product details (strings)
        addStringChange(&out, field: "Name", id: "name",
                        old: existing.name, new: parsed.name)
        addOptStringChange(&out, field: "Brand", id: "brand",
                           old: existing.brand, new: parsed.brand)
        addOptStringChange(&out, field: "Full name", id: "fullName",
                           old: existing.fullName, new: parsed.fullName)
        addOptStringChange(&out, field: "URL", id: "url",
                           old: existing.url, new: parsed.url)
        addOptListChange(&out, field: "Ingredients", id: "ingredientsList",
                         old: existing.ingredients, new: parsed.ingredientsList)
        addOptListChange(&out, field: "Allergens", id: "allergens",
                         old: existing.allergens, new: parsed.allergens)

        // Serving / consumption
        addNumberChange(&out, field: "Serving size (g)", id: "servingSize",
                        old: existing.servingSize, new: parsed.servingSize)
        addNumberChange(&out, field: "Grams / unit", id: "consumptionGrams",
                        old: existing.consumptionGrams, new: parsed.consumptionGrams)
        if let unitString = parsed.consumptionUnit {
            let parsedUnit = parsed.consumptionUnitEnum
            if existing.consumptionUnit != parsedUnit {
                out.append(Change(
                    id: "consumptionUnit",
                    field: "Consumption unit",
                    oldValue: existing.consumptionUnit.singularForm,
                    newValue: parsedUnit.singularForm.isEmpty ? unitString : parsedUnit.singularForm
                ))
            }
        }

        // Pricing (verify-by-name flow). price → totalCost,
        // packageGrams → totalGrams.
        addNumberChange(&out, field: "Price ($)", id: "price",
                        old: existing.totalCost, new: parsed.price)
        addNumberChange(&out, field: "Package grams", id: "packageGrams",
                        old: existing.totalGrams, new: parsed.packageGrams)

        // Macros
        addNumberChange(&out, field: "Calories", id: "calories",
                        old: existing.calories, new: parsed.calories)
        addNumberChange(&out, field: "Fat", id: "fat",
                        old: existing.fat, new: parsed.fat)
        addNumberChange(&out, field: "Saturated fat", id: "saturatedFat",
                        old: existing.saturatedFat, new: parsed.saturatedFat)
        addNumberChange(&out, field: "Trans fat", id: "transFat",
                        old: existing.transFat, new: parsed.transFat)
        addNumberChange(&out, field: "Cholesterol", id: "cholesterol",
                        old: existing.cholesterol, new: parsed.cholesterol)
        addNumberChange(&out, field: "Sodium", id: "sodium",
                        old: existing.sodium, new: parsed.sodium)
        addNumberChange(&out, field: "Carbohydrates", id: "carbohydrates",
                        old: existing.carbohydrates, new: parsed.carbohydrates)
        addNumberChange(&out, field: "Fiber", id: "fiber",
                        old: existing.fiber, new: parsed.fiber)
        addNumberChange(&out, field: "Sugar", id: "sugar",
                        old: existing.sugar, new: parsed.sugar)
        addNumberChange(&out, field: "Added sugar", id: "addedSugar",
                        old: existing.addedSugar, new: parsed.addedSugar)
        addNumberChange(&out, field: "Net carbs", id: "netCarbs",
                        old: existing.netCarbs, new: parsed.netCarbs)
        addNumberChange(&out, field: "Protein", id: "protein",
                        old: existing.protein, new: parsed.protein)

        // V&M
        addNumberChange(&out, field: "Omega-3", id: "omega3",
                        old: existing.omega3, new: parsed.omega3)
        addNumberChange(&out, field: "Vitamin D", id: "vitaminD",
                        old: existing.vitaminD, new: parsed.vitaminD)
        addNumberChange(&out, field: "Calcium", id: "calcium",
                        old: existing.calcium, new: parsed.calcium)
        addNumberChange(&out, field: "Iron", id: "iron",
                        old: existing.iron, new: parsed.iron)
        addNumberChange(&out, field: "Potassium", id: "potassium",
                        old: existing.potassium, new: parsed.potassium)
        addNumberChange(&out, field: "Vitamin A", id: "vitaminA",
                        old: existing.vitaminA, new: parsed.vitaminA)
        addNumberChange(&out, field: "Vitamin C", id: "vitaminC",
                        old: existing.vitaminC, new: parsed.vitaminC)
        addNumberChange(&out, field: "Vitamin E", id: "vitaminE",
                        old: existing.vitaminE, new: parsed.vitaminE)
        addNumberChange(&out, field: "Vitamin K", id: "vitaminK",
                        old: existing.vitaminK, new: parsed.vitaminK)
        addNumberChange(&out, field: "Thiamin", id: "thiamin",
                        old: existing.thiamin, new: parsed.thiamin)
        addNumberChange(&out, field: "Riboflavin", id: "riboflavin",
                        old: existing.riboflavin, new: parsed.riboflavin)
        addNumberChange(&out, field: "Niacin", id: "niacin",
                        old: existing.niacin, new: parsed.niacin)
        addNumberChange(&out, field: "Vitamin B6", id: "vitaminB6",
                        old: existing.vitaminB6, new: parsed.vitaminB6)
        addNumberChange(&out, field: "Folate", id: "folate",
                        old: existing.folate, new: parsed.folate)
        addNumberChange(&out, field: "Vitamin B12", id: "vitaminB12",
                        old: existing.vitaminB12, new: parsed.vitaminB12)
        addNumberChange(&out, field: "Pantothenic acid", id: "pantothenicAcid",
                        old: existing.pantothenicAcid, new: parsed.pantothenicAcid)
        addNumberChange(&out, field: "Phosphorus", id: "phosphorus",
                        old: existing.phosphorus, new: parsed.phosphorus)
        addNumberChange(&out, field: "Magnesium", id: "magnesium",
                        old: existing.magnesium, new: parsed.magnesium)
        addNumberChange(&out, field: "Zinc", id: "zinc",
                        old: existing.zinc, new: parsed.zinc)
        addNumberChange(&out, field: "Selenium", id: "selenium",
                        old: existing.selenium, new: parsed.selenium)
        addNumberChange(&out, field: "Copper", id: "copper",
                        old: existing.copper, new: parsed.copper)
        addNumberChange(&out, field: "Manganese", id: "manganese",
                        old: existing.manganese, new: parsed.manganese)

        return ScanDiff(changes: out)
    }


    // ============================================================
    // Helpers — each appends 0 or 1 Change. nil parsed = skip.
    // ============================================================

    private static func addNumberChange(_ out: inout [Change],
                                        field: String, id: String,
                                        old: Double, new: Double?) {
        guard let newVal = new else { return }
        if abs(old - newVal) < 0.0001 { return }
        out.append(Change(
            id: id, field: field,
            oldValue: formatNumber(old),
            newValue: formatNumber(newVal)
        ))
    }


    private static func addStringChange(_ out: inout [Change],
                                        field: String, id: String,
                                        old: String, new: String) {
        if old == new { return }
        out.append(Change(id: id, field: field, oldValue: old, newValue: new))
    }


    private static func addOptStringChange(_ out: inout [Change],
                                           field: String, id: String,
                                           old: String, new: String?) {
        guard let newVal = new, !newVal.isEmpty else { return }
        if old == newVal { return }
        out.append(Change(id: id, field: field,
                          oldValue: old.isEmpty ? "—" : old,
                          newValue: newVal))
    }


    private static func addOptListChange(_ out: inout [Change],
                                         field: String, id: String,
                                         old: [String], new: [String]?) {
        guard let newVal = new, !newVal.isEmpty else { return }
        if old == newVal { return }
        out.append(Change(id: id, field: field,
                          oldValue: old.isEmpty ? "—" : old.joined(separator: ", "),
                          newValue: newVal.joined(separator: ", ")))
    }


    // ============================================================
    // Apply selected parsed fields back onto an Ingredient. `ids`
    // are Change.id values (e.g. "fat", "price", "brand"); only
    // those whose parsed value is non-nil are written. Centralizes
    // the id→field mapping so compute() and apply() stay in sync.
    // ============================================================
    static func apply(parsed p: ParsedIngredient,
                      ids: Set<String>,
                      to ing: inout Ingredient) {
        func num(_ id: String, _ v: Double?, _ set: (Double) -> Void) {
            guard ids.contains(id), let v = v else { return }
            set(v)
        }
        func str(_ id: String, _ v: String?, _ set: (String) -> Void) {
            guard ids.contains(id), let v = v, !v.isEmpty else { return }
            set(v)
        }
        func list(_ id: String, _ v: [String]?, _ set: ([String]) -> Void) {
            guard ids.contains(id), let v = v, !v.isEmpty else { return }
            set(v)
        }

        str("name", p.name)             { ing.name = $0 }
        str("brand", p.brand)           { ing.brand = $0 }
        str("fullName", p.fullName)     { ing.fullName = $0 }
        str("url", p.url)               { ing.url = $0 }
        list("ingredientsList", p.ingredientsList) { ing.ingredients = $0 }
        list("allergens", p.allergens)  { ing.allergens = $0 }

        num("price", p.price)                     { ing.totalCost = $0 }
        num("packageGrams", p.packageGrams)       { ing.totalGrams = $0 }
        num("servingSize", p.servingSize)         { ing.servingSize = $0 }
        num("consumptionGrams", p.consumptionGrams) { ing.consumptionGrams = $0 }
        if ids.contains("consumptionUnit"), p.consumptionUnit != nil {
            ing.consumptionUnit = p.consumptionUnitEnum
        }

        num("calories", p.calories)     { ing.calories = $0 }
        num("fat", p.fat)               { ing.fat = $0 }
        num("saturatedFat", p.saturatedFat)   { ing.saturatedFat = $0 }
        num("transFat", p.transFat)     { ing.transFat = $0 }
        num("cholesterol", p.cholesterol)     { ing.cholesterol = $0 }
        num("sodium", p.sodium)         { ing.sodium = $0 }
        num("carbohydrates", p.carbohydrates) { ing.carbohydrates = $0 }
        num("fiber", p.fiber)           { ing.fiber = $0 }
        num("sugar", p.sugar)           { ing.sugar = $0 }
        num("addedSugar", p.addedSugar) { ing.addedSugar = $0 }
        num("netCarbs", p.netCarbs)     { ing.netCarbs = $0 }
        num("protein", p.protein)       { ing.protein = $0 }

        num("omega3", p.omega3)         { ing.omega3 = $0 }
        num("vitaminD", p.vitaminD)     { ing.vitaminD = $0 }
        num("calcium", p.calcium)       { ing.calcium = $0 }
        num("iron", p.iron)             { ing.iron = $0 }
        num("potassium", p.potassium)   { ing.potassium = $0 }
        num("vitaminA", p.vitaminA)     { ing.vitaminA = $0 }
        num("vitaminC", p.vitaminC)     { ing.vitaminC = $0 }
        num("vitaminE", p.vitaminE)     { ing.vitaminE = $0 }
        num("vitaminK", p.vitaminK)     { ing.vitaminK = $0 }
        num("thiamin", p.thiamin)       { ing.thiamin = $0 }
        num("riboflavin", p.riboflavin) { ing.riboflavin = $0 }
        num("niacin", p.niacin)         { ing.niacin = $0 }
        num("vitaminB6", p.vitaminB6)   { ing.vitaminB6 = $0 }
        num("folate", p.folate)         { ing.folate = $0 }
        num("vitaminB12", p.vitaminB12) { ing.vitaminB12 = $0 }
        num("pantothenicAcid", p.pantothenicAcid) { ing.pantothenicAcid = $0 }
        num("phosphorus", p.phosphorus) { ing.phosphorus = $0 }
        num("magnesium", p.magnesium)   { ing.magnesium = $0 }
        num("zinc", p.zinc)             { ing.zinc = $0 }
        num("selenium", p.selenium)     { ing.selenium = $0 }
        num("copper", p.copper)         { ing.copper = $0 }
        num("manganese", p.manganese)   { ing.manganese = $0 }
    }


    // ============================================================
    // Today's date as a `verified` stamp. Matches the seed format
    // (e.g. "5/16/2026"): no leading zeros, en_US_POSIX so it's
    // locale-stable. One source of truth for the web-refresh flows.
    // ============================================================
    static func todayStamp() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "M/d/yyyy"
        return f.string(from: Date())
    }


    private static func formatNumber(_ value: Double) -> String {
        if value == value.rounded() {
            return String(Int(value))
        }
        // Trim trailing zeros for readability ("1.5" not "1.50000")
        let s = String(format: "%.4f", value)
        var trimmed = s
        while trimmed.hasSuffix("0") { trimmed.removeLast() }
        if trimmed.hasSuffix(".") { trimmed.removeLast() }
        return trimmed
    }
}
