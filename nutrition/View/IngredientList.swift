import SwiftUI

struct IngredientList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var showUnavailable: Bool = false
    @State var deleteMealIngredientAlert = false
    @State var deleteAdjustmentAlert = false

    var body: some View {
        List {

            IngredientRowHeader(showMacros: true)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))

            ForEach(getIngredientList()) { ingredient in
                NavigationLink(destination: IngredientEdit(ingredient: ingredient),
                               label: {
                                   IngredientRow(showMacros: true,
                                                 name: ingredient.name,
                                                 calories: ingredient.calories,
                                                 fat: ingredient.fat100,
                                                 fiber: ingredient.fiber100,
                                                 netcarbs: ingredient.netCarbs100,
                                                 protein: ingredient.protein100,
                                                 amount: 100.0 / ingredient.consumptionGrams,
                                                 consumptionUnit: ingredient.consumptionUnit)
                               })
                  .foregroundColor(ingredient.available ? Color("Black") : Color("Red"))
                  .swipeActions(edge: .leading) {

                      // Availalbe/Unavailble toggle
                      Button {
                          let newIngredient = ingredientMgr.toggleAvailable(ingredient)
                          if newIngredient!.available {
                              mealIngredientMgr.activate(ingredient.name)
                              adjustmentMgr.activate(ingredient.name)
                          } else {
                              mealIngredientMgr.deactivate(ingredient.name)
                              adjustmentMgr.deactivate(ingredient.name)
                          }
                      } label: {
                          if ingredient.available {
                              Label("Unavailable", systemImage: "pause.circle")
                          } else {
                              Label("Available", systemImage: "play.circle")
                          }
                      }
                        .tint(ingredient.available ? .red : .green)
                  }
                  .swipeActions(edge: .trailing) {
                      // Delete
                      Button(role: .destructive) {
                          delete(ingredient)

                      } label: {
                          Label("Delete", systemImage: "trash.fill")
                      }
                  }
            }
              .onMove(perform: moveAction)
              .onDelete(perform: deleteAction)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
              .border(Color.red, width: 0)
        }
          .alert("The meal ingredient must be deleted first.  It may be necessary to lock the meal ingredients prior to deletion so the meal ingredient is not readded as an adjustment.", isPresented: $deleteMealIngredientAlert) {
              Button("OK", role: .cancel) { }
          }
          .alert("The adjustment ingredient must be deleted first.", isPresented: $deleteAdjustmentAlert) {
              Button("OK", role: .cancel) { }
          }
          .environment(\.defaultMinListRowHeight, 5)
          .padding([.leading, .trailing], -20)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  EditButton()
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItem(placement: .principal) {
                  Button {
                      showUnavailable.toggle()
                      print("  Toggling showUnavailable: \(showUnavailable) (ingredient)")
                  } label: {
                      Image(systemName: !ingredientMgr.unavailableIngredientsExist() ? "" : showUnavailable ? "eye" : "eye.slash")
                  }
                    .foregroundColor(Color("Blue"))
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: IngredientAdd())
                    .foregroundColor(Color("Blue"))
              }
          }
    }

    func getIngredientList() -> [Ingredient] {
        let ingredients = ingredientMgr.get(includeUnavailable: showUnavailable)
        return ingredients
        //        if searchingFor.isEmpty {
        //            return ingredients
        //        }
        //        return ingredients.filter { $0.name.contains(searchingFor) }
    }

    func moveAction(from source: IndexSet, to destination: Int) {
        ingredientMgr.move(from: source, to: destination)
    }

    func delete(_ ingredient: Ingredient) {
        if let mealIngredient = mealIngredientMgr.getIngredient(name: ingredient.name) {
            deleteMealIngredientAlert = true
            return
        }
        if let adjustment = adjustmentMgr.getIngredient(name: ingredient.name) {
            deleteAdjustmentAlert = true
            return
        }
        ingredientMgr.delete(ingredient)
    }

     func deleteAction(indexSet: IndexSet) {
         for index in indexSet {
             let ingredient = ingredientMgr.ingredients[index]
             if let mealIngredient = mealIngredientMgr.getIngredient(name: ingredient.name) {
                 return
             }
             // if let adjustment = adjustmentMgr.getIngredient(name: ingredient.name) {
             //     adjustmentMgr.delete(adjustment)
             // }
             print(ingredient.name)
         }
        // ingredientMgr.deleteSet(indexSet: indexSet)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientList()
              .environmentObject(IngredientMgr())
        }
    }
}
