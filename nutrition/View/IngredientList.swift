import SwiftUI

struct IngredientList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var showUnavailable: Bool = false

    var body: some View {
        VStack {
            List {
                Section(header: IngredientRowHeader(nameWidth: 0.345)) {
                    ForEach(getIngredientList()) { ingredient in
                        NavigationLink(destination: IngredientEdit(ingredient: ingredient),
                                       label: {
                                           IngredientRow(nameWidth: 0.325,
                                                         name: ingredient.name,
                                                         calories: ingredient.calories,
                                                         fat: ingredient.fat100,
                                                         fiber: ingredient.fiber100,
                                                         netcarbs: ingredient.netcarbs100,
                                                         protein: ingredient.protein100,
                                                         amount: 100.0 / ingredient.consumptionGrams,
                                                         consumptionUnit: ingredient.consumptionUnit)
                                       })
                          .foregroundColor(ingredient.available ? .black : .red)
                          .swipeActions(edge: .leading) {
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
                                      Label("Deactivate", systemImage: "pause.circle")
                                  } else {
                                      Label("Activate", systemImage: "play.circle")
                                  }
                              }
                                .tint(ingredient.available ? .red : .green)
                          }
                          .swipeActions(edge: .trailing) {
                              Button(role: .destructive) {
                                  ingredientMgr.delete(ingredient)
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
              .toolbar {
                  ToolbarItem(placement: .navigation) {
                      EditButton()
                  }
                  ToolbarItem(placement: .principal) {
                      Button {
                          showUnavailable.toggle()
                          print("  Toggling showUnavailable: \(showUnavailable) (ingredient)")
                      } label: {
                          Image(systemName: !ingredientMgr.unavailableIngredientsExist() ? "" : showUnavailable ? "eye" : "eye.slash")
                      }
                  }
                  ToolbarItem(placement: .primaryAction) {
                      NavigationLink("Add", destination: IngredientAdd())
                  }
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

    func deleteAction(indexSet: IndexSet) {
        ingredientMgr.deleteSet(indexSet: indexSet)
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
