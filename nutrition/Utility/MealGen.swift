//
//  MealGen.swift
//  nutrition
//
//  Created by Shane Claussen on 3/9/22.
//

//import Foundation
//import SwiftUI
//
//func generate(profile: Profile, ingredientMgr: IngredientMgr, profileMgr: ProfileMgr, baseMgr: BaseMgr, adjustmentMgr: AdjustmentMgr) -> Meal {
//    // Update the profile
//    profileMgr.update(profile)
//    print("Height: " + String(profile.height))
//
//    // Copy data from the profile into the meal
//    var meal = Meal()
//    print("Setting macro goals")
//    meal.setMacroGoals(caloriesGoalUnadjusted: profile.caloriesGoalUnadjusted, caloriesGoal: profile.caloriesGoal, fatGoal: profile.fatGoal, fiberGoal: profile.fiberGoal, netcarbsGoal: profile.netcarbsGoal, proteinGoal: profile.proteinGoal)
//
//    // Add all the base ingredients to the meal
//    print("Adding base meal ingredients")
//    addBaseMealIngredients(meal: meal)
//
////    // Add the meat to the meal
////    if meat != "None" {
////        print("Adding meat ingredient")
////        addBaseMealIngredient(name: meat, amount: meatAmount, adjustment: true)
////        let ingredient = ingredientMgr.getIngredient(name: meat)!
////        for meatAdjustment in ingredient.meatAdjustments {
////            print("Adjusting meat adjustments")
////            if !adjustMeal(meal: meal, name: meatAdjustment.name, amount: meatAdjustment.amount) {
////                print("Failed for some reason")
////            }
////        }
////    }
//
//    // Now add all the adjustments to up to, but w/out exceeding,
//    // the macro goals
//    print("Trying adjustments")
//    while tryAddingAdjustments(meal: meal) {
//    }
//
//    meal.p()
//}
//
//func addBaseMealIngredients(meal: Meal) {
//    for baseIngredient in baseMgr.get(includeInactive: false) {
//        if baseIngredient.amount != baseIngredient.defaultAmount {
//            addBaseMealIngredient(name: baseIngredient.name, amount: baseIngredient.amount, adjustment: true)
//        } else {
//            addBaseMealIngredient(name: baseIngredient.name, amount: baseIngredient.amount, adjustment: false)
//        }
//    }
//}
//
//func addBaseMealIngredient(name: String, amount: Double, adjustment: Bool) {
//    if amount <= 0 {
//        return
//    }
//    let ingredient = ingredientMgr.getIngredient(name: name)!
//    let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize
//    let calories: Double = ingredient.calories * servings
//    let fat: Double = ingredient.fat * servings
//    let fiber: Double = ingredient.fiber * servings
//    let netcarbs: Double = ingredient.netcarbs * servings
//    let protein: Double = ingredient.protein * servings
//    meal.addOrUpdateMealIngredient(name: name, amount: amount, consumptionUnit: ingredient.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: adjustment)
//}
//
//func tryAddingAdjustments(meal: Meal) -> Bool {
//    for adjustment in adjustmentMgr.get(includeInactive: false) {
//        if tryAddingAdjustment(meal: meal, adjustment: adjustment) {
//            return true
//        }
//    }
//    return false
//}
//
//func tryAddingAdjustment(meal: Meal, adjustment: Adjustment) -> Bool {
//    let mealIngredient = meal.getMealIngredient(name: adjustment.name)
//    if adjustment.constraints && mealIngredient != nil {
//        let amountAfterAdjustment = mealIngredient!.amount + adjustment.amount
//        if amountAfterAdjustment < adjustment.minimum || amountAfterAdjustment > adjustment.maximum {
//            return false
//        }
//    }
//
//    return adjustMeal(meal: meal, name: adjustment.name, amount: adjustment.amount)
//}
//
//func adjustMeal(meal: Meal, name: String, amount: Double) -> Bool {
//    let ingredient = ingredientMgr.getIngredient(name: name)!
//    let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize
//    let calories: Double = ingredient.calories * servings
//    let fat: Double = ingredient.fat * servings
//    let fiber: Double = ingredient.fiber * servings
//    let netcarbs: Double = ingredient.netcarbs * servings
//    let protein: Double = ingredient.protein * servings
//
//    if meal.fatGoal < meal.fat + fat ||
//         meal.netcarbsGoal < meal.netcarbs + netcarbs ||
//         meal.proteinGoal < meal.protein + protein {
//        return false
//    }
//
//    meal.addOrUpdateMealIngredient(name: name, amount: amount, consumptionUnit: ingredient.consumptionUnit, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein, adjustment: true)
//    return true
//}
