# Meal-View Enhancements + Vitamin/Mineral Summary

**Date:** 2026-05-09
**Status:** Approved (pending user spec review)
**Scope:** Three focused UI features on the iOS nutrition app. Photo-to-LLM ingredient capture is deferred to its own spec.

## Overview

Three independent features that share one piece of new infrastructure
(cumulative vitamin/mineral computation):

1. **Hide-macros toggle** — let the user collapse the noisy
   cal/fat/fiber/netCarbs/protein columns on the Meal page.
2. **Vitamin & Mineral summary** — a primary cumulative view (Name,
   Min, Max, Actual) and an advanced per-ingredient drill-down.
3. **Daily summary screenshot view** — a clean, screenshot-friendly
   modal showing the day's macros, body metrics, and V&M status.

All three features share `VitaminMineralActuals`, a small computation
helper that totals vitamins and minerals across active meal
ingredients.

## Feature 1 — Hide-Macros Toggle

### Goal

The per-row macro columns on the Meal page (cal/fat/fiber/netCarbs/
protein) are visually noisy. Hide them by default; let the user reveal
them on demand.

### User Experience

- **Default:** macro columns hidden on the Meal page.
- **Toggle:** a "View options" menu in the toolbar contains a
  "Show macros" checkmark item. Selecting it toggles the columns.
