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