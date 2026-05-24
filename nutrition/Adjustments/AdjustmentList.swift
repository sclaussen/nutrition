import SwiftUI


struct AdjustmentList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var foodMgr: FoodMgr

    @State var showInactive: Bool = false


    var body: some View {
        List {
            IngredientRowHeader(showGroup: true)
              .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))

            ForEach(adjustmentMgr.getAll(includeInactive: showInactive)) { adjustment in
                NavigationLink(destination: AdjustmentEdit(adjustment: adjustment),
                               label: {
                                   IngredientRow(showGroup: true,
                                                 name: adjustment.name,
                                                 group: adjustment.group,
                                                 amount: adjustment.amount,
                                                 consumptionUnit: getConsumptionUnit(adjustment.name))
                               })
                  .foregroundColor(adjustment.active ? Color.theme.blackWhite : Color.theme.red)
                  .swipeActions(edge: .leading) {
                      Button {
                          let newAdjustment = adjustmentMgr.toggleActive(adjustment)
                          print("  \(newAdjustment!.name) active: \(newAdjustment!.active)")
                      } label: {
                          Label("", systemImage: adjustment.active ? "pause.circle" : "play.circle")
                      }
                        .tint(adjustment.active ? Color.theme.red : Color.theme.green)
                  }
                  .swipeActions(edge: .trailing) {
                      Button(role: .destructive) {
                          adjustmentMgr.delete(adjustment)
                      } label: {
                          Label("Delete", systemImage: "trash.fill")
                      }
                  }
            }
              .onMove(perform: moveAction)
              .onDelete(perform: deleteAction)
              .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
              .border(Color.theme.red, width: 0)
        }
          .environment(\.defaultMinListRowHeight, 5)
          .padding([.leading, .trailing], -20)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  EditButton()
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .principal) {
                  Button {
                      showInactive.toggle()
                      print("  Toggling showInactive: \(showInactive) (adjustment)")
                  } label: {
                      Image(systemName: !adjustmentMgr.inactiveIngredientsExist() ? "" : showInactive ? "eye" : "eye.slash")
                  }
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: AdjustmentAdd())
                    .foregroundColor(Color.theme.blueYellow)
              }
          }
    }


    func moveAction(from source: IndexSet, to destination: Int) {
        adjustmentMgr.move(from: source, to: destination)
    }


    func deleteAction(indexSet: IndexSet) {
        adjustmentMgr.deleteSet(indexSet: indexSet)
    }


    // `name` is a Food name (an adjustment targets a Food). Resolve
    // it to the Food's current member and read the Food-level unit
    // via FoodMgr. Falls back to a same-named plain ingredient, then
    // .gram — never force-unwraps (the bare canonical ingredients
    // that used to back Food names no longer exist).
    func getConsumptionUnit(_ name: String) -> Unit {
        if let f = foodMgr.getByName(name: name),
           let ing = ingredientMgr.getByName(name: f.currentIngredientName) {
            return foodMgr.consumptionUnit(for: ing)
        }
        if let ing = ingredientMgr.getByName(name: name) {
            return foodMgr.consumptionUnit(for: ing)
        }
        return .gram
    }
}


struct AdjustmentList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdjustmentList()
              .environmentObject(AdjustmentMgr(profileId: "preview"))
        }
    }
}
