# Photo → Ingredient (LLM-assisted label scanning)

**Date:** 2026-05-13
**Status:** Approved (single-pass implementation, Approach B)

## Goal

Take one or more photos of a food's packaging (e.g. front + nutrition label) and
have an LLM extract structured nutrition data so the user can add a new
ingredient or update an existing one — without retyping every macro and
vitamin/mineral by hand.

## User-facing flow

1. User taps a new **camera button** on the `IngredientList` toolbar.
2. `LabelCaptureSheet` appears: thumbnails of photos added so far, with
   **Add from camera**, **Add from library**, and **Analyze**.
3. User adds 1+ photos, taps **Analyze**.
4. App sends photos + the list of existing ingredient names to Anthropic
   (`claude-sonnet-4-6`) using **tool use** for guaranteed structured JSON.
5. `ScanReviewRouter` decides:
   - LLM says **new** → push prefilled `IngredientAdd`.
   - LLM says **update <name>** → push prefilled `IngredientEdit` with a diff
     banner showing what's changing vs. the existing record.
   - LLM is **ambiguous** → show `MatchChooserSheet` listing candidates; user
     picks "Create new" or one of them; then route as above.
6. User reviews the prefilled form (low-confidence fields tinted yellow), edits
   anything wrong, taps **Save**. Persistence goes through the existing
   `IngredientMgr.create` / `update` paths — no new storage code.

## Key design decisions

| Decision | Choice | Rationale |
|---|---|---|
| LLM provider/transport | Direct iOS → `api.anthropic.com/v1/messages` | Simplest; personal app, no distribution. |
| Model | `claude-sonnet-4-6` (vision) | Best vision quality on small / glossy / partially-occluded labels. User-selectable in Settings; `claude-haiku-4-5` is the cheap fallback. |
| Output format | JSON via Anthropic **tool_use** | Forces structured response, decoded with `JSONDecoder` into `ParsedIngredient`. No regex / fence stripping. |
| API key storage | iOS Keychain, set via Settings screen | Survives reinstalls; not in source. |
| Photo capture | `UIImagePickerController` (camera) + `PHPickerViewController` (library, multi-select) | iOS 15.3 deployment target rules out `PhotosPicker`. |
| Image preprocessing | Downscale to ≤1568px long edge, JPEG q=0.85 | Anthropic's vision sweet spot; ~300KB/image. |
| Existing-ingredient context | Names list sent in user message | Lets LLM detect "we already have this"; verified app-side against `IngredientMgr`. |
| Confidence | Sibling field `lowConfidenceFields: [String]` | Avoids per-field wrappers; review screen tints these yellow. |
| Persistence | Reuse existing `IngredientMgr` create/update | No new storage path. Failed scans persist nothing. |

## New files

| File | Purpose |
|---|---|
| `Settings/KeychainStore.swift` | One-item Keychain wrapper for the API key. |
| `Settings/SettingsView.swift` | API key field + model picker + test connection. |
| `Scanner/ParsedIngredient.swift` | `Codable` schema mirroring the tool-use JSON. |
| `Scanner/ScanDiff.swift` | Pure `compute(existing:, parsed:)` → list of changed fields. |
| `Scanner/ScanReviewRouter.swift` | Pure routing: `route(parsed, all) -> ScanRoute`. |
| `Scanner/NutritionScannerService.swift` | Anthropic vision + tool-use HTTP client. |
| `Scanner/CameraPicker.swift` | `UIViewControllerRepresentable` around `UIImagePickerController`. |
| `Scanner/PhotoLibraryPicker.swift` | `UIViewControllerRepresentable` around `PHPickerViewController`. |
| `Scanner/LabelCaptureSheet.swift` | Multi-photo capture sheet (thumbnails + Analyze). |
| `Scanner/MatchChooserSheet.swift` | Ambiguous-match resolver. |

## Modified files

| File | Change |
|---|---|
| `Ingredients/IngredientList.swift` | Toolbar gets camera + gear buttons; presents `LabelCaptureSheet`; routes scan result. |
| `Ingredients/IngredientAdd.swift` | New `init(prefill: ParsedIngredient? = nil)`; populates `@State` on appear; tints low-confidence fields. |
| `Ingredients/IngredientEdit.swift` | Optional `prefill` + `diff` params; renders top diff banner; tints low-confidence fields. |
| `nutrition.xcodeproj/project.pbxproj` | Adds new file refs, build files, two new groups (`Scanner`, `Settings`); adds `INFOPLIST_KEY_NSCameraUsageDescription` and `INFOPLIST_KEY_NSPhotoLibraryUsageDescription` build settings. |

