import SwiftUI
import HealthKit

struct MealList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var macrosMgr: MacrosMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    @State var showInactive: Bool = false
    @State var locked: Bool = false
    @State var amount: Double = 0
    @State var mealConfigureActive = false

    // Use cases:
    // - Deactivate a meal ingredient because it's out that will be auto-adjusted
    // - Change the default value of a meal ingredient staple - would like an auto-reset to the default value once meal is done
    // - Add meal ingredient when locked vs not locked
    //
    // Actions:
    // - Unlocking will compensate any auto-adjusted ingredient and reset the value of any manually updated amount
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

            ForEach(mealIngredientMgr.get(includeInactive: showInactive)) { mealIngredient in
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
                                     (mealIngredient.compensationExists || (mealIngredient.defaultAmount != mealIngredient.amount)) ? Color.theme.blueYellow :
                                     Color.theme.blackWhite)
                  .swipeActions(edge: .trailing) {



                      // Activate/Deactivate meal ingredient
                      Button {
                          if mealIngredient.active || ingredientMgr.getIngredient(name: mealIngredient.name)!.available {
                              let newMealIngredient = mealIngredientMgr.toggleActive(mealIngredient)
                              print("  \(newMealIngredient!.name) active: \(newMealIngredient!.active)")
                          }
                          generateMeal()
                      } label: {
                          Label("", systemImage: !ingredientMgr.getIngredient(name: mealIngredient.name)!.available ? "circle.slash" : mealIngredient.active ? "pause.circle" : "play.circle")
                      }
                        .tint(!ingredientMgr.getIngredient(name: mealIngredient.name)!.available ? Color.theme.blackWhiteSecondary : mealIngredient.active ? Color.theme.red : Color.theme.green)



                      // TODO: Do not apply a delete to an adjustment item (or it'll just get re-added during generateMeal)
                      Button(role: .destructive) {
                          mealIngredientMgr.delete(mealIngredient)
                          generateMeal()
                      } label: {
                          Label("Delete", systemImage: "trash.fill")
                      }
                  }
            }
              .onMove(perform: moveAction)
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


                      // Locked Toggle
                      Button {
                          withAnimation {
                              locked.toggle()
                              if !locked {
                                  mealIngredientMgr.rollbackAll()
                                  mealIngredientMgr.resetAmountAll()
                                  generateMeal()
                              }
                          }
                      } label: {
                          Image(systemName: locked ? "lock" : "lock.open")
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

    func toggleLocked() {
        locked = !locked
    }

    func moveAction(from source: IndexSet, to destination: Int) {
        mealIngredientMgr.move(from: source, to: destination)
    }

    func deleteAction(indexSet: IndexSet) {
        mealIngredientMgr.deleteSet(indexSet: indexSet)
    }



    func generateMeal() {

        print("\n\n\nGENERATE MEAL\n================================================================================\n")

        // Attempt to retrieve the body weight and body fat percentage
        // from Health Kit and update the profile if new values are
        // available.
        getHealthKitData()

        if locked {
            macrosMgr.setMacroGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberMinimum: profileMgr.profile.fiberMinimum, netCarbsMaximum: profileMgr.profile.netCarbsMaximum, proteinGoal: profileMgr.profile.proteinGoal)
            mealIngredientMgr.setMacroActualsToZero()
            for mealIngredient in mealIngredientMgr.get(includeInactive: true) {
                setMacroActuals(mealIngredient.name, Double(mealIngredient.amount), mealIngredient.active)
            }
            return
        }

        print("\nRolling back")
        mealIngredientMgr.rollbackAll()
        macrosMgr.setMacroGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberMinimum: profileMgr.profile.fiberMinimum, netCarbsMaximum: profileMgr.profile.netCarbsMaximum, proteinGoal: profileMgr.profile.proteinGoal)
        mealIngredientMgr.setMacroActualsToZero()

        if profileMgr.profile.meat != "None" {
            print("\nAdding Meat")
            mealIngredientMgr.autoAdjustAmount(name: profileMgr.profile.meat, amount: profileMgr.profile.meatAmount)
            print("\nApplying Meat Adjustments...")
            applyMealAdjustmentsToMealIngredients()
        }

        for mealIngredient in mealIngredientMgr.get(includeInactive: true) {
            setMacroActuals(mealIngredient.name, Double(mealIngredient.amount), mealIngredient.active)
        }

        print("\nAdding Adjustments")
        while tryAddingAdjustments() {
        }
    }

    func applyMealAdjustmentsToMealIngredients() {
        for mealIngredient in mealIngredientMgr.get() {
            let ingredient = ingredientMgr.getIngredient(name: mealIngredient.name)!
            for meatAdjustment in ingredient.mealAdjustments {
                mealIngredientMgr.autoAdjustAmount(name: meatAdjustment.name, amount: meatAdjustment.amount)
            }
        }
    }

    func tryAddingAdjustments() -> Bool {
        for adjustment in getRandomizedOrder() {
            if tryAddingAdjustment(adjustment) {
                return true
            }
        }
        return false
    }

    func getRandomizedOrder() -> [Adjustment] {
        var randomizedOrder: [Adjustment] = []
        var groupsSeen: [String] = []

        for adjustment in adjustmentMgr.get() {

            if adjustment.group == "" {
                randomizedOrder.append(adjustment)
                continue
            }

            if groupsSeen.contains(adjustment.group) {
                continue
            }

            groupsSeen.append(adjustment.group)

            var groupedAdjustments: [Adjustment] = adjustmentMgr.adjustments.filter( { $0.group == adjustment.group })
            for _ in stride(from: groupedAdjustments.count, through: 1, by: -1) {
                let groupedAdjustment = groupedAdjustments.randomElement()
                randomizedOrder.append(groupedAdjustment!)
                groupedAdjustments = groupedAdjustments.filter( {$0.name != groupedAdjustment!.name })
            }
        }

        return randomizedOrder
    }

    func tryAddingAdjustment(_ adjustment: Adjustment) -> Bool {

        // Determine if adding the adjustment would break the constraints
        let mealIngredient = mealIngredientMgr.getIngredient(name: adjustment.name)
        if mealIngredient != nil && adjustment.constraints {
            let amountAfterAdjustment = mealIngredient!.amount + adjustment.amount
            if amountAfterAdjustment > adjustment.maximum {
                return false
            }
        }

        let ingredient = ingredientMgr.getIngredient(name: adjustment.name)!
        let servings = (adjustment.amount * ingredient.consumptionGrams) / ingredient.servingSize

        let fat: Double = Double(ingredient.fat * servings)
        let netCarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        if macrosMgr.macros.fatGoal < macrosMgr.macros.fat + fat ||
             macrosMgr.macros.netCarbsMaximum < macrosMgr.macros.netCarbs + netCarbs ||
             macrosMgr.macros.proteinGoal < macrosMgr.macros.protein + protein {
            return false
        }

        setMacroActuals(adjustment.name, Double(adjustment.amount), true)
        mealIngredientMgr.autoAdjustAmount(name: adjustment.name, amount: adjustment.amount)
        return true
    }

    func setMacroActuals(_ name: String, _ amount: Double, _ active: Bool) {
        let ingredient = ingredientMgr.getIngredient(name: name)!
        let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize

        let calories: Double = Double(ingredient.calories * servings)
        let fat: Double = Double(ingredient.fat * servings)
        let fiber: Double = Double(ingredient.fiber * servings)
        let netcarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        // Update the macro values on the meal ingredient
        mealIngredientMgr.setMacroActuals(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)

        // Add the meal ingredient's macro values to the overall meal actuals
        if active {
            macrosMgr.addMacroActuals(name: name, calories: calories, fat: fat, fiber: fiber, netCarbs: netcarbs, protein: protein)
        }
    }

    func getHealthKitData() {
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

    func getActiveEnergyBurned () {
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
        return ingredientMgr.getIngredient(name: name)!.consumptionUnit
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
