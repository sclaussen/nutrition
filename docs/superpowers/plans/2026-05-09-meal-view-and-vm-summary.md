# Meal-View Enhancements + V&M Summary Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement three iOS features on the nutrition app: hide-macros toggle on the Meal page, vitamin/mineral cumulative + drill-down views, and a long-press daily summary screenshot view.

**Architecture:** Three independent UI features sharing one piece of new infrastructure (`VitaminMineralActuals` — pure functions that total nutrient contributions across active meal ingredients). Each task ends with a builds-clean app and a manually verifiable change.

**Tech Stack:** Swift 5, SwiftUI, iOS 15.3+, Xcode 16. No automated test framework — verification is `xcodebuild` for compile-correctness plus manual Simulator runs for UX. Each task ends with one git commit on a feature branch.

**Spec:** [docs/superpowers/specs/2026-05-09-meal-view-and-vm-summary-design.md](../specs/2026-05-09-meal-view-and-vm-summary-design.md)

---

## Setup

### Task 0: Create feature branch

**Files:** none.

- [ ] **Step 1: Branch off master**

```bash
cd /Users/shane/src/nutrition
git checkout -b feature/meal-view-and-vm-summary
```

- [ ] **Step 2: Verify clean position**

```bash
git status
git log --oneline -5
```

Expected: on `feature/meal-view-and-vm-summary`. Untracked files from earlier session are fine; we don't touch them in this plan.

---

## Task 1: VitaminMineralActuals helper

Pure-function helper that totals nutrients across active meal ingredients and returns per-ingredient contributions for a single nutrient. Both Feature 2 (V&M view) and Feature 3 (daily summary) call it.

**Files:**
- Create: `nutrition/VitaminMinerals/VitaminMineralActuals.swift`

- [ ] **Step 1: Create the helper file**

Create `nutrition/VitaminMinerals/VitaminMineralActuals.swift` with this exact content:

```swift
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
```

- [ ] **Step 2: Add to Xcode project**

The file is in `nutrition/VitaminMinerals/`. Open the project in Xcode (one-time per new file) so it gets added to the build target — or verify via the next build that Xcode auto-discovers it (Xcode 16 with file-system-synced groups does this automatically for groups that map to folders).

- [ ] **Step 3: Build to verify compilation**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`. If a "cannot find 'VitaminMineralContribution'" or similar compile error appears, the new file is not in the build target — add it via Xcode (File → Add Files to "nutrition…").

- [ ] **Step 4: Commit**

```bash
git add nutrition/VitaminMinerals/VitaminMineralActuals.swift nutrition.xcodeproj/project.pbxproj
git commit -m "Add VitaminMineralActuals helper for cumulative + drill-down nutrient totals

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