## Tool schema (LLM contract)

```json
{
  "name": "submit_ingredient",
  "description": "Submit one parsed ingredient extracted from one or more nutrition label photos.",
  "input_schema": {
    "type": "object",
    "required": ["match", "name", "lowConfidenceFields"],
    "properties": {
      "match": {
        "type": "object",
        "required": ["kind"],
        "properties": {
          "kind": {"enum": ["new", "update", "ambiguous"]},
          "name": {"type": "string", "description": "When kind=update: the existing ingredient name we're updating."},
          "candidates": {"type": "array", "items": {"type": "string"},
                         "description": "When kind=ambiguous: 2+ existing names that might match."}
        }
      },
      "name": {"type": "string"},
      "brand": {"type": ["string", "null"]},
      "fullName": {"type": ["string", "null"]},
      "url": {"type": ["string", "null"]},
      "ingredientsList": {"type": ["array", "null"], "items": {"type": "string"}},
      "allergens": {"type": ["array", "null"], "items": {"type": "string"}},
      "servingSize": {"type": ["number", "null"], "description": "grams per serving"},
      "consumptionUnit": {"type": ["string", "null"],
                          "enum": ["gram", "tablespoon", "cup", "piece", "egg", "slice",
                                   "can", "bar", "whole", "pill"]},
      "consumptionGrams": {"type": ["number", "null"]},
      "calories": {"type": ["number", "null"]},
      "fat": {"type": ["number", "null"]},
      "saturatedFat": {"type": ["number", "null"]},
      "transFat": {"type": ["number", "null"]},
      "cholesterol": {"type": ["number", "null"]},
      "sodium": {"type": ["number", "null"]},
      "carbohydrates": {"type": ["number", "null"]},
      "fiber": {"type": ["number", "null"]},
      "sugar": {"type": ["number", "null"]},
      "addedSugar": {"type": ["number", "null"]},
      "netCarbs": {"type": ["number", "null"]},
      "protein": {"type": ["number", "null"]},
      "omega3": {"type": ["number", "null"]},
      "vitaminD": {"type": ["number", "null"]},
      "calcium": {"type": ["number", "null"]},
      "iron": {"type": ["number", "null"]},
      "potassium": {"type": ["number", "null"]},
      "vitaminA": {"type": ["number", "null"]},
      "vitaminC": {"type": ["number", "null"]},
      "vitaminE": {"type": ["number", "null"]},
      "vitaminK": {"type": ["number", "null"]},
      "thiamin": {"type": ["number", "null"]},
      "riboflavin": {"type": ["number", "null"]},
      "niacin": {"type": ["number", "null"]},
      "vitaminB6": {"type": ["number", "null"]},
      "folate": {"type": ["number", "null"]},
      "vitaminB12": {"type": ["number", "null"]},
      "pantothenicAcid": {"type": ["number", "null"]},
      "phosphorus": {"type": ["number", "null"]},
      "magnesium": {"type": ["number", "null"]},
      "zinc": {"type": ["number", "null"]},
      "selenium": {"type": ["number", "null"]},
      "copper": {"type": ["number", "null"]},
      "manganese": {"type": ["number", "null"]},
      "lowConfidenceFields": {"type": "array", "items": {"type": "string"},
                              "description": "Names of fields the model is unsure about."}
    }
  }
}
```

## Error handling

| Failure | Behavior |
|---|---|
| No API key configured | Capture sheet shows inline message: "Add your Anthropic API key in Settings." Analyze button disabled. |
| Network error / timeout (60s) | Inline error in capture sheet, **Retry** button. Photos kept. |
| HTTP 4xx (bad key, etc.) | Show server error message verbatim. |
| HTTP 5xx | Inline "Anthropic is having a moment, retry?" |
| LLM didn't call the tool | Treated as a parse failure; show response text in an alert for debugging. |
| Tool input fails JSON decode | Show `JSONDecoder` error; keep photos for retry. |
| `match.kind=update` but `name` not in our list | Treat as `.new`. |

## Out of scope for v1

- OCR fallback when offline (Apple Vision).
- Per-image attribution ("which photo did the LLM read this from").
- Cost tracking dashboard.
- Batch scanning (queue of multiple ingredients in one session).
- Tests (the codebase has no test target today).
