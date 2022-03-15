import SwiftUI

struct MealList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var macrosMgr: MacrosMgr
    @EnvironmentObject var profileMgr: ProfileMgr

    @State var showInactive: Bool = false
    @State var locked: Bool = false
    @State var amount: Double = 0

    var body: some View {

        VStack {

            MyGaugeDashboard(
              caloriesGoalUnadjusted: macrosMgr.macros.caloriesGoalUnadjusted,
              caloriesGoal: macrosMgr.macros.caloriesGoal,
              fatGoal: macrosMgr.macros.fatGoal,
              fiberGoal: macrosMgr.macros.fiberGoal,
              netcarbsGoal: macrosMgr.macros.netcarbsGoal,
              proteinGoal: macrosMgr.macros.proteinGoal,
              calories: macrosMgr.macros.calories,
              fat: macrosMgr.macros.fat,
              fiber: macrosMgr.macros.fiber,
              netcarbs: macrosMgr.macros.netcarbs,
              protein: macrosMgr.macros.protein
            )

            List {
                ForEach(mealIngredientMgr.get(includeInactive: showInactive)) { mealIngredient in
                    NavigationLink(destination: MealEdit(mealIngredient: mealIngredient),
                                   label: {
                                       MealRow(mealIngredient: mealIngredient)
                                   })
                      .foregroundColor(!mealIngredient.active ? Color.red :
                                         (mealIngredient.compensation || (mealIngredient.defaultAmount != mealIngredient.amount)) ? Color.blue :
                                         Color.black)
                      .swipeActions(edge: .leading) {
                          Button {
                              // Toggle the meal ingredient's active state
                              // If the meal ingredient has been toggled to active, propogate that change to the ingredient as well
                              let newMealIngredient = mealIngredientMgr.toggleActive(mealIngredient)
                              if newMealIngredient!.active {
                                  ingredientMgr.activate(newMealIngredient!.name)
                              }
                          } label: {
                              // if mealIngredient.active {
                              //     Label("Deactivate", systemImage: "pause.circle")
                              // } else {
                              //     Label("Activate", systemImage: "play.circle")
                              // }
                              Label("Deactivate", systemImage: mealIngredient.active ? "pause.circle" : "play.circle")
                          }
                            .tint(mealIngredient.active ? .red : .green)
                      }
                      .swipeActions(edge: .trailing) {
                          // TODO: Do not apply a delete to an adjustment item (or it'll just get re-added during generateMeal)
                          Button(role: .destructive) {
                              mealIngredientMgr.delete(mealIngredient)
                          } label: {
                              Label("Delete", systemImage: "trash.fill")
                          }
                      }
                }
                  .onMove(perform: moveAction)
                  .onDelete(perform: deleteAction)
            }
              .environment(\.defaultMinListRowHeight, 5)
              .padding([.leading, .trailing], -20)
              .toolbar {
                  ToolbarItem(placement: .navigation) {
                      EditButton()
                  }
                  ToolbarItem(placement: .principal) {
                      VStack(spacing: 5) {
                          Text("Show Inactive").font(.caption2).foregroundColor(.blue)
                          CheckboxToggle(status: $showInactive).foregroundColor(.blue)
                      }.offset(y: -5)
                  }
                  ToolbarItem(placement: .primaryAction) {
                      HStack {
                          Button {
                              toggleLocked()
                          } label: {
                              Image(systemName: locked ? "lock" : "lock.open")
                          }

                          Button {
                              generateMeal()
                          } label: {
                              Image(systemName: "arrow.triangle.2.circlepath")
                          }

                          NavigationLink(destination: MealConfigure()) {
                              Label("Configure", systemImage: "gear")
                          }
                          NavigationLink("Add", destination: MealAdd())
                      }
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
        print("\n\n\nGENERATE MEAL\n================================================================================\n")
        mealIngredientMgr.p()

        print("Rolling back")
        mealIngredientMgr.rollbackAll()

        print("\nResetting meal ingredient macros")
        // for mealIngredient in mealIngredientMgr.mealIngredients {
        //     mealIngredient.resetMacros()
        // }

        print("\nSetting macro goals")
        macrosMgr.setGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberGoal: profileMgr.profile.fiberGoal, netcarbsGoal: profileMgr.profile.netcarbsGoal, proteinGoal: profileMgr.profile.proteinGoal)

        print("\nAdding Meat")
        if profileMgr.profile.meat != "None" {
            mealIngredientMgr.adjust(name: profileMgr.profile.meat, amount: profileMgr.profile.meatAmount, consumptionUnit: Unit.gram)
        }

        applyMeatAdjustmentsToMealIngredients()
        addMacrosForBaseMealIngredients()
        while tryAddingAdjustments() {
        }
    }

    func applyMeatAdjustmentsToMealIngredients() {
        print("\nApplying Meat Adjustments...")
        for mealIngredient in mealIngredientMgr.get() {
            let ingredient = ingredientMgr.getIngredient(name: mealIngredient.name)!
            for meatAdjustment in ingredient.meatAdjustments {
                mealIngredientMgr.adjust(name: meatAdjustment.name, amount: meatAdjustment.amount, consumptionUnit: meatAdjustment.consumptionUnit)
            }
        }
        print()
    }

    func addMacrosForBaseMealIngredients() {
        print("Updating Macros...")
        for mealIngredient in mealIngredientMgr.get() {
            addMacros(mealIngredient.name, mealIngredient.amount)
        }
        print()
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

        for adjustment in adjustmentMgr.adjustments {

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
            if amountAfterAdjustment < adjustment.minimum || amountAfterAdjustment > adjustment.maximum {
                return false
            }
        }

        let ingredient = ingredientMgr.getIngredient(name: adjustment.name)!
        let servings = (adjustment.amount * ingredient.consumptionGrams) / ingredient.servingSize

        let calories: Double = ingredient.calories * servings
        let fat: Double = ingredient.fat * servings
        let fiber: Double = ingredient.fiber * servings
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

        print("Updated macros: " + name + " \(amount)")
        mealIngredientMgr.addMacros(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
        macrosMgr.addMacros(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)
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


struct CheckboxToggle: View {
    @State var text: String = ""
    @Binding var status: Bool

    var body: some View {
        Toggle(isOn: $status) {
            Text(text)
        }.toggleStyle(CheckboxToggleStyle())
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
          .resizable()
          .frame(width: 20, height: 20)
          .onTapGesture { configuration.isOn.toggle() }
    }
}
