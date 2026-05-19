# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a nutrition tracking application with two main components:
1. **iOS SwiftUI App**: The main nutrition tracking application (`nutrition/` directory)
2. **JavaScript Utilities**: Vitamin/mineral data processing scripts (`vitamins.js`)

The app helps users track meals, ingredients, nutritional values, and vitamin/mineral intake with automatic and manual adjustments.

## Common Commands

### iOS Development
- **Build Project**: Open `nutrition.xcodeproj` in Xcode and use Cmd+B to build
- **Run on Simulator**: Open in Xcode and use Cmd+R to run
- **Clean Build**: Product → Clean Build Folder in Xcode

### JavaScript
- **Install Dependencies**: `npm install`
- **Run JavaScript Scripts**: `node vitamins.js`

## Architecture Overview

### iOS App Structure (SwiftUI + MVVM Pattern)

**Core Managers (ObservableObject pattern):**
- `IngredientMgr`: Manages food ingredients database and CRUD operations
- `MealIngredientMgr`: Handles meal composition and automatic/manual adjustments
- `AdjustmentMgr`: Manages dietary adjustments and constraints
- `ProfileMgr`: User profile and age/gender-based nutritional requirements
- `MacrosMgr`: Calculates and tracks macronutrient targets
- `VitaminMineralMgr`: Handles micronutrient tracking

**Key Data Models:**
- `Ingredient`: Comprehensive nutrition data with 20+ vitamins/minerals
- `MealIngredient`: Meal-specific ingredient with amount/adjustment tracking
- `Adjustment`: Automatic dietary adjustments with constraints
- `Profile`: User profile with age/gender-based nutrition calculations

**UI Organization:**
- `Tabs.swift`: Main tab-based navigation
- `Meal/`: Meal planning, dashboard, and macro tracking
- `Ingredients/`: Ingredient management (add/edit/list)
- `Adjustments/`: Dietary adjustment management
- `Profile/`: User profile and nutritional requirements
- `VitaminMinerals/`: Micronutrient tracking

### Data Architecture

**Persistence:**
- Uses `UserDefaults` with JSON encoding/decoding for data persistence
- Each manager handles its own serialization/deserialization
- Key-based storage: "ingredient", "mealIngredient", "adjustment", "profile", etc.

**Adjustment System:**
- **Constants.Default**: Original state
- **Constants.Manual**: User-modified amounts
- **Constants.Automatic**: System-calculated adjustments
- Supports undo operations and state restoration

**Nutrition Calculations:**
- Age and gender-based vitamin/mineral requirements (extensive lookup tables)
- Automatic scaling based on serving sizes and consumption units
- Support for various units (grams, tablespoons, pieces, cans, etc.)

### Special Features

**OpenFoodFacts Integration:**
- API integration for ingredient lookup via EAN/barcode scanning
- Example API calls in README: `curl https://world.openfoodfacts.org/api/v0/product/{barcode}.json`

**HealthKit Integration:**
- Configured with healthkit entitlements
- Can retrieve user profile data from Health app

**Comprehensive Nutrition Database:**
- 20+ vitamins and minerals per ingredient
- Age/gender-specific DV calculations using NIH guidelines
- Support for meat planning with automatic quantity calculations

## Development Guidelines

**Code Style (from existing CLAUDE.md):**
- Functions organized top-down (main → helper functions)
- Use short-circuiting in conditionals
- Import order: node_modules first, then local modules
- Switch statements preferred over if-else chains

**SwiftUI Patterns:**
- Environment objects for data sharing between views
- ObservableObject managers with @Published properties
- Immutable struct updates (create new instances vs. mutation)
- Navigation with `NavigationView` and `StackNavigationViewStyle`

**Data Model Patterns:**
- All models implement `Codable` and `Identifiable`
- Manager classes handle CRUD operations and business logic
- Automatic serialization on data changes via `didSet`
- Copy-based updates to maintain immutability

## Key Files to Understand

- `app.swift`: App entry point with dependency injection
- `Tabs.swift`: Main navigation structure
- `Ingredients/Ingredient.swift`: Core data model with extensive nutrition data
- `Meal/MealIngredient.swift`: Complex adjustment system implementation
- `Profile/Profile.swift`: Age/gender-based nutritional calculations
- `vitamins.js`: JavaScript utilities for vitamin/mineral data processing

## Feature Development Areas

The README.md contains extensive feature prioritization (P0-P4) including:
- EAN scanner integration
- Enhanced ingredient search
- Cloud Kit sync and collaboration
- Advanced macro/micro nutrient tracking
- Export/import functionality

## Testing and Validation

- No automated test framework currently configured
- Manual testing via iOS Simulator
- Ingredient data verification tracked via `verified` field
- Debug logging throughout adjustment calculations

## Data Tooling — Whole Foods price/nutrition scripts (`scripts/`)

Ingredient cost is gram-based:

```
costPerGram    = totalCost / effectiveTotalGrams   (effectiveTotalGrams = totalGrams if > 0, else parsed from the name)
costPerServing = costPerGram × servingSize
meal-row cost  = costPerGram × (amount × consumptionGrams)
```

So **`totalGrams` must be the net grams of the whole container**. For
pill/capsule supplements `consumptionGrams` is grams *per pill*, so
`totalGrams = containerPillCount × consumptionGrams`. A placeholder
like `totalGrams: 1` makes every pill cost a whole bottle — that was a
real bug; don't reintroduce it.

**Setup (one-time; system python3 lacks pip):**

```
/Users/shane/.pyenv/versions/3.10.4/bin/python3 -m venv scripts/.venv
scripts/.venv/bin/python -m pip install playwright
scripts/.venv/bin/python -m playwright install chromium
```

**`scripts/wf_refresh.py`** — Whole Foods price + macro fetcher. WF
serves price/nutrition in the page's `__NEXT_DATA__.aapiData`, pinned
to the store in the `wfm_store_d8` cookie (San Mateo); the path is
bot-protected so it drives headless Chromium via Playwright. Regular
price = `basisPriceAmount ?? priceAmount` (never the sale price).

```
# look up ONE (or a few) products directly — ignores the seed and the
# cached JSON; prints parsed price+nutrition JSON to stdout, progress
# to stderr (pipeable). Use this when given a single URL.
scripts/.venv/bin/python scripts/wf_refresh.py --url "<wf-product-url>" ["<url2>" ...]

scripts/.venv/bin/python scripts/wf_refresh.py                  # dry run, all seed WF URLs -> scripts/wf_refresh_out.json
scripts/.venv/bin/python scripts/wf_refresh.py --apply prices    # write refreshed totalCost back (writes .bak)
```

Not every product exposes WF data (third-party/marketplace items
return no price/nutrition) — but the WF product **title** usually
states the container count. For non-WF supplements, read the Amazon
listing (WebFetch, or the headless browser if WebFetch 500s) for the
capsule count.

**`scripts/fix_total_grams.py`** — fills `totalGrams` for priced
items that have **none** (`totalGrams == 0`; it intentionally skips
`> 0`, so a bogus `totalGrams: 1` is NOT auto-fixed — correct those
by hand). Uses the captured `scripts/wf_refresh_out.json`.
`--apply` to write (`.grams.bak`).

**`scripts/fix_food_units.py`** — propagates each Food's canonical
member `consumptionUnit`/`consumptionGrams` to every brand variant.
`--apply` to write (`.units.bak`).