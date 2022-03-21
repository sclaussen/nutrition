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

    // var healthStore: HealthStore = HealthStore()

    var body: some View {
        VStack {
            List {
                Section("Meal Dashboard") {
                    MyGaugeDashboard(caloriesGoalUnadjusted: macrosMgr.macros.caloriesGoalUnadjusted,
                                     caloriesGoal: macrosMgr.macros.caloriesGoal,
                                     fatGoal: macrosMgr.macros.fatGoal,
                                     fiberGoal: macrosMgr.macros.fiberGoal,
                                     netcarbsGoal: macrosMgr.macros.netcarbsGoal,
                                     proteinGoal: macrosMgr.macros.proteinGoal,
                                     calories: macrosMgr.macros.calories,
                                     fat: macrosMgr.macros.fat,
                                     fiber: macrosMgr.macros.fiber,
                                     netcarbs: macrosMgr.macros.netcarbs,
                                     protein: macrosMgr.macros.protein)
                }

                Section(header: IngredientRowHeader(nameWidth: 0.345)) {
                    ForEach(mealIngredientMgr.get(includeInactive: showInactive)) { mealIngredient in
                        NavigationLink(destination: MealEdit(mealIngredient: mealIngredient),
                                       label: {
                                           IngredientRow(nameWidth: 0.325,
                                                         name: mealIngredient.name,
                                                         calories: mealIngredient.calories,
                                                         fat: mealIngredient.fat,
                                                         fiber: mealIngredient.fiber,
                                                         netcarbs: mealIngredient.netcarbs,
                                                         protein: mealIngredient.protein,
                                                         amount: mealIngredient.amount,
                                                         consumptionUnit: mealIngredient.consumptionUnit)
                                       })
                          .foregroundColor(!mealIngredient.active ? Color.red :
                                             (mealIngredient.compensationExists || (mealIngredient.defaultAmount != mealIngredient.amount)) ? Color.blue :
                                             Color.black)
                          .swipeActions(edge: .leading) {
                              Button {
                                  if mealIngredient.active || ingredientMgr.getIngredient(name: mealIngredient.name)!.available {
                                      let newMealIngredient = mealIngredientMgr.toggleActive(mealIngredient)
                                      print("  \(newMealIngredient!.name) active: \(newMealIngredient!.active)")
                                  }
                                  generateMeal()
                              } label: {
                                  Label("", systemImage: !ingredientMgr.getIngredient(name: mealIngredient.name)!.available ? "circle.slash" : mealIngredient.active ? "pause.circle" : "play.circle")
                              }
                                .tint(!ingredientMgr.getIngredient(name: mealIngredient.name)!.available ? .gray : mealIngredient.active ? .red : .green)
                          }
                          .swipeActions(edge: .trailing) {
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
                }
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
                  }
                  ToolbarItem(placement: .principal) {
                      HStack {
                          Button {
                              showInactive.toggle()
                              print("  Toggling showInactive: \(showInactive) (mealIngredient)")
                          } label: {
                              Image(systemName: !mealIngredientMgr.inactiveIngredientsExist() ? "" : showInactive ? "eye" : "eye.slash")
                          }.frame(width: 40)

                          Button {
                              locked.toggle()
                              if !locked {
                                  for mealIngredient in mealIngredientMgr.get() {
                                      if !mealIngredient.compensationExists {
                                          mealIngredientMgr.resetAmount(name: mealIngredient.name)
                                      }
                                  }
                                  generateMeal()
                              }
                          } label: {
                              Image(systemName: locked ? "lock" : "lock.open")
                          }.frame(width: 40)

                          Button {
                              generateMeal()
                          } label: {
                              Image(systemName: locked ? "" : "arrow.triangle.2.circlepath")
                          }.frame(width: 40)

                          Button {
                              mealConfigureActive.toggle()
                          } label: {
                              Image(systemName: locked ? "" : "gear")
                          }.frame(width: 40)
                      }
                  }
                  ToolbarItem(placement: .primaryAction) {
                      NavigationLink("Add", destination: MealAdd())
                  }
              }
              .onAppear {
                  generateMeal()
              }
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
        getHealthKitData()

        print("\n\n\nGENERATE MEAL\n================================================================================\n")

        if locked {
            mealIngredientMgr.resetMacros()
            macrosMgr.setGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberGoal: profileMgr.profile.fiberGoal, netcarbsGoal: profileMgr.profile.netcarbsGoal, proteinGoal: profileMgr.profile.proteinGoal)
            for mealIngredient in mealIngredientMgr.get() {
                addMacros(mealIngredient.name, mealIngredient.amount)
            }
            // mealIngredientMgr.p()
            return
        }

        print("Old ingredients")
        // mealIngredientMgr.p()

        print("Rolling back")
        mealIngredientMgr.rollbackAll()

        print("\nResetting meal ingredient macros")
        mealIngredientMgr.resetMacros()

        print("\nSetting macro goals")
        macrosMgr.setGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberGoal: profileMgr.profile.fiberGoal, netcarbsGoal: profileMgr.profile.netcarbsGoal, proteinGoal: profileMgr.profile.proteinGoal)

        print("\nBase ingredients")
        // mealIngredientMgr.p()

        print("\nAdding Meat")
        if profileMgr.profile.meat != "None" {
            mealIngredientMgr.adjust(name: profileMgr.profile.meat, amount: profileMgr.profile.meatAmount, consumptionUnit: Unit.gram)
        }

        print("\nApplying Meat Adjustments...")
        applyMeatAdjustmentsToMealIngredients()

        for mealIngredient in mealIngredientMgr.get() {
            addMacros(mealIngredient.name, mealIngredient.amount)
        }

        while tryAddingAdjustments() {
        }
    }

    func applyMeatAdjustmentsToMealIngredients() {
        for mealIngredient in mealIngredientMgr.get() {
            let ingredient = ingredientMgr.getIngredient(name: mealIngredient.name)!
            for meatAdjustment in ingredient.meatAdjustments {
                mealIngredientMgr.adjust(name: meatAdjustment.name, amount: meatAdjustment.amount, consumptionUnit: meatAdjustment.consumptionUnit)
            }
        }
    }

    func tryAddingAdjustments() -> Bool {
        // print("\nTrying...")
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

        // print("  Trying \(adjustment.name) \(adjustment.amount) \(adjustment.active)...")

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

        let fat: Double = ingredient.fat * servings
        let netcarbs: Double = ingredient.netcarbs * servings
        let protein: Double = ingredient.protein * servings

        if macrosMgr.macros.fatGoal < macrosMgr.macros.fat + fat ||
             macrosMgr.macros.netcarbsGoal < macrosMgr.macros.netcarbs + netcarbs ||
             macrosMgr.macros.proteinGoal < macrosMgr.macros.protein + protein {
            return false
        }

        addMacros(adjustment.name, adjustment.amount)
        mealIngredientMgr.adjust(name: adjustment.name, amount: adjustment.amount, consumptionUnit: adjustment.consumptionUnit)
        return true
    }

    func addMacros(_ name: String, _ amount: Double) {
        let ingredient = ingredientMgr.getIngredient(name: name)!
        let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize

        let calories: Double = ingredient.calories * servings
        let fat: Double = ingredient.fat * servings
        let fiber: Double = ingredient.fiber * servings
        let netcarbs: Double = ingredient.netcarbs * servings
        let protein: Double = ingredient.protein * servings

        mealIngredientMgr.addMacros(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
        macrosMgr.addMacros(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
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

            print("HealthKit successfully authorized.")
            getBodyMass()
            getBodyFatPercentage()
        }
    }

    func getBodyMass() {
        print("Getting body mass")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }

        HealthStore.getMostRecentSample(for: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let bodyMass = sample.quantity.doubleValue(for: HKUnit.pound())
            print("Weight (healthkit): \(bodyMass)")
            print("Weight (profile): \(profileMgr.profile.bodyMass)")

            if bodyMass != profileMgr.profile.bodyMass {
                print("Updating body mass...")
                profileMgr.setBodyMass(bodyMass: bodyMass)
            }
        }
    }

    func getBodyFatPercentage() {
        print("Getting body fat percentage")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) else {
            print("Body Fat Percentage Sample Type is no longer available in HealthKit")
            return
        }

        HealthStore.getMostRecentSample(for: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let bodyFatPercentage = (sample.quantity.doubleValue(for: HKUnit.percent())) * 100
            print("Body Fat % (health kit): \(bodyFatPercentage)")
            print("Body Fat % (profile): \(profileMgr.profile.bodyFatPercentage)")

            if bodyFatPercentage != profileMgr.profile.bodyFatPercentage {
                print("Updating body fat percentage...")
                profileMgr.setBodyFatPercentage(bodyFatPercentage: bodyFatPercentage)
            }
        }
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
