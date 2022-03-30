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
                Section(header: Text("Meal Dashboard")) {
                    MyGaugeDashboard(profileMgr.profile, macrosMgr.macros)
                }

                Section(header: IngredientRowHeader(showMacros: true)) {
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
                                                         consumptionUnit: mealIngredient.consumptionUnit)
                                       })
                          .foregroundColor(!mealIngredient.active ? Color.red :
                                             (mealIngredient.compensationExists || (mealIngredient.defaultAmount != mealIngredient.amount)) ? Color("Blue") :
                                             Color("Black"))
                          .swipeActions(edge: .trailing) {
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


                              // Button {
                              //     print("Logic")
                              // } label: {
                              //     Label("", systemImage: !ingredientMgr.getIngredient(name: mealIngredient.name)!.available ? "circle.slash" : mealIngredient.active ? "pause.circle" : "play.circle")
                              // }
                              //   .tint(!ingredientMgr.getIngredient(name: mealIngredient.name)!.available ? .gray : mealIngredient.active ? .red : .green)


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
                        .foregroundColor(Color("Blue"))
                  }
                  ToolbarItem(placement: .principal) {
                      HStack {
                          Button {
                              showInactive.toggle()
                              print("  Toggling showInactive: \(showInactive) (mealIngredient)")
                          } label: {
                              Image(systemName: !mealIngredientMgr.inactiveIngredientsExist() ? "" : showInactive ? "eye" : "eye.slash")
                          }
                            .frame(width: 40)
                            .foregroundColor(Color("Blue"))

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
                          }
                            .frame(width: 40)
                            .foregroundColor(Color("Blue"))

                          // Button {
                          //     generateMeal()
                          // } label: {
                          //     Image(systemName: locked ? "" : "arrow.triangle.2.circlepath")
                          // }.frame(width: 40)

                          Button {
                              mealConfigureActive.toggle()
                          } label: {
                              Image(systemName: locked ? "" : "gear")
                          }
                            .frame(width: 40)
                            .foregroundColor(Color("Blue"))
                      }
                  }
                  ToolbarItem(placement: .primaryAction) {
                      NavigationLink("Add", destination: MealAdd())
                        .foregroundColor(Color("Blue"))
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
            macrosMgr.setGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberMinimum: profileMgr.profile.fiberMinimum, netCarbsMaximum: profileMgr.profile.netCarbsMaximum, proteinGoal: profileMgr.profile.proteinGoal)
            for mealIngredient in mealIngredientMgr.get(includeInactive: true) {
                addMacros(mealIngredient.name, Double(mealIngredient.amount), mealIngredient.active)
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
        macrosMgr.setGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberMinimum: profileMgr.profile.fiberMinimum, netCarbsMaximum: profileMgr.profile.netCarbsMaximum, proteinGoal: profileMgr.profile.proteinGoal)

        print("\nBase ingredients")
        // mealIngredientMgr.p()

        print("\nAdding Meat")
        if profileMgr.profile.meat != "None" {
            mealIngredientMgr.adjust(name: profileMgr.profile.meat, amount: profileMgr.profile.meatAmount, consumptionUnit: .gram)
        }

        print("\nApplying Meat Adjustments...")
        applyMealAdjustmentsToMealIngredients()

        for mealIngredient in mealIngredientMgr.get(includeInactive: true) {
            addMacros(mealIngredient.name, Double(mealIngredient.amount), mealIngredient.active)
        }

        while tryAddingAdjustments() {
        }
    }

    func applyMealAdjustmentsToMealIngredients() {
        for mealIngredient in mealIngredientMgr.get() {
            let ingredient = ingredientMgr.getIngredient(name: mealIngredient.name)!
            for meatAdjustment in ingredient.mealAdjustments {
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

        let fat: Double = Double(ingredient.fat * servings)
        let netCarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        if macrosMgr.macros.fatGoal < macrosMgr.macros.fat + Float(fat) ||
            macrosMgr.macros.netCarbsMaximum < macrosMgr.macros.netCarbs + Float(netCarbs) ||
            macrosMgr.macros.proteinGoal < macrosMgr.macros.protein + Float(protein) {
            return false
        }

        addMacros(adjustment.name, Double(adjustment.amount), true)
        mealIngredientMgr.adjust(name: adjustment.name, amount: adjustment.amount, consumptionUnit: adjustment.consumptionUnit)
        return true
    }

    func addMacros(_ name: String, _ amount: Double, _ active: Bool) {
        let ingredient = ingredientMgr.getIngredient(name: name)!
        let servings = (Float(amount) * ingredient.consumptionGrams) / ingredient.servingSize

        let calories: Double = Double(ingredient.calories * servings)
        let fat: Double = Double(ingredient.fat * servings)
        let fiber: Double = Double(ingredient.fiber * servings)
        let netcarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        mealIngredientMgr.addMacros(name: name, calories: Float(calories), fat: Float(fat), fiber: Float(fiber), netcarbs: Float(netcarbs), protein: Float(protein))

        if active {
            macrosMgr.addMacros(name: name, calories: Float(calories), fat: Float(fat), fiber: Float(fiber), netCarbs: Float(netcarbs), protein: Float(protein))
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

            print("HealthKit successfully authorized.")
            getBodyMass()
            getBodyFatPercentage()
            getActiveEnergyBurned()
        }
    }

    func getBodyMass() {
        print("Getting body mass")
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
                profileMgr.setBodyMass(bodyMass: Float(bodyMass))
            }
        }
    }

    func getBodyFatPercentage() {
        print("Getting body fat percentage")
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
                profileMgr.setBodyFatPercentage(bodyFatPercentage: Float(bodyFatPercentage))
            }
        }
    }

    func getActiveEnergyBurned () {
        print("Getting active energy burned")
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

            // if activeCaloriesBurned != profileMgr.profile.activeCaloriesBurned {
            //     print("Updating active energy burned...")
            //     profileMgr.setActiveEnergyBurned(activeCaloriesBurned: activeCaloriesBurned)
            // }
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
