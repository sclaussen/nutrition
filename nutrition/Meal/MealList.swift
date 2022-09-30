import SwiftUI
import HealthKit


struct MealList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var macrosMgr: MacrosMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    @State var showInactive: Bool = false
    @State var amount: Double = 0
    @State var mealConfigureActive = false

    // Use cases:
    // - Deactivate a meal ingredient because it's out that will be auto-adjusted
    // - Change the default value of a meal ingredient staple - would like an auto-reset to the default value once meal is done
    //
    // Actions:
    // - Manually updating amount removes the pending compensation if it exists
    var body: some View {
        List {
            Dashboard(bodyMass: profileMgr.profile.bodyMass,
                      bodyFatPercentage: profileMgr.profile.bodyFatPercentage,
                      activeCaloriesBurned: profileMgr.profile.activeCaloriesBurned,
                      calorieDeficit: profileMgr.profile.calorieDeficit,
                      proteinRatio: profileMgr.profile.proteinRatio,
                      caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted,
                      caloriesGoal: profileMgr.profile.caloriesGoal,
                      calories: macrosMgr.macros.calories,
                      fatGoal: profileMgr.profile.fatGoal,
                      fiberMinimum: profileMgr.profile.fiberMinimum,
                      netCarbsMaximum: profileMgr.profile.netCarbsMaximum,
                      proteinGoal: profileMgr.profile.proteinGoal,
                      fat: macrosMgr.macros.fat,
                      fiber: macrosMgr.macros.fiber,
                      netCarbs: macrosMgr.macros.netCarbs,
                      protein: macrosMgr.macros.protein)
              .listRowSeparator(.hidden)
              .frame(height: 230)
              .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
              .border(Color.theme.green, width: 0)

            IngredientRowHeader(showMacros: true)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
              .border(Color.theme.green, width: 0)

            ForEach(mealIngredientMgr.getActive(includeInactive: showInactive)) { mealIngredient in
                NavigationLink(destination: MealEdit(mealIngredient: mealIngredient),
                               label: {
                                   IngredientRow(showMacros: true,
                                                 name: mealIngredient.name,
                                                 calories: mealIngredient.calories,
                                                 fat: mealIngredient.fat,
                                                 fiber: mealIngredient.fiber,
                                                 netcarbs: mealIngredient.netcarbs,
                                                 protein: mealIngredient.protein,
                                                 amount: mealIngredient.amount,
                                                 consumptionUnit: getConsumptionUnit(mealIngredient.name))
                               })
                  .foregroundColor(!mealIngredient.active ? Color.theme.red :
                                    (mealIngredient.adjustment == Constants.Automatic ? Color.theme.manual :
                                       (mealIngredient.adjustment == Constants.Manual ? Color.theme.automatic :
                                          Color.theme.blackWhite)))

                  .swipeActions(edge: .leading) {
                      Button {
                          if mealIngredient.active && mealIngredient.adjustment == Constants.Manual {
                              mealIngredientMgr.undoManualAdjustment(name: mealIngredient.name)
                              print("  Undoing manual adjustment for: \(mealIngredient.name)")
                          } else {
                              mealIngredientMgr.manualAdjustment(name: mealIngredient.name, amount: mealIngredient.amount)
                          }
                          generateMeal()
                      } label: {
                          Label("", systemImage: (mealIngredient.active && mealIngredient.adjustment == Constants.Manual) ? "lock.open" : "lock")
                      }
//                      .tint((!mealIngredientMgr.getByName(name: mealIngredient.name)!.adjustment) == Constants.Manual ? Color.theme.blackWhiteSecondary : Color.theme.red)
                  }


                  .swipeActions(edge: .trailing) {


                      // Activate/Deactivate meal ingredient
                      Button {
                          if mealIngredient.active || ingredientMgr.getByName(name: mealIngredient.name)!.available {
                              let newMealIngredient = mealIngredientMgr.toggleActive(mealIngredient)
                              print("  \(newMealIngredient!.name) active: \(newMealIngredient!.active)")
                          }
                          generateMeal()
                      } label: {
                          Label("", systemImage: !ingredientMgr.getByName(name: mealIngredient.name)!.available ? "circle.slash" : mealIngredient.active ? "pause.circle" : "play.circle")
                      }
                        .tint(!ingredientMgr.getByName(name: mealIngredient.name)!.available ? Color.theme.blackWhiteSecondary : mealIngredient.active ? Color.theme.red : Color.theme.green)


                      // TODO: Do not allow a meal ingredient that is
                      // one of the ingredients in the adjustment list
                      // to be deleted because it'll just get re-added
                      // as a meal ingredient when the meal is
                      // regenerated.
                      Button(role: .destructive) {
                          mealIngredientMgr.delete(mealIngredient)
                          generateMeal()
                      } label: {
                          Label("Delete", systemImage: "trash.fill")
                      }
                  }
            }
              // .onMove(perform: moveAction)
              .onDelete(perform: deleteAction)
              .border(Color.theme.green, width: 0)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        }
          .refreshable {
              generateMeal()
          }
          .environment(\.defaultMinListRowHeight, 5)
          .padding([.leading, .trailing], -20)
          .background(
            NavigationLink(destination: MealConfigure(), isActive: $mealConfigureActive) {
                Label("Configure", systemImage: "gear")
            })
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  EditButton()
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .principal) {
                  HStack {


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


                      // Reset entire set of meal ingredients
                      Button {
                          withAnimation {
                              mealIngredientMgr.resetMealIngredients()
                              generateMeal()
                          }
                      } label: {
                          Image(systemName: "arrow.uturn.backward")
                          // Image(systemName: "arrow.3.trianglepath")
                          // Image(systemName: "arrow.triangle.2.circlepath")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)


                      // Meal Configure
                      Button {
                          mealConfigureActive.toggle()
                          NavigationLink("Add", destination: MealAdd())
                      } label: {
                          Image(systemName: "gear")
                      }
                        .frame(width: 40)
                        .foregroundColor(Color.theme.blueYellow)
                  }
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: MealAdd())
                    .foregroundColor(Color.theme.blueYellow)
              }
          }
          .onAppear {
              generateMeal()
          }
    }


    // func moveAction(from source: IndexSet, to destination: Int) {
    //     mealIngredientMgr.move(from: source, to: destination)
    // }


    func deleteAction(indexSet: IndexSet) {
        mealIngredientMgr.deleteSet(indexSet: indexSet)
    }


    func generateMeal() {

        print("\n\n\nGENERATE MEAL\n================================================================================\n")

        // Attempt to retrieve the body weight and body fat percentage
        // from Health Kit and update the profile if new values are
        // available.
        getBodyWeightAndBodyFatFromHealthKit()

        // Set (or reset) the daily macro goals:
        // - reflects any changes in the manually updated profile
        // - reflects any changes to the automatically updated profile fields
        macrosMgr.setDailyMacroGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberMinimum: profileMgr.profile.fiberMinimum, netCarbsMaximum: profileMgr.profile.netCarbsMaximum, proteinGoal: profileMgr.profile.proteinGoal)

        // Undo all the auto adjustments (so we can reapply them
        // with a clean slate).  Removal will result in:
        // 1. Meal ingredients being deleted that were added as a result of apply adjustments
        // 2. Meal ingredient amounts being set to original values, and deativation
        mealIngredientMgr.undoAutoAdjustments()

        print("\nMeat Adjustments")
        mealIngredientMgr.reapplyMeat(name: profileMgr.profile.meat, amount: profileMgr.profile.meatAmount)
        if profileMgr.profile.meat != "None" {
            let ingredient = ingredientMgr.getByName(name: profileMgr.profile.meat)!
            for mealAdjustment in ingredient.mealAdjustments {
                let mealIngredient = mealIngredientMgr.getByName(name: mealAdjustment.name)!
                if mealIngredient != nil && mealIngredient.active {
                    mealIngredientMgr.automaticAdjustment(name: mealAdjustment.name, amount: mealAdjustment.amount)
                }
            }
        }

        // Initialize the total macros for each meal ingredient and
        // the total macros for all ingredients.  These will all be
        // updated later in this algorithm.
        mealIngredientMgr.setMacroActualsToZero()
        for mealIngredient in mealIngredientMgr.getActive(includeInactive: true) {
            setMacroActualsAndUpdateMealMacroActuals(mealIngredient.name, Double(mealIngredient.amount), mealIngredient.active)
        }

        print("\nAdding Automatic Adjustments")
        var failedCount = 0
        while failedCount < 10 {
            while tryAddingAdjustments() {
                failedCount = 0
            }
            failedCount += 1
        }
    }


    func tryAddingAdjustments() -> Bool {
        for adjustment in getAdjustmentOrder() {
            if tryAddingAdjustment(adjustment) {
                return true
            }
        }
        return false
    }


    // This algorithm is best described by example using an ordered
    // list of adjustments annotated with adjustment groups:
    //
    // adj adj-group
    // a   g1
    // b
    // c   g2
    // d   g1
    // e   g2
    // f   g1
    // g
    //
    // Will produce the following order of adjustments where the items
    // inside the [] are return in a randomized order that may change
    // on each invocation of the algorithm:
    //
    // [a d f]* b [c e]* g
    // * in some random order
    //
    // Thus the following are potential orders returned:
    // f a d b e c g
    // d f a b c e g
    // a d f b c e g
    func getAdjustmentOrder() -> [Adjustment] {
        var adjustmentOrder: [Adjustment] = []
        var adjustmentGroupSeen: [String] = []

        for adjustment in adjustmentMgr.getAll() {

            // If the adjustment is not part of a group add it in the
            // order it was found
            if adjustment.group == "" {
                adjustmentOrder.append(adjustment)
                continue
            }

            // When the first adjustment in an adjustment group is
            // found, all subsequent adjustments in the adjustment
            // group are processed, so ignore them if we see them a
            // second time.
            if adjustmentGroupSeen.contains(adjustment.group) {
                continue
            }

            // All adjustments in the same adjustment group are added
            // to the adjustment order sequentially beginning with the
            // position of the first adjustment in the group, but
            // their order is randomized.
            adjustmentGroupSeen.append(adjustment.group)
            var groupedAdjustments: [Adjustment] = adjustmentMgr.adjustments.filter( { $0.group == adjustment.group })
            for _ in stride(from: groupedAdjustments.count, through: 1, by: -1) {
                let groupedAdjustment = groupedAdjustments.randomElement()
                adjustmentOrder.append(groupedAdjustment!)
                groupedAdjustments = groupedAdjustments.filter( { $0.name != groupedAdjustment!.name })
            }
        }

        return adjustmentOrder
    }


    func tryAddingAdjustment(_ adjustment: Adjustment) -> Bool {

        let mealIngredient = mealIngredientMgr.getByName(name: adjustment.name)


        if mealIngredient != nil && mealIngredient!.adjustment == Constants.Manual {
            return false
        }


        // If the adjustment has constraints, and the new meal
        // ingredient amount with the adjustment applied would exceed
        // the adjustment's maximum constraint for the meal ingredient
        // then the adjustment cannot be applied.
        if mealIngredient != nil && adjustment.constraints {
            if (mealIngredient!.amount + adjustment.amount) > adjustment.maximum {
                return false
            }
        }


        // If the result of applying the adjustment would result in
        // the fat, netCarbs, or protein macros exceeding the daily
        // macro limits then the adjustment cannot be applied.
        let ingredient = ingredientMgr.getByName(name: adjustment.name)!
        let servings = (adjustment.amount * ingredient.consumptionGrams) / ingredient.servingSize

        let fat: Double = Double(ingredient.fat * servings)
        let netCarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        if macrosMgr.macros.fatGoal < macrosMgr.macros.fat + fat ||
             macrosMgr.macros.netCarbsMaximum < macrosMgr.macros.netCarbs + netCarbs ||
             macrosMgr.macros.proteinGoal < macrosMgr.macros.protein + protein {
            return false
        }


        // At this point, the adjustment "fits" and can be applied.
        setMacroActualsAndUpdateMealMacroActuals(adjustment.name, Double(adjustment.amount), true)
        mealIngredientMgr.automaticAdjustment(name: adjustment.name, amount: adjustment.amount)
        return true
    }


    // For a given meal ingredient (specified by name), use the total
    // calories consumed to determine the servings consumed, and then
    // use the servings consumed to calculate the calories and macros
    // for the meal ingredient, and then set those macro values on the
    // meal ingredient.
    //
    // Next, if the meal ingredient is active, add the meal
    // ingredient's macros to the cumulative meal's macros.
    func setMacroActualsAndUpdateMealMacroActuals(_ name: String, _ amount: Double, _ active: Bool) {

        // Determine the number of servings consumed by taking the
        // total grams consumed divided by the grams per serving.
        let ingredient = ingredientMgr.getByName(name: name)!
        let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize

        // Determine the calories and macros by multiplying the
        // calories/macros per serving times the number of servings
        // consumed.
        let calories: Double = Double(ingredient.calories * servings)
        let fat: Double = Double(ingredient.fat * servings)
        let fiber: Double = Double(ingredient.fiber * servings)
        let netcarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        // Update the macro values on the meal ingredient
        mealIngredientMgr.setMacroActuals(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)

        // Add the meal ingredient's macro values to the overall meal actuals
        if active {
            // print("\(name): c: \(calories) f: \(fat) f: \(fiber) n: \(netcarbs) p: \(protein)")
            macrosMgr.addMacroActuals(name: name, calories: calories, fat: fat, fiber: fiber, netCarbs: netcarbs, protein: protein)
        }
    }


    func getBodyWeightAndBodyFatFromHealthKit() {
        HealthStore.authorizeHealthKit { (success, error) in
            guard success else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error)")
                } else {
                    print(baseMessage)
                }
                return
            }

            // print("HealthKit successfully authorized.")
            if profileMgr.profile.bodyMassFromHealthKit {
                getBodyMass()
            }
            if profileMgr.profile.bodyFatPercentageFromHealthKit {
                getBodyFatPercentage()
            }
            getActiveEnergyBurned()
        }
    }


    func getBodyMass() {
        // print("Getting body mass")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass sample type is no longer available in HealthKit")
            return
        }

        HealthStore.getMostRecentSample(sampleType: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let bodyMass = sample.quantity.doubleValue(for: HKUnit.pound())
            print("Weight (healthkit): \(bodyMass)")
            print("Weight (profile): \(profileMgr.profile.bodyMass)")

            if bodyMass != Double(profileMgr.profile.bodyMass) {
                print("Updating body mass...")
                profileMgr.setBodyMass(bodyMass: bodyMass)
            }
        }
    }


    func getBodyFatPercentage() {
        // print("Getting body fat percentage")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) else {
            print("Body Fat Percentage sample type is no longer available in HealthKit")
            return
        }

        HealthStore.getMostRecentSample(sampleType: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let bodyFatPercentage = (sample.quantity.doubleValue(for: HKUnit.percent())) * 100
            print("Body Fat % (health kit): \(bodyFatPercentage)")
            print("Body Fat % (profile): \(profileMgr.profile.bodyFatPercentage)")

            if bodyFatPercentage != Double(profileMgr.profile.bodyFatPercentage) {
                print("Updating body fat percentage...")
                profileMgr.setBodyFatPercentage(bodyFatPercentage: bodyFatPercentage)
            }
        }
    }


    func getActiveEnergyBurned() {
        // print("Getting active energy burned")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Active Energy Burned sample type is no longer available in HealthKit")
            return
        }

        let calendar = Calendar.current
        var startDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        startDateComponents.month = startDateComponents.month! - 1
        let startDate = calendar.date(from: startDateComponents)!

        // let energySampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        // let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)

        // let query = HKSampleQuery(sampleType: energySampleType!, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
        HealthStore.getMostRecentSample(sampleType: sampleType, startDate: startDate) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let activeCaloriesBurned = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
            print("Active energy burned (health kit): \(activeCaloriesBurned)")
            print("Active energy burned (profile): \(profileMgr.profile.activeCaloriesBurned)")

            // TODO: Update once the health kit active calories algorithm is demystified
            // if activeCaloriesBurned != profileMgr.profile.activeCaloriesBurned {
            //     print("Updating active energy burned...")
            //     profileMgr.setActiveEnergyBurned(activeCaloriesBurned: activeCaloriesBurned)
            // }
        }
    }


    func getConsumptionUnit(_ name: String) -> Unit {
        return ingredientMgr.getByName(name: name)!.consumptionUnit
    }
}

//struct MealIngredientList_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MealIngredientList()
//              .environmentObject(MealIngredientMgr())
//        }
//    }
//}
