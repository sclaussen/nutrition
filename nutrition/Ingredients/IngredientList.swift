import SwiftUI

struct IngredientList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var deleteMealIngredientAlert = false
    @State var deleteAdjustmentAlert = false

    // Non-nil drives the hidden background NavigationLink that pushes
    // IngredientEdit. Set by tapping the chevron on a row; cleared
    // when the editor screen is dismissed.
    @State private var editIngredient: Ingredient? = nil

    var body: some View {
        List {

            IngredientRowHeader(showMacros: false, showAmount: false)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))

            ForEach(getIngredientList()) { ingredient in
                // Row is split between two hit zones, each wrapped in
                // a Button with .buttonStyle(.borderless) so the List
                // row doesn't lump them into a single tappable unit:
                //   * Name Button — taps toggle the ingredient in/out
                //     of the meal (black <-> green).
                //   * trailing chevron Button — pushes IngredientEdit
                //     via the hidden NavigationLink in .background.
                // Explicit .frame(height: 28) on the HStack keeps the
                // row from collapsing — IngredientRow's inner
                // GeometryReader has no intrinsic height, so without
                // this the row would shrink to chevron-sized.
                HStack(spacing: 0) {
                    Button {
                        promote(ingredient)
                    } label: {
                        // Plain Text uses the full row width instead of
                        // IngredientRow's 39.5% name slot (designed
                        // around macro columns we no longer show).
                        Text(ingredient.name)
                          .font(.callout)
                          .foregroundColor(statusColor(for: ingredient))
                          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                          .contentShape(Rectangle())
                    }
                      .buttonStyle(.borderless)

                    Button {
                        editIngredient = ingredient
                    } label: {
                        Image(systemName: "chevron.right")
                          .font(.caption2)
                          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                          .contentShape(Rectangle())
                    }
                      .buttonStyle(.borderless)
                      .foregroundColor(Color.theme.blackWhiteSecondary)
                      .frame(width: 30)
                }
                  .frame(height: 28)

                  .swipeActions(edge: .trailing) {
                      // Delete from the database entirely.
                      Button(role: .destructive) {
                          delete(ingredient)
                      } label: {
                          Label("Delete", systemImage: "trash.fill")
                      }

                      // Remove from the meal list (back to black /
                      // not-in-meal) without deleting from the
                      // database. Only shown when the ingredient is
                      // actually in the meal. Redundant with the tap-
                      // toggle, but kept as a discoverable affordance.
                      if isInMeal(ingredient) {
                          Button {
                              removeFromMeal(ingredient)
                          } label: {
                              Label("Unlist", systemImage: "minus.circle")
                          }
                            .tint(.red)
                      }
                  }
            }
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
              .border(Color.theme.red, width: 0)
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
              ToolbarItem(placement: .principal) {
                  // Adjustments (formerly its own tab)
                  NavigationLink(destination: AdjustmentList()) {
                      Image(systemName: "slider.horizontal.below.list.bulleted")
                  }
                    .frame(width: 40)
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: IngredientAdd())
                    .foregroundColor(Color.theme.blueYellow)
              }
          }
          // Hidden NavigationLink driven by `editIngredient`. Pattern
          // mirrors MealList's detail navigation — gives us a
          // chevron Button (visible) that pushes IngredientEdit
          // (invisible link) without making the whole list row a
          // single big NavigationLink.
          .background(
              NavigationLink(
                  destination: Group {
                      if let ing = editIngredient {
                          IngredientEdit(ingredient: ing)
                      }
                  },
                  isActive: Binding(
                      get: { editIngredient != nil },
                      set: { if !$0 { editIngredient = nil } }
                  )
              ) {
                  EmptyView()
              }
          )
    }

    func getIngredientList() -> [Ingredient] {
        let ingredients = ingredientMgr.getAll()
        return ingredients
        //        if searchingFor.isEmpty {
        //            return ingredients
        //        }
        //        return ingredients.filter { $0.name.contains(searchingFor) }
    }

    // Two states on the prep page — the ingredient is either in the
    // current meal or it isn't. Active/inactive is the meal page's
    // concern, not this one.
    private func isInMeal(_ ingredient: Ingredient) -> Bool {
        mealIngredientMgr.getByName(name: ingredient.name) != nil
    }


    // Color encoding:
    //   blue                 = meat (managed via Proteins picker, not here)
    //   black (primary text) = not in the meal
    //   green                = in the meal
    private func statusColor(for ingredient: Ingredient) -> Color {
        if ingredient.meat { return Color.theme.blue }
        return isInMeal(ingredient) ? Color.theme.manual : Color.theme.blackWhite
    }


    // Toggle the ingredient in/out of the meal:
    //   black -> green  (added to meal, active: true)
    //   green -> black  (removed from meal)
    //
    // No-op for meats: they're owned by the Proteins picker. The
    // chevron still navigates to IngredientEdit so the meat's data
    // is reachable.
    private func promote(_ ingredient: Ingredient) {
        if ingredient.meat { return }
        if let mi = mealIngredientMgr.getByName(name: ingredient.name) {
            mealIngredientMgr.delete(mi)
        } else {
            mealIngredientMgr.create(name: ingredient.name,
                                     amount: 0,
                                     active: true,
                                     isSupplement: ingredient.supplement)
        }
    }


    private func removeFromMeal(_ ingredient: Ingredient) {
        if let mi = mealIngredientMgr.getByName(name: ingredient.name) {
            mealIngredientMgr.delete(mi)
        }
    }


    func delete(_ ingredient: Ingredient) {
        if let mealIngredient = mealIngredientMgr.getByName(name: ingredient.name) {
            deleteMealIngredientAlert = true
            return
        }
        if let adjustment = adjustmentMgr.getByName(name: ingredient.name) {
            deleteAdjustmentAlert = true
            return
        }
        ingredientMgr.delete(ingredient)
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
