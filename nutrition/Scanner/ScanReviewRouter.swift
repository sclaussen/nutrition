import Foundation

// ============================================================
// ScanReviewRouter — pure routing decision after a scan.
// Given a parsed result and the current ingredient list, decide
// where the user should land next: a new-ingredient form, an
// existing-ingredient editor with a diff, or a chooser sheet to
// disambiguate.
//
// "Pure" means: no I/O, no SwiftUI state — easy to reason about
// and to swap in future tests.
// ============================================================
enum ScanRoute {
    case new(ParsedIngredient)
    case update(existing: Ingredient, parsed: ParsedIngredient, diff: ScanDiff)

    // The LLM proposed a name we don't recognize and gave 2+ guesses.
    // We let the user choose between "create new" or any of the
    // matched candidates the app could resolve.
    case chooser(parsed: ParsedIngredient, candidates: [Ingredient])
}


enum ScanReviewRouter {

    static func route(parsed: ParsedIngredient,
                      allIngredients: [Ingredient]) -> ScanRoute {
        switch parsed.match {

        case .new:
            return .new(parsed)

        case .update(let name):
            // Defensive lookup — the LLM might hallucinate a name
            // that's not actually in our list. If the name doesn't
            // resolve, fall back to creating a new ingredient.
            if let existing = lookup(name, in: allIngredients) {
                let diff = ScanDiff.compute(existing: existing, parsed: parsed)
                return .update(existing: existing, parsed: parsed, diff: diff)
            }
            return .new(parsed)

        case .ambiguous(let names):
            // Resolve each candidate name; drop any we can't find.
            let resolved = names.compactMap { lookup($0, in: allIngredients) }

            // If nothing resolved, just treat as new.
            if resolved.isEmpty {
                return .new(parsed)
            }
            // If exactly one resolved, skip the chooser.
            if resolved.count == 1 {
                let existing = resolved[0]
                let diff = ScanDiff.compute(existing: existing, parsed: parsed)
                return .update(existing: existing, parsed: parsed, diff: diff)
            }
            return .chooser(parsed: parsed, candidates: resolved)
        }
    }


    // Case-insensitive, whitespace-trimmed name lookup. The LLM
    // might write "chicken " (trailing space) or "Chicken" when the
    // stored name is "chicken" — we don't want capitalization /
    // padding to break the match.
    private static func lookup(_ name: String, in all: [Ingredient]) -> Ingredient? {
        let target = name.trimmingCharacters(in: .whitespaces).lowercased()
        return all.first { $0.name.trimmingCharacters(in: .whitespaces).lowercased() == target }
    }
}
