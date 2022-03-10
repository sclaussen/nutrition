import SwiftUI

struct AdjustmentList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var inactiveIngredientsFilter: Bool = false

    var body: some View {
        List {
            ForEach(adjustmentMgr.get(includeInactive: inactiveIngredientsFilter)) { adjustment in
                NavigationLink(destination: AdjustmentEdit(adjustment: adjustment),
                               label: {
                                   HStack {
                                       Image(adjustment.name).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 50)
                                       DoubleView(adjustment.name, adjustment.amount, adjustment.consumptionUnit)
                                   }.frame(height: 50)
                               })
                  .foregroundColor(adjustment.active ? Color.black : Color.red)
                  .swipeActions(edge: .leading) {
                      Button {
                          let newAdjustment = adjustmentMgr.toggleActive(adjustment)
                          if newAdjustment!.active {
                              ingredientMgr.activate(newAdjustment!.name)
                          }

                      } label: {
                          if adjustment.active {
                              Label("Deactivate", systemImage: "pause.circle")
                          } else {
                              Label("Activate", systemImage: "play.circle")
                          }
                      }
                        .tint(adjustment.active ? .red : .green)
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
          .padding([.leading, .trailing], -20)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  edit
              }
              ToolbarItem(placement: .principal) {
                  toggle
              }
              ToolbarItem(placement: .primaryAction) {
                  add
              }
          }
    }

    var edit: some View {
        EditButton()
    }

    var toggle: some View {
        Button(action: toggleInactiveIngredientsFilter) {
            Text(adjustmentMgr.inactiveIngredientsExist() ? (inactiveIngredientsFilter ? "Hide Inactive" : "Show Inactive"): "").font(.caption)
        }
    }

    var add: some View {
        NavigationLink("Add", destination: AdjustmentAdd())
    }

    func toggleInactiveIngredientsFilter() {
        inactiveIngredientsFilter = inactiveIngredientsFilter ? false : true
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