- **Persistence:** the chosen state survives app launches.
- **Scope:** only the Meal page is affected. The Ingredients page
  continues to show macros (it's the database, not the dashboard).
- **Dashboard:** the totals at the top of the Meal page still show
  always — only the per-row columns are hidden.

### Implementation

- `MealList.swift`:
  - Replace the standalone `showInactive` toolbar button with a
    `Menu` containing two `Toggle`-style items:
    - "Show inactive" (binds to existing `@State showInactive`)
    - "Show macros" (binds to new `@AppStorage("showMacros")`)
  - The Menu's icon is `slider.horizontal.3` (a settings glyph).
  - Pass `showMacros` (instead of the literal `true`) into both
    `IngredientRowHeader(showMacros: showMacros)` and
    `IngredientRow(showMacros: showMacros, ...)` for every meal row.

`@AppStorage` provides automatic UserDefaults persistence with the key
`showMacros`. Default value `false`. The view re-renders on toggle.

### Out of scope

- A separate toggle for the Ingredients page (`IngredientList.swift`).
  Mention this if requested later, but the user has explicitly
  scoped this to the Meal page.
- Animating the column collapse. SwiftUI's default transitions
  suffice.

## Feature 2 — Vitamin & Mineral Summary

### Goal

Replace the current Vitamins-and-Minerals reference table (which only
shows the user's RDA min/max) with a useful daily-progress view: see
how much of each nutrient the active meal actually delivers, against
the user's age/gender RDA range.

### Primary view (cumulative)

A list with a header row plus one row per nutrient:

```
Name           Min      Max      Actual
Vitamin A      900     3000      420   ████████░░░
Vitamin C       90     2000      180   ██████████  (in range)
Vitamin D      600        —       50   █░░░░░░░░░  (below min)
Calcium       1000     2000      850   █████████░  (below min)
...
```

- **Min/Max** — pulled from the existing per-age/gender getters in
  `VitaminMineral.swift`. No changes to that file's RDA logic.
- **Actual** — computed live from the active meal ingredients (see
  Computation below). Displayed alongside a small bar/indicator
  whose fill shows position within `[min, max]`.
- **Color rules:**
  - Below min → red text + bar at far left.
  - Between min and max → green text + bar position scaled.
  - Above max → red text + bar overflowing right.
  - When max is undefined (e.g., `pantothenicAcidMax` returns 0),
    only "below min / met" semantics apply, no upper bound shown.
- **Sort order:** keeps the existing alphabetic-ish creation order in
  `VitaminMineralMgr.getAll`.

### Advanced view (per-ingredient drill-down)

Tap a row in the primary view → push a navigation destination
titled with the nutrient name and the word "Contributors"
(e.g., "Vitamin C Contributors", "Calcium Contributors") that shows:

```
Strawberries (140 g)        82 mg     (46 %)
Romaine     (175 g)         24 mg     (13 %)
Avocado     (220 g)         22 mg     (12 %)
...
Total                      178 mg     of 90 min / 2000 max
```

- Each row: ingredient name + amount + that ingredient's
  contribution (mg/mcg) and percentage of the total actual.
- Sorted descending by contribution.
- Footer: total + RDA min/max for context.

### Access

- **Primary entry point:** new toolbar button on the Meal page.
  Icon: `pills`. Implemented as a `NavigationLink` push, matching
  the existing pattern used by Add/Configure.
- **Secondary entry point:** the existing `Profile → Derived Profile
  Data → Vitamins and Minerals` `NavigationLink` is updated to push
  the new cumulative view (currently it pushes the RDA-only view).
  Both entry points land on the same screen.

### Computation: `VitaminMineralActuals`

A small free-standing helper (struct or function), used by both the
cumulative view and the daily-summary view. Pure function — no
@Published state, no persistence, recomputed on view appearance.

```swift
// Inputs: active meal ingredients, the ingredient database,
//         user profile (for age/gender, used by min/max getters).
// Output: dictionary keyed by VitaminMineralType with totals
//         denominated in the same units as the ingredient fields.
func computeVitaminMineralActuals(
    mealIngredients: [MealIngredient],
    ingredientMgr: IngredientMgr
) -> [VitaminMineralType: Double] {

    var totals: [VitaminMineralType: Double] = [:]

    for mi in mealIngredients where mi.active {
        guard let ing = ingredientMgr.getByName(name: mi.name) else { continue }
        let servings = (mi.amount * ing.consumptionGrams) / ing.servingSize

        totals[.vitaminA,    default: 0] += ing.vitaminA    * servings
        totals[.vitaminC,    default: 0] += ing.vitaminC    * servings
        totals[.vitaminD,    default: 0] += ing.vitaminD    * servings
        // ... all 22 vitamins/minerals
    }

    return totals
}
```

For the advanced view, a similar function returns per-ingredient
contributions for a single nutrient:

```swift
func contributorsTo(
    nutrient: VitaminMineralType,
    mealIngredients: [MealIngredient],
    ingredientMgr: IngredientMgr
) -> [(name: String, amount: Double, contribution: Double)]
```

Both functions live in a new file: `VitaminMinerals/VitaminMineralActuals.swift`.

### Implementation summary

- New file `VitaminMinerals/VitaminMineralActuals.swift` — pure
  computation helpers.
- Update `VitaminMineralRow.swift` (existing) to render an `Actual`
  column with bar + color coding.
- Update `VitaminMineralList.swift` to:
  - Take `mealIngredients` and `ingredientMgr` via
    `@EnvironmentObject`.
  - Compute totals via `computeVitaminMineralActuals`.
  - Wrap each row in a `NavigationLink` to a new
    `VitaminMineralContributors` view.
- New file `VitaminMinerals/VitaminMineralContributors.swift` — the
  per-ingredient drill-down.
- `MealList.swift` — add toolbar button (icon `pills`) opening
  `VitaminMineralList` via `NavigationLink`.

### Out of scope

- Editing the RDA tables.
- Tracking actuals over time / history.
- Adding new vitamin/mineral types not already in
  `VitaminMineralType`.

## Feature 3 — Daily Summary Screenshot View

### Goal

A single, screenshot-friendly view that captures the day at a glance:
macros, body metrics, calorie progress, and V&M status. Triggered
discoverably but unobtrusively.

### Trigger

**Long-press on the Dashboard component** at the top of the Meal
page. Long-press is unused in the current Dashboard, so it's a clean
gesture.

### Layout

Presented as a SwiftUI `.sheet`. The user takes a normal iOS
screenshot — no custom share UI, no save-to-photos button. The sheet
has a "Done" or "X" button to dismiss.

```
┌─────────────────────────────────┐
│  Today    May 9, 2026           │
│                                 │
│  Calories                       │
│   1450 / 2000  (72 %)           │
│   ████████░░░░░░                │
│                                 │
│  Macros                         │
│   Fat        110 g / 130 g      │
│   Fiber       25 g / 28 g       │
│   NetCarbs    15 g / 20 g       │
│   Protein    140 g / 150 g      │
│                                 │
│  Body                           │
│   Weight     184 lb             │
│   Body Fat    20 %              │
│   BMI         24.9              │
│   Active Cal  600               │
│                                 │
│  Vitamins & Minerals            │
│   ⚠ Vitamin D   below min       │
│   ⚠ Calcium     below min       │
│   ✓ All other 20 within range   │
└─────────────────────────────────┘
```

- **Date:** today's date, e.g., `May 9, 2026`.
- **Calories block:** total goal, total actual, % of goal, and a bar.
  Sourced from `MacrosMgr` + `ProfileMgr`.
- **Macros block:** Fat, Fiber, NetCarbs, Protein with actuals over
  goals (same data as Dashboard, formatted for readability).
- **Body block:** Weight (`profile.bodyMass`), Body Fat %
  (`profile.bodyFatPercentage`), BMI (`profile.bodyMassIndex`),
  Active Calories (`profile.activeCaloriesBurned`).
- **V&M block:** uses the same `computeVitaminMineralActuals`
  function. Lists nutrients that are below min or above max with a
  ⚠ icon. (If a nutrient has no defined max, "above max" is not
  evaluated for it.) If none are out of range, shows ✓ "All within
  range." Compact — does not list every nutrient.

### Implementation

- New file `Meal/DailySummary.swift` — a `View` with an explicit
  layout matching the spec above.
- `Dashboard.swift` (existing) — add `.onLongPressGesture` that sets
  a `@Binding showSummary: Bool`.
- `MealList.swift` — declare `@State private var showSummary = false`;
  pass binding to `Dashboard`; present `DailySummary` via
  `.sheet(isPresented: $showSummary)`.
- The summary view shares all data via existing `@EnvironmentObject`s
  (`profileMgr`, `macrosMgr`, `mealIngredientMgr`, `ingredientMgr`).

### Out of scope

- A "save image" or "share to social" button. iOS screenshot is
  enough.
- Historical day-over-day trends. Today only.

## Shared Infrastructure

`VitaminMineralActuals.swift` is the only piece of new shared logic.
Both Feature 2 and Feature 3 call into it. Pure function, no state.

## File Changes Summary

**New files:**
- `nutrition/VitaminMinerals/VitaminMineralActuals.swift`
- `nutrition/VitaminMinerals/VitaminMineralContributors.swift`
- `nutrition/Meal/DailySummary.swift`

**Modified files:**
- `nutrition/Meal/MealList.swift` — view-options menu, V&M toolbar
  button, summary sheet binding.
- `nutrition/Meal/Dashboard.swift` — long-press gesture binding.
- `nutrition/VitaminMinerals/VitaminMineralList.swift` — add Actual
  column, drill-down navigation, accept env objects.
- `nutrition/Components/VitaminMineralRow.swift` — render Actual
  column with color/bar.

**Unchanged but worth noting:**
- `VitaminMineral.swift` (the RDA tables) — no changes needed.
- `IngredientList.swift` — macro toggle does not affect this page.

## Testing

The repo has no automated test framework. Manual verification:

1. **Macro toggle:**
   - Launch app, confirm Meal-page rows have no macro columns.
   - Open view-options menu, toggle "Show macros" on; columns appear.
   - Force-quit, relaunch; columns still showing (state persisted).
   - Toggle off; force-quit, relaunch; columns hidden.

2. **V&M cumulative view:**
   - Open via Meal toolbar button. Confirm 4 columns.
   - Manually scale a meal ingredient; reopen; Actual updates.
   - Tap a row → drill-down lists ingredients.
   - Open via Profile → Vitamins and Minerals; same view appears.

3. **Daily summary:**
   - Long-press the Dashboard. Sheet appears.
   - Confirm date, calorie bar, macros, body metrics, V&M warnings.
   - Take a screenshot; layout reads cleanly.
   - Dismiss via Done/X.

## Risks & Open Questions

- **Toolbar density:** the Meal toolbar will have 4 buttons (view-
  options menu, reset, V&M, gear) plus EditButton on the left and
  Add on the right. Tight but should fit on iPhone widths used in
  the existing app. If it's too cramped, the V&M button could move
  into the view-options menu as a navigation row.
- **Dashboard long-press discoverability:** users won't know the
  gesture exists. Acceptable for a personal app, but worth a
  one-time onboarding hint if this gets shared.
- **V&M color contrast:** must look correct in both light and dark
  modes. Reuse `Color.theme` palette where possible.

## Out of Scope (Deferred)

- **Photo → LLM ingredient capture.** Will be designed in a separate
  spec — touches camera permissions, API integration, key storage,
  preview/edit flow, and error handling, all of which deserve their
  own brainstorm.