(If the .pbxproj wasn't modified because Xcode auto-discovered the file, just add the .swift.)

---

## Task 2: Hide-macros toggle on Meal page

Replace the standalone `showInactive` toolbar button with a "view options" Menu that contains both `showInactive` and a new `showMacros` toggle. Persist `showMacros` via `@AppStorage`. Default OFF. Pass through to `IngredientRowHeader` and each `IngredientRow`.

**Files:**
- Modify: `nutrition/Meal/MealList.swift`

- [ ] **Step 1: Add the showMacros AppStorage state**

In `nutrition/Meal/MealList.swift`, find the existing state declarations around line 12:

```swift
    @State var showInactive: Bool = false
    @State var amount: Double = 0
    @State var mealConfigureActive = false
    @State var resetMealIngredientsAlert = false
```

Add `@AppStorage("showMacros") private var showMacros: Bool = false` immediately after them:

```swift
    @State var showInactive: Bool = false
    @State var amount: Double = 0
    @State var mealConfigureActive = false
    @State var resetMealIngredientsAlert = false
    @AppStorage("showMacros") private var showMacros: Bool = false
```

- [ ] **Step 2: Pass showMacros into the row header**

Find the `IngredientRowHeader` use around line 45:

```swift
            IngredientRowHeader(showMacros: true)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
              .border(Color.theme.green, width: 0)
```

Change `showMacros: true` to `showMacros: showMacros`:

```swift
            IngredientRowHeader(showMacros: showMacros)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
              .border(Color.theme.green, width: 0)
```

- [ ] **Step 3: Pass showMacros into each IngredientRow**

Find the `IngredientRow` use inside the `ForEach` around line 52:

```swift
                NavigationLink(destination: MealEdit(mealIngredient: mealIngredient),
                               label: {
                                   IngredientRow(showMacros: true,
                                                 name: mealIngredient.name,
                                                 calories: mealIngredient.calories,
```

Change `showMacros: true` to `showMacros: showMacros`:

```swift
                NavigationLink(destination: MealEdit(mealIngredient: mealIngredient),
                               label: {
                                   IngredientRow(showMacros: showMacros,
                                                 name: mealIngredient.name,
                                                 calories: mealIngredient.calories,
```

- [ ] **Step 4: Replace the showInactive Button with a view-options Menu**

Find the existing principal-toolbar block in `MealList.swift` around lines 132-160. The current `Active/Inactive Toggle` Button looks like:

```swift
                      // Active/Inactive Toggle
                      Button {
                          withAnimation(.easeInOut) {
                              showInactive.toggle()
                          }
                      } label: {
                          Image(systemName: !mealIngredientMgr.inactiveIngredientsExist() ? "" : showInactive ? "eye" : "eye.slash")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)
```

Replace it with this `Menu`:

```swift
                      // View options menu (show inactive / show macros)
                      Menu {
                          Toggle(isOn: $showInactive) {
                              Label("Show inactive", systemImage: "eye")
                          }
                          Toggle(isOn: $showMacros) {
                              Label("Show macros", systemImage: "chart.bar.xaxis")
                          }
                      } label: {
                          Image(systemName: "slider.horizontal.3")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)
```

(Note: the prior conditional that hid the button when no inactive ingredients exist is dropped intentionally — toggling it with no inactives is harmless and the menu is now always reachable.)

- [ ] **Step 5: Build**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`.

- [ ] **Step 6: Manual verify**

Open the project in Xcode, run on a Simulator (Cmd+R):
1. The Meal page rows should NOT show macros (cal/fat/fiber/netCarbs/protein columns missing).
2. Tap the new `slider.horizontal.3` icon in the top-middle toolbar; a menu appears with two toggles.
3. Toggle "Show macros" on. Columns appear.
4. Force-quit the app (swipe up on the app card). Reopen — columns still showing.
5. Toggle off. Force-quit and reopen — columns hidden again.
6. Toggle "Show inactive" on/off — same behavior as before.

- [ ] **Step 7: Commit**

```bash
git add nutrition/Meal/MealList.swift
git commit -m "Add hide-macros toggle to Meal page (default off, persisted)

Replace standalone showInactive button with a view-options menu
containing both showInactive and showMacros toggles.  showMacros is
persisted via @AppStorage; default off so the per-row macro columns
are hidden by default and the dashboard at the top stays uncluttered.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

## Task 3: Extend VitaminMineralRow with an Actual column

Update `VitaminMineralRow` to render a 5th column showing the actual cumulative amount, with color coding (red below min, green in range, red above defined max). Also update `VitaminMineralRowHeader` to label it.

**Files:**
- Modify: `nutrition/Components/VitaminMineralRow.swift`

- [ ] **Step 1: Replace the entire file**

Replace the contents of `nutrition/Components/VitaminMineralRow.swift` with:

```swift
import SwiftUI


struct VitaminMineralRowHeader: View {
    var nameWidthPercentage: Double = 0.26
    var minWidthPercentage: Double = 0.16
    var maxWidthPercentage: Double = 0.16
    var actualWidthPercentage: Double = 0.16
    var unitWidthPercentage: Double = 0.13


    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text("Vitamin/Mineral").font(.caption).foregroundColor(Color.theme.blueYellow).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading)
                Text("Min").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: minWidthPercentage * geo.size.width, alignment: .trailing)
                Text("Max").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: maxWidthPercentage * geo.size.width, alignment: .trailing)
                Text("Actual").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: actualWidthPercentage * geo.size.width, alignment: .trailing)
                Text("Unit").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading)
            }
        }
    }
}


struct VitaminMineralRow: View {
    var nameWidthPercentage: Double = 0.26
    var minWidthPercentage: Double = 0.16
    var maxWidthPercentage: Double = 0.16
    var actualWidthPercentage: Double = 0.16
    var unitWidthPercentage: Double = 0.13

    var name: VitaminMineralType
    var min: Double
    var max: Double
    var actual: Double = 0
    var unit: Unit = Unit.milligram


    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text(name.formattedString()).font(.callout).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading)
                Text("\(min.formattedString(0))").font(.caption2).frame(width: minWidthPercentage * geo.size.width, alignment: .trailing)
                Text(max > 0 ? "\(max.formattedString(0))" : "—").font(.caption2).frame(width: maxWidthPercentage * geo.size.width, alignment: .trailing)
                Text("\(actual.formattedString(0))").font(.caption2).foregroundColor(actualColor).frame(width: actualWidthPercentage * geo.size.width, alignment: .trailing)
                Text(unit.pluralForm).font(.caption).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading)
            }.frame(height: 9)
        }
    }


    // Color rule: red if below min OR above defined max, green if
    // within range.  When max is undefined (max == 0), only the
    // below-min check applies.
    private var actualColor: Color {
        if actual < min {
            return Color.theme.red
        }
        if max > 0 && actual > max {
            return Color.theme.red
        }
        return Color.theme.green
    }
}
```

The changes vs the existing file:
- Drops the old `Unit` column that was duplicated between min and max.
- Adds an `Actual` column in its place plus a single trailing `Unit` column.
- Tightens the percentage widths so 5 columns fit in the same row width.
- Adds `actualColor` for red/green semantic coloring.
- Renders `—` for max when undefined (`max == 0`).

- [ ] **Step 2: Build**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "warning:|error:|BUILD" | tail -5
```

Expected: `** BUILD SUCCEEDED **`. There may be a temporary error referencing `actual` not being passed by the existing `VitaminMineralList` — that's expected; Task 4 fixes the call site. If the error blocks the build, jump straight to Task 4 first then return to verify.

Likely outcome: build succeeds because `actual` has a default value of `0`, so existing call sites still compile (they just show `0` until Task 4).

- [ ] **Step 3: Commit**

```bash
git add nutrition/Components/VitaminMineralRow.swift
git commit -m "Add Actual column to VitaminMineralRow with min/max color coding

Drops the duplicated Unit column and inserts an Actual column.  Color
rule: red if below min or above defined max, green when in range.
Renders an em dash for nutrients with no upper limit.  Default actual
is 0 so existing callers compile until they're updated to compute
real totals.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

## Task 4: VitaminMineralList shows cumulative actuals

Wire the V&M list to compute and display real totals, using the helper from Task 1. Also accept `mealIngredientMgr` and `ingredientMgr` via environment so the list can do the computation.

**Files:**
- Modify: `nutrition/VitaminMinerals/VitaminMineralList.swift`

- [ ] **Step 1: Replace the entire file**

Replace the contents of `nutrition/VitaminMinerals/VitaminMineralList.swift` with:

```swift
import SwiftUI


struct VitaminMineralList: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var vitaminMineralMgr: VitaminMineralMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr


    var body: some View {
        let actuals = computeVitaminMineralActuals(
            mealIngredients: mealIngredientMgr.mealIngredients,
            ingredientMgr: ingredientMgr
        )

        return List {
            VitaminMineralRowHeader()
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))

            ForEach(vitaminMineralMgr.getAll(age: profileMgr.profile.age, gender: profileMgr.profile.gender)) { vitaminMineral in
                NavigationLink(destination: VitaminMineralContributors(nutrient: vitaminMineral.name)) {
                    VitaminMineralRow(name: vitaminMineral.name,
                                      min: vitaminMineral.min(),
                                      max: vitaminMineral.max(),
                                      actual: actuals[vitaminMineral.name] ?? 0,
                                      unit: Unit.gram)
                }
            }
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        }
    }
}
```

Changes vs the existing file:
- Adds `mealIngredientMgr` and `ingredientMgr` env objects.
- Computes `actuals` once per body render.
- Wraps each row in a `NavigationLink` that pushes a (still-to-be-created) `VitaminMineralContributors` view.
- Passes the computed actual to `VitaminMineralRow`.

- [ ] **Step 2: Build (will fail until Task 5)**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "error:" | head -5
```

Expected: a single error, "cannot find 'VitaminMineralContributors' in scope". This is fixed in Task 5. **Do not commit yet** — leave the changes staged.

- [ ] **Step 3: Stage but don't commit**

```bash
git add nutrition/VitaminMinerals/VitaminMineralList.swift
```

The commit comes after Task 5 (combined: "wire cumulative view + drill-down").

---

## Task 5: VitaminMineralContributors drill-down view

The destination view for tapping a row in the cumulative V&M list. Lists each ingredient that contributes to the chosen nutrient, sorted descending by contribution.

**Files:**
- Create: `nutrition/VitaminMinerals/VitaminMineralContributors.swift`

- [ ] **Step 1: Create the file**

Create `nutrition/VitaminMinerals/VitaminMineralContributors.swift` with:

```swift
import SwiftUI


struct VitaminMineralContributors: View {

    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    let nutrient: VitaminMineralType


    var body: some View {
        let contributions = contributorsTo(
            nutrient: nutrient,
            mealIngredients: mealIngredientMgr.mealIngredients,
            ingredientMgr: ingredientMgr
        )
        let total = contributions.reduce(0) { $0 + $1.contribution }
        let vm = VitaminMineral(name: nutrient,
                                age: profileMgr.profile.age,
                                gender: profileMgr.profile.gender)

        return List {
            Section {
                if contributions.isEmpty {
                    Text("No active meal ingredient contributes to \(nutrient.formattedString()).")
                      .font(.callout)
                      .foregroundColor(Color.theme.blackWhiteSecondary)
                } else {
                    ForEach(contributions) { c in
                        HStack {
                            Text(c.ingredientName)
                              .font(.callout)
                            Spacer()
                            Text("\(c.amount.formattedString(0)) \(c.consumptionUnit.pluralForm)")
                              .font(.caption2)
                              .foregroundColor(Color.theme.blackWhiteSecondary)
                            Spacer()
                            Text("\(c.contribution.formattedString(1))")
                              .font(.caption)
                            Text(total > 0 ? "(\(Int((c.contribution / total) * 100))%)" : "")
                              .font(.caption2)
                              .foregroundColor(Color.theme.blackWhiteSecondary)
                              .frame(width: 50, alignment: .trailing)
                        }
                    }
                }
            } header: {
                Text("Contributors")
            } footer: {
                let minStr = vm.min().formattedString(0)
                let maxStr = vm.max() > 0 ? vm.max().formattedString(0) : "—"
                Text("Total \(total.formattedString(1))   |   Min \(minStr)   |   Max \(maxStr)")
                  .font(.caption2)
            }
        }
          .navigationTitle("\(nutrient.formattedString()) Contributors")
    }
}
```

- [ ] **Step 2: Build (full project)**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "warning:|error:|BUILD" | grep -v "AppIntents" | tail -5
```

Expected: `** BUILD SUCCEEDED **`. The Task 4 staged changes plus this new file should compile together.

- [ ] **Step 3: Manual verify**

Run on Simulator:
1. Go to Profile tab → scroll to "Derived Profile Data" → tap "Vitamins and Minerals".
2. The list now shows 5 columns (Name | Min | Max | Actual | Unit). Actual should be non-zero for nutrients in your active meal (e.g., calcium from cheese, iron from eggs, etc.).
3. Tap a row (e.g., "Vitamin C"). A new screen appears titled "Vitamin C Contributors" listing each ingredient that contributes to it, sorted by contribution.
4. Tap back. Tap a different row. Same drill-down works.
5. If a nutrient has no contributors, the list shows the empty-state text.

- [ ] **Step 4: Commit (combined with Task 4)**

```bash
git add nutrition/VitaminMinerals/VitaminMineralContributors.swift nutrition.xcodeproj/project.pbxproj
git commit -m "V&M list shows cumulative actuals + per-nutrient drill-down

Update VitaminMineralList to compute live totals via
computeVitaminMineralActuals and wrap each row in a NavigationLink
to a new VitaminMineralContributors view.  Contributors view shows
each ingredient that contributes to the chosen nutrient, sorted
descending, with a footer showing total + RDA min/max.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

(If the .pbxproj wasn't auto-updated for the new file, add it via Xcode first.)

---

## Task 6: V&M toolbar button on the Meal page

A second access point for the V&M cumulative view, reachable directly from the Meal page.

**Files:**
- Modify: `nutrition/Meal/MealList.swift`

- [ ] **Step 1: Add a NavigationLink to the principal HStack**

In `nutrition/Meal/MealList.swift`, find the principal-toolbar HStack (after the changes from Task 2 it contains: view-options Menu, reset Button, gear Button). Add a new `NavigationLink` after the reset Button and before the gear Button:

Current state after Task 2:
```swift
                      // Reset entire set of meal ingredients
                      Button {
                          resetMealIngredientsAlert = true
                      } label: {
                          Image(systemName: "arrow.uturn.backward")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)


                      // Meal Configure
                      Button {
```

Insert this new block between them:

```swift
                      // Reset entire set of meal ingredients
                      Button {
                          resetMealIngredientsAlert = true
                      } label: {
                          Image(systemName: "arrow.uturn.backward")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)


                      // Vitamins & Minerals cumulative view
                      NavigationLink(destination: VitaminMineralList()) {
                          Image(systemName: "pills")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)


                      // Meal Configure
                      Button {
```

- [ ] **Step 2: Build**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | tail -3
```

Expected: `** BUILD SUCCEEDED **`.

- [ ] **Step 3: Manual verify**

Run on Simulator:
1. On the Meal tab, the top-middle toolbar shows: view-options menu (slider icon), reset (uturn arrow), pills, gear.
2. Tap the pills icon. The V&M cumulative view appears.
3. The view behaves identically to the Profile-tab access path.
4. Use the back button to return to the Meal page.

- [ ] **Step 4: Commit**

```bash
git add nutrition/Meal/MealList.swift
git commit -m "Add V&M toolbar button (pills icon) on Meal page

Second access point for the cumulative Vitamins & Minerals view,
matching the existing 'Vitamins and Minerals' link under Profile.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

## Task 7: DailySummary view

A standalone, screenshot-friendly view showing today's calories, macros, body metrics, and V&M warnings. No trigger yet — that's Task 8.

**Files:**
- Create: `nutrition/Meal/DailySummary.swift`

- [ ] **Step 1: Create the file**

Create `nutrition/Meal/DailySummary.swift` with:

```swift
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
```

- [ ] **Step 2: Build**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "warning:|error:|BUILD" | grep -v "AppIntents" | tail -5
```

Expected: `** BUILD SUCCEEDED **`. (View is unused yet, that's OK.)

Property names verified against `nutrition/Meal/Macros.swift`: the
`Macros` struct exposes both goals (`fatGoal`, `fiberMinimum`,
`netCarbsMaximum`, `proteinGoal`, `caloriesGoal`) and actuals
(`fat`, `fiber`, `netCarbs`, `protein`, `calories`).

- [ ] **Step 3: Commit**

```bash
git add nutrition/Meal/DailySummary.swift nutrition.xcodeproj/project.pbxproj
git commit -m "Add DailySummary view (screenshot-friendly day overview)

Standalone view rendering today's calories, macros, body metrics,
and V&M warnings as a sheet.  Trigger added in the next task.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

## Task 8: Long-press on Dashboard opens DailySummary

Wire the long-press gesture on `Dashboard` to a sheet binding in `MealList` that presents `DailySummary`.

**Files:**
- Modify: `nutrition/Meal/Dashboard.swift`
- Modify: `nutrition/Meal/MealList.swift`

- [ ] **Step 1: Add a binding parameter to Dashboard**

In `nutrition/Meal/Dashboard.swift`, add a new `@Binding var showSummary: Bool` to the property list at the top of `Dashboard` (after the existing `let` properties):

Existing top of struct:
```swift
struct Dashboard: View {
    let bodyMass: Double
    let bodyFatPercentage: Double
    ...
    let netCarbs: Double
    let protein: Double

    var body: some View {
```

Add the binding after the lets:
```swift
struct Dashboard: View {
    let bodyMass: Double
    let bodyFatPercentage: Double
    ...
    let netCarbs: Double
    let protein: Double

    @Binding var showSummary: Bool

    var body: some View {
```

- [ ] **Step 2: Add the long-press gesture**

In the same file, find the outer `GeometryReader { geo in VStack(spacing: 0) { ... } }`. Attach `.onLongPressGesture` to the `VStack`:

```swift
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                ...
                Spacer()
            }
              .contentShape(Rectangle())
              .onLongPressGesture(minimumDuration: 0.6) {
                  showSummary = true
              }
        }
    }
```

(`.contentShape(Rectangle())` makes the whole VStack area tappable, including spacers — without it, long-press only works where there are visible subviews.)

- [ ] **Step 3: Add showSummary state and sheet to MealList**

In `nutrition/Meal/MealList.swift`, add `@State private var showSummary = false` next to the other `@State` declarations (right after `@AppStorage("showMacros")` from Task 2):

```swift
    @State var resetMealIngredientsAlert = false
    @AppStorage("showMacros") private var showMacros: Bool = false
    @State private var showSummary = false
```

- [ ] **Step 4: Pass the binding into Dashboard**

In `MealList.swift`, find the existing `Dashboard(...)` invocation around line 24. Add `showSummary: $showSummary` as a new argument at the end of the parameter list. The current end of the call:

```swift
                      protein: macrosMgr.macros.protein)
              .listRowSeparator(.hidden)
```

Change to:

```swift
                      protein: macrosMgr.macros.protein,
                      showSummary: $showSummary)
              .listRowSeparator(.hidden)
```

- [ ] **Step 5: Add the sheet modifier**

In `MealList.swift`, find the `.alert("Reset Meal Ingredients?", ...)` modifier added in an earlier session. Add a `.sheet` modifier right after it:

Current:
```swift
          .alert("Reset Meal Ingredients?",
                 isPresented: $resetMealIngredientsAlert) {
              Button("Cancel", role: .cancel) { }
              Button("Reset", role: .destructive) {
                  withAnimation {
                      mealIngredientMgr.resetMealIngredients()
                      generateMeal()
                  }
              }
          } message: {
              Text("This will replace your current meal ingredient amounts with the defaults. This can't be undone.")
          }
    }
```

After:
```swift
          .alert("Reset Meal Ingredients?",
                 isPresented: $resetMealIngredientsAlert) {
              Button("Cancel", role: .cancel) { }
              Button("Reset", role: .destructive) {
                  withAnimation {
                      mealIngredientMgr.resetMealIngredients()
                      generateMeal()
                  }
              }
          } message: {
              Text("This will replace your current meal ingredient amounts with the defaults. This can't be undone.")
          }
          .sheet(isPresented: $showSummary) {
              DailySummary()
          }
    }
```

- [ ] **Step 6: Build**

```bash
cd /Users/shane/src/nutrition
xcodebuild -project nutrition.xcodeproj -scheme nutrition -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "warning:|error:|BUILD" | grep -v "AppIntents" | tail -5
```

Expected: `** BUILD SUCCEEDED **`.

- [ ] **Step 7: Manual verify**

Run on Simulator:
1. On the Meal tab, long-press anywhere on the dashboard area at the top of the page (~0.6 seconds).
2. The DailySummary sheet rises from the bottom.
3. Confirm the today date in the title.
4. Confirm Calories, Macros, Body, and V&M sections render with sensible values.
5. Take a screenshot via Cmd+S in the Simulator (or device side button + volume up). Layout reads cleanly.
6. Tap "Done" to dismiss.
7. Long-press the dashboard again — the sheet reopens.

- [ ] **Step 8: Commit**

```bash
git add nutrition/Meal/Dashboard.swift nutrition/Meal/MealList.swift
git commit -m "Long-press dashboard opens DailySummary sheet

Adds a 0.6s long-press gesture to the Dashboard that flips a
showSummary @State on MealList, presented as a SwiftUI sheet.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

## Wrap-up

After all 8 tasks, the user should see:

- **Meal page:** macros hidden by default; view-options menu in toolbar exposes both "Show inactive" and "Show macros". A new `pills` button opens the V&M cumulative view. Long-pressing the dashboard opens the daily-summary sheet.
- **V&M view:** 5-column list (Name, Min, Max, Actual, Unit) with red/green coloring; tap a row to drill into per-ingredient contributions for that nutrient.
- **Profile → Vitamins and Minerals:** same destination as the Meal-page pills button.
- **Daily summary:** 4 sections (Calories, Macros, Body, V&M warnings), screenshot-friendly.

Suggested final manual smoke test:
1. Launch app fresh.
2. Confirm no macros on rows.
3. Toggle "Show macros" on; confirm columns appear.
4. Open V&M from pills icon; tap "Vitamin C"; confirm contributors.
5. Long-press dashboard; confirm summary sheet.
6. Force-quit + reopen; confirm Show macros state persists.

If everything works, optionally merge:

```bash
git checkout master
git merge --no-ff feature/meal-view-and-vm-summary
```

…or open a PR if the user prefers review-style integration.

## Out of Scope (Reminder)

- Photo → LLM ingredient capture (deferred, separate spec).
- Per-row V&M indicator on the Meal list.
- Toggling macros on the Ingredients page.
- Historical day-over-day summary trends.
- Custom share/save UI on the daily summary (iOS screenshot is sufficient).
