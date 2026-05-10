# Stepper Rows + Prep Tab + Meal-Ingredient Detail

**Date:** 2026-05-10
**Status:** Approved (pending user spec review)
**Scope:** Three interrelated UI changes on the iOS nutrition app. Photo-to-LLM ingredient capture remains deferred to its own spec.

## Overview

Three changes that touch the Meal page and the tab bar:

1. **Tab restructuring** — fold the Adjustments tab into a renamed
   "Prep" tab (formerly "Ingredients"), reachable from a top toolbar
   button. Tab bar goes 4 → 3 entries.
2. **Stepper rows on the Meal page** — replace the existing
   row-wide `NavigationLink → MealEdit` with an inline control:
   `(−)  pill  (+)  ›`. Decrement/increment by a per-ingredient
   step amount; pill opens a popover number-entry; `›` opens a new
   read-only detail page.
3. **MealIngredientDetail view** — replaces `MealEdit`. Shows the
   per-meal-ingredient macro contribution and the per-meal-ingredient
   vitamin/mineral contribution with % of RDA.

All three share a new `effectiveStep(for: ingredient)` helper plus a
`stepAmount: Double` field on `Ingredient` (default 0 = "use
heuristic"), editable from the Prep page's per-ingredient edit form.

## Feature 1 — Tab Restructuring

### Goal

Free a slot in the tab bar by consolidating Adjustments into the
ingredients-database tab, and rename the tab to better reflect what
it is.

### User Experience

- Tab bar items go from `Meal | Adjustments | Ingredients | Profile`
  to `Meal | Prep | Profile`. The Ingredients tab is renamed to
  **Prep**; its icon remains `cart.fill`.
- A new toolbar button on the Prep page (icon
  `slider.horizontal.below.list.bulleted`) pushes the existing
  `AdjustmentList` view via `NavigationLink`. AdjustmentList itself
  is unchanged.
- Within `AdjustmentList`, the existing toolbar items (EditButton,
  Add, etc.) continue to work — they live on the pushed view.

### Implementation

- `nutrition/Tabs.swift`:
  - Remove the `Adjustments` `NavigationView { AdjustmentList() }`
    block.
  - Change the `Ingredients` block's `Text("Ingredients")` to
    `Text("Prep")` and keep the `cart.fill` `Image`.
- `nutrition/Ingredients/IngredientList.swift`:
  - In the existing `.toolbar { ... }` modifier, the principal
    placement currently holds a single `Button` (the show-unavailable
    eye icon). Wrap it in an `HStack` and add a `NavigationLink` to
    `AdjustmentList()` with `Image(systemName:
    "slider.horizontal.below.list.bulleted")` styled with
    `Color.theme.blueYellow` and `.frame(width: 40)` to match the
    Meal toolbar pattern from earlier work.

### Out of scope

- Changes to AdjustmentList itself, AdjustmentAdd, or AdjustmentEdit.
- Removing the persistence-via-tab-state for Adjustments — there's
  none today; `AdjustmentMgr` is already shared via `@EnvironmentObject`.

## Feature 2 — Stepper Rows on the Meal Page

### Goal

Faster amount adjustments without a full navigation away from the
Meal list, plus a clear path to the per-ingredient detail view.

### Layout

Each meal-ingredient row in `MealList.swift` becomes:

```
Coconut Oil               (−)   0.5 tbsps    (+)   ›
Eggs                      (−)   5 eggs        (+)  ›
Broccoli                  (−)   150 grams     (+)  ›
Mushrooms                 (−)   125 grams     (+)  ›
Macadamia Nuts            (−)   30 grams      (+)  ›
```

When `showMacros` is on (Task 2 from yesterday's work), the macro
columns appear between the name and the stepper:

```
Coconut Oil   65 cal  7 0 0 0     (−)   0.5 tbsps   (+)   ›
```

- **`(−)`** uses SF Symbol `minus.circle`; **`(+)`** uses
  `plus.circle`. Color: `Color.theme.blueYellow` (matches other
  interactive icons).
- The **pill** is a `Capsule()` shape with a thin stroke and the
  current amount + unit inside. Tappable. Min width sized to fit the
  widest realistic value (e.g., "250 grams").
- **`›`** is `chevron.right` styled lightly — it's the navigation
  affordance.
- Total row height stays roughly equivalent to today's row; the
  components are arranged in an `HStack` with `Spacer()`s.

### Tap behaviors

- **`(−)`** — decrement amount by `effectiveStep(for: ingredient)`.
  Floor at 0. Call `mealIngredientMgr.manualAdjustment(name:,
  amount:)` so the change records as a manual override and survives
  the next `generateMeal()`. For meat ingredients (where
  `mealIngredient.meat == true`), call
  `profileMgr.setMeatAndAmount(meat:, meatAmount:)` instead — same
  branching MealEdit currently does.
- **`(+)`** — increment by `effectiveStep(for: ingredient)`. Same
  `manualAdjustment`/`setMeatAndAmount` branching.
- After either step, call `generateMeal()` so macros/auto-adjustments
  recompute. (MealEdit didn't need to because the view dismissed and
  MealList's `.onAppear` ran. Here we stay in MealList, so the call
  must be explicit.)
- **pill** — present a `NumberEntrySheet` (see below) via a state
  flag. On save, same manualAdjustment/setMeatAndAmount + generateMeal
  pattern.
- **`›`** — `NavigationLink` to `MealIngredientDetail(mealIngredient:
  mealIngredient)`.
- Existing swipe actions (lock/unlock left, deactivate/delete right)
  are preserved exactly.

### `NumberEntrySheet`

A SwiftUI `.sheet` (full sheet on iPhone iOS 15.3 — no
`.presentationDetents` available on this deployment target) with a
minimal `Form` containing:

- A read-only label showing the ingredient name and current unit
  (e.g., "Coconut Oil (tbsps)").
- A `TextField` bound to a temporary `@State var amount: Double` with
  decimal keypad.
- A `Cancel` toolbar button (dismisses without saving).
- A `Save` toolbar button (calls the parent's save closure with the
  new value, then dismisses).

Called from MealList by setting a `@State` variable, similar to how
`resetMealIngredientsAlert` and `showSummary` work today. One sheet
instance, parameterized by the currently-active meal-ingredient.

### `AmountStepper` component

To keep MealList readable, factor the row's stepper portion into a
small subview:

```swift
struct AmountStepper: View {
    let mealIngredient: MealIngredient
    let ingredient: Ingredient   // for unit + step heuristic
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    let onPillTap: () -> Void
    let onDetailTap: () -> Void
    // body: HStack of (-)  pill  (+)  ›
}
```

Lives in `nutrition/Components/AmountStepper.swift`. Closure
parameters keep this view stateless and reusable; MealList does the
plumbing to mealIngredientMgr/profileMgr/generateMeal/showSheet.

### Out of scope

- Long-press on a stepper button to accelerate. YAGNI for now.
- Stepper on the IngredientList page or anywhere else.

## Feature 3 — MealIngredientDetail (replaces MealEdit)

### Goal

Show the user what a meal-ingredient is contributing in macros AND in
vitamins/minerals, in one read-only screen reachable from the `›`
chevron on the Meal page.

### Layout

```
Coconut Oil
  0.5 tbsps

Macros contributed
  Calories     65
  Fat          7 g
  Fiber        0 g
  NetCarbs     0 g
  Protein      0 g

Vit & Min contributed
  Vitamin E     0.3 mg   (2 % of RDA)
  Vitamin K     0.5 mcg  (<1 % of RDA)
  …            (only nutrients with non-zero contribution)

Done
```

- **Name + amount** at top.
- **Macros section** reads directly from
  `mealIngredient.calories/fat/fiber/netCarbs/protein` (already
  computed each `generateMeal()` cycle).
- **V&M section** — for each `VitaminMineralType` in
  `vitaminMineralOrder` (from yesterday's
  `VitaminMineralActuals.swift`), compute this single ingredient's
  contribution:
  - `let servings = (mealIngredient.amount * ingredient.consumptionGrams) / ingredient.servingSize`
  - `let contribution = ingredient.<vitaminField> * servings`
  - Skip if contribution == 0.
  - `% of RDA = contribution / vm.min() * 100`, where `vm.min()`
    is per the user's age/gender. Show `<1 %` when between 0 and 1
    exclusive. Skip the % display when `vm.min() == 0`.
- **Done** dismisses (popped from NavigationStack).
- Read-only: no editing fields, no save/cancel.

### Implementation

- New file `nutrition/Meal/MealIngredientDetail.swift`.
- Add it to the project via the `xcodeproj` Ruby gem (project uses
  `objectVersion = 55`, no synced groups).
- Delete `nutrition/Meal/MealEdit.swift`. Remove its reference from
  `project.pbxproj` (also via the gem to avoid hand-editing).
- Update `MealList.swift` — replace its `NavigationLink(destination:
  MealEdit(mealIngredient: mealIngredient), label: { … })` wrapper
  around the row with a plain `HStack` containing the row content
  plus the new `AmountStepper`. The `›` inside AmountStepper is the
  only entry point to `MealIngredientDetail`.

### Out of scope

- A "share / screenshot" button on the detail page — the iOS
  screenshot is sufficient (same rationale as DailySummary).
- Edit-ability on the detail page. If the user wants to change
  amount, they use the pill popover from MealList.

## Feature B (Shared) — `stepAmount` Field + `effectiveStep` Helper

### Goal

Per-ingredient configurable step size that defaults sensibly per
heuristic and can be overridden from the IngredientEdit form on the
Prep tab.

### Data model change

Add to `Ingredient`:

```swift
var stepAmount: Double   // 0 means "use heuristic"
```

- Stored property; default value `0` in the property declaration and
  in the `init(...)` parameter list (`stepAmount: Double = 0`).
- Update `Ingredient.update(...)` and `Ingredient.toggleAvailable()`
  to thread `stepAmount` through.
- Update `IngredientMgr.create(...)` to accept and forward
  `stepAmount`.

### Codable compatibility

Existing saved data won't have a `stepAmount` key. Without
intervention, decoding fails the moment we add a non-optional
property.

**Decision:** implement a custom `init(from decoder: Decoder)` on
`Ingredient` that decodes every field by hand. Each field uses
`container.decode(...)` for required fields and
`container.decodeIfPresent(...) ?? 0` for `stepAmount`. Verbose
(40+ fields) but explicit and safe. To mitigate the risk of a
hand-written decoder silently zeroing fields: keep the decoded
field order identical to the memberwise `init`'s parameter order
and require code-review confirmation of one-to-one mapping before
merge.

### `effectiveStep` helper

Free function in `nutrition/Components/AmountStepper.swift`:

```swift
func effectiveStep(for ingredient: Ingredient) -> Double {
    if ingredient.stepAmount > 0 {
        return ingredient.stepAmount
    }
    switch ingredient.consumptionUnit {
    case .piece, .egg, .can, .whole, .slice, .cup:
        return 1
    case .tablespoon:
        return 0.5
    case .gram:
        return ingredient.servingSize <= 35 ? 5 : 25
    default:
        return 1
    }
}
```

The `default:` covers units not currently used by any ingredient
(bar, internationalUnit, microgram, milligram, none) — these aren't
expected here but the function must be exhaustive.

### IngredientEdit field

Add a "Step amount" field below the existing nutrition fields in
`IngredientEdit.swift`:

- `NameValue("Step amount", description: "0 = auto by unit & serving size",
   $ingredient.stepAmount, ingredient.consumptionUnit, edit: true)`
- Existing form patterns handle this; no special UI needed.

## Files Changing

**New:**
- `nutrition/Components/AmountStepper.swift` — stepper component +
  `effectiveStep` helper.
- `nutrition/Components/NumberEntrySheet.swift` — manual-entry sheet.
- `nutrition/Meal/MealIngredientDetail.swift` — read-only detail view.

**Modified:**
- `nutrition/Tabs.swift` — drop Adjustments tab; rename Ingredients →
  Prep.
- `nutrition/Ingredients/IngredientList.swift` — add Adjustments
  toolbar button.
- `nutrition/Ingredients/IngredientEdit.swift` — add Step amount field.
- `nutrition/Ingredients/Ingredient.swift` — add `stepAmount` field;
  custom `init(from:)` for Codable back-compat; update other inits
  and copy helpers.
- `nutrition/Meal/MealList.swift` — swap row body for AmountStepper;
  remove NavigationLink to MealEdit; add `@State` for sheet/detail
  bindings.

**Deleted:**
- `nutrition/Meal/MealEdit.swift` — verified above (only one call
  site in MealList; no other references).

**Project file:**
- `nutrition.xcodeproj/project.pbxproj` — add three new Swift files
  and remove MealEdit.swift via the `xcodeproj` Ruby gem.

## Testing

Manual verification on Simulator (no automated framework):

1. **Tab restructuring:**
   - Tab bar shows Meal, Prep, Profile (only 3 tabs).
   - Prep tab opens the ingredient list.
   - Tap the slider toolbar icon on Prep → AdjustmentList pushes;
     edits work; back navigation returns to Prep.

2. **Stepper:**
   - Each meal row shows `(−) pill (+) ›`.
   - Tap `(−)` on Coconut Oil (0.5 tbsps) → becomes 0.0 tbsps. Tap
     again → stays at 0 (floor). Tap `(+)` → 0.5.
   - Tap `(+)` on Broccoli (150g) → 175g.
   - Tap `(+)` on Macadamia Nuts (30g) → 35g (verifies servingSize
     ≤ 35 heuristic).
   - Tap the pill on Eggs → sheet rises; enter 4; Save → Eggs becomes
     4. Cancel from a different one doesn't change anything.
   - Dashboard macros + V&M update after every step/save.
   - Confirm the row's swipe actions still work (lock/unlock left,
     deactivate/delete right).

3. **MealIngredientDetail:**
   - Tap `›` on Eggs → detail page appears showing macros (Calories,
     Fat, Fiber, NetCarbs, Protein) and V&M contributions only for
     nutrients with non-zero values. Percentages render correctly,
     `<1 %` shown where applicable.
   - Back button returns to Meal list.

4. **stepAmount override:**
   - On Prep tab, open Avocado. Set Step amount to 50. Save.
   - Back to Meal tab. Tap `(+)` on Avocado → 220 + 50 = 270g.
   - Set Step amount back to 0 on Avocado → Meal `(+)` resumes
     using 25g.

5. **Persistence (Codable back-compat):**
   - With existing UserDefaults from prior versions, app launch
     decodes ingredients without crashing. Old ingredients have
     `stepAmount == 0` (auto). Confirm `(+)` still steps via the
     heuristic for old data.

## Risks & Open Questions

- **Codable back-compat surface area:** writing a full `init(from:)`
  by hand for `Ingredient` is high-touch — 40+ fields. A typo silently
  zeros out a nutrient. Mitigation: keep the order identical to the
  memberwise init and code-review the new function carefully. If
  this risk feels too high, the alternative is to bump the
  deployment target or add a one-shot migration that re-seeds data
  if the decoded total looks wrong.
- **`MealEdit.swift` deletion:** if any preview or other file
  references it (the preview struct at the bottom of MealEdit
  references itself, no external preview refs were found earlier),
  the delete is safe. The implementation plan will grep for any
  stray references first.
- **iPhone full-sheet for NumberEntrySheet:** on iOS 15.3 we can't
  use `.presentationDetents` to make it a partial sheet. The sheet
  will be full-screen. Acceptable trade-off (matches existing modal
  patterns in the app).
- **Toolbar density on Prep:** the Prep page already has EditButton,
  show-unavailable, and Add. Adding the Adjustments slider icon
  makes it 4 buttons. Should fit but worth a visual sanity check.

## Out of Scope (Deferred)

- Photo → LLM ingredient capture (still its own future spec).
- Step amount on other pages (Adjustments, IngredientAdd).
- Detail page editing.
- Long-press accelerator on stepper buttons.
