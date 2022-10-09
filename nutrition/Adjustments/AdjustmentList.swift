import SwiftUI


struct AdjustmentList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

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
                          if adjustment.active || ingredientMgr.getByName(name: adjustment.name)!.available {
                              let newAdjustment = adjustmentMgr.toggleActive(adjustment)
                              print("  \(newAdjustment!.name) active: \(newAdjustment!.active)")
                          }
                      } label: {
                          Label("", systemImage: !ingredientMgr.getByName(name: adjustment.name)!.available ? "circle.slash" : adjustment.active ? "pause.circle" : "play.circle")
                      }
                        .tint(!ingredientMgr.getByName(name: adjustment.name)!.available ? Color.theme.blackWhiteSecondary : adjustment.active ? Color.theme.red : Color.theme.green)
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


    func getConsumptionUnit(_ name: String) -> Unit {
        return ingredientMgr.getByName(name: name)!.consumptionUnit
    }
}


struct AdjustmentList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdjustmentList()
              .environmentObject(AdjustmentMgr())
        }
    }
}
