import SwiftUI

struct AdjustmentList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var showInactive: Bool = false

    var body: some View {
        VStack {
            List {
                Section(header: IngredientRowHeader(showGroup: true)) {
                    ForEach(adjustmentMgr.get(includeInactive: showInactive)) { adjustment in
                        NavigationLink(destination: AdjustmentEdit(adjustment: adjustment),
                                       label: {
                                           IngredientRow(showGroup: true,
                                                         name: adjustment.name,
                                                         group: adjustment.group,
                                                         amount: adjustment.amount,
                                                         consumptionUnit: adjustment.consumptionUnit)
                                       })
                          .foregroundColor(adjustment.active ? Color.black : Color.red)
                          .swipeActions(edge: .leading) {
                              Button {
                                  if adjustment.active || ingredientMgr.getIngredient(name: adjustment.name)!.available {
                                      let newAdjustment = adjustmentMgr.toggleActive(adjustment)
                                      print("  \(newAdjustment!.name) active: \(newAdjustment!.active)")
                                  }
                              } label: {
                                  Label("", systemImage: !ingredientMgr.getIngredient(name: adjustment.name)!.available ? "circle.slash" : adjustment.active ? "pause.circle" : "play.circle")
                              }
                                .tint(!ingredientMgr.getIngredient(name: adjustment.name)!.available ? .gray : adjustment.active ? .red : .green)
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
                          showInactive.toggle()
                          print("  Toggling showInactive: \(showInactive) (adjustment)")
                      } label: {
                          Image(systemName: !adjustmentMgr.inactiveIngredientsExist() ? "" : showInactive ? "eye" : "eye.slash")
                      }
                  }
                  ToolbarItem(placement: .primaryAction) {
                      NavigationLink("Add", destination: AdjustmentAdd())
                  }
              }
        }
    }

    func moveAction(from source: IndexSet, to destination: Int) {
        adjustmentMgr.move(from: source, to: destination)
    }

    func deleteAction(indexSet: IndexSet) {
        adjustmentMgr.deleteSet(indexSet: indexSet)
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
