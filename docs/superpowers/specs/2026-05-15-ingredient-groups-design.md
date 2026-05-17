# Ingredient Groups (variant selection at meal time)

**Date:** 2026-05-15
**Status:** Approved (Approach A). Implementing directly per user preference (no separate writing-plans gate).

## Goal

Let an ingredient belong to an optional **group** (e.g. "Eggs"). The group —
not the individual brand — is what's added to a meal. At meal time the user
long-presses the group row to pick which member (which egg brand) is active;
that member's macros and cost drive the meal.

## Decisions (from brainstorming)

| Fork | Decision |
|---|---|
| Group model | **New explicit `Group` entity** + `GroupMgr` (not the dormant `category` string). |
| Membership link | `Ingredient.groupName` (new field). Members = ingredients whose `groupName == group.name`. |
| List display | Group **collapses to one row** (the group name); members hidden from prep/meal-add lists, reached only via the picker. |
| Pick gesture | **Long-press a group row → member picker.** Non-group rows: long-press unchanged (lock). Group-row lock stays available via the existing name-tap Auto/Manual/Done cycle. |
| Selection scope | The pick is stored on the meal row (persisted) **and** updates `Group.defaultMemberName` (becomes the new global default). |
| Group admin | **From IngredientEdit**: a Group picker (existing names / "Create new…" / None) + a "Default member of this group" toggle. No separate Groups screen. |

## Data model

- `Group: Codable, Identifiable { id: String, name: String, defaultMemberName: String }`
- `GroupMgr: ObservableObject` — `@Published var groups: [Group] { didSet { serialize() } }`, UserDefaults key `"group"`, `deserialize()` called at init (unlike IngredientMgr). CRUD + `getByName`, `setDefault(group:member:)`.
- `Ingredient` += `var groupName: String = ""` — Codable via defaulted decode (`try c.decodeIfPresent ?? ""`) so existing saved data still loads. Seed entries can set `groupName:` (seed is runtime source of truth — `IngredientMgr.deserialize()` is never called).
- `MealIngredient` += `var selectedMemberName: String = ""` — non-empty ⇒ this is a group row, `name` holds the group name. Defaulted decode for migration.

## Behavior

**Adding a group:** the prep/meal-add list collapses ingredients sharing a
`groupName` into one entry per group. Adding it creates
`MealIngredient(name: group.name, selectedMemberName: group.defaultMemberName)`
with cached macros from the default member.

**Long-press group row:** present `GroupMemberPicker` (sheet) listing the
group's members. On pick:
1. `mealIngredient.selectedMemberName = picked`
2. recompute cached `calories/fat/fiber/netcarbs/protein` from the member's
   per-serving values × current amount
3. `groupMgr.setDefault(group:, member: picked)`
4. `generateMeal()`

**Macro/cost resolution:** in `generateMeal()` and on selection change, a
group `MealIngredient` resolves its member via
`IngredientMgr.getByName(selectedMemberName)`. The `$` cost list and the
DailySummary "Meal Cost" total use the resolved member's `totalCost/totalGrams`.
Fallbacks: member missing → use `group.defaultMemberName`; that missing too →
zeros + flagged (defensive, shouldn't happen).

**IngredientEdit Group section:** picker of existing group names +
"Create new group…" (text field) + "None"; plus a "Default member of this
group" toggle that calls `groupMgr.setDefault`. Setting a group on the first
ingredient auto-creates the `Group` with that ingredient as default.

## Files

| File | Change |
|---|---|
| `Meal/Group.swift` (new) | `Group` model + `GroupMgr`. |
| `Ingredients/Ingredient.swift` | `groupName` field + Codable migration; seed `groupName:` where relevant. |
| `Meal/MealIngredient.swift` | `selectedMemberName` field + Codable migration; macro recompute helper. |
| `Ingredients/IngredientList.swift` | Collapse group members to one row in the prep list / meal-add. |
| `Meal/MealList.swift` | Long-press group row → `GroupMemberPicker`; resolve member macros in `generateMeal()`. |
| `Meal/GroupMemberPicker.swift` (new) | Member-selection sheet. |
| `Ingredients/IngredientEdit.swift` | Group section (picker + create + default toggle). |
| `app.swift` | Inject `GroupMgr` env object. |
| `nutrition.xcodeproj/project.pbxproj` | Register `Group.swift`, `GroupMemberPicker.swift`. |

## Out of scope (v1)

- Reordering members / per-member portion overrides.
- Group-level nutrition independent of a member (always delegates to selected member).
- A dedicated Groups management screen (admin lives in IngredientEdit).
