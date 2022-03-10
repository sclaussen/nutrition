import SwiftUI

struct BaseList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var baseMgr: BaseMgr

    @State var inactiveIngredientsFilter: Bool = false
    @State var amount: Double = 0

    var body: some View {
        List {
            ForEach(baseMgr.get(includeInactive: inactiveIngredientsFilter)) { base in
                NavigationLink(destination: BaseEdit(base: base),
                               label: {
                                   HStack {
                                       Image(base.name).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 50)
                                       DoubleView(base.name, base.amount, base.consumptionUnit)
                                   }.frame(height: 50)
                               })
                  .foregroundColor(base.defaultAmount == base.amount && base.active ? .black : (!base.active ? .red : .blue))
                  .swipeActions(edge: .leading) {
                      Button {
                          let newBase = baseMgr.toggleActive(base)
                          if newBase!.active {
                              ingredientMgr.activate(newBase!.name)
                          }
                      } label: {
                          if base.active {
                              Label("Deactivate", systemImage: "pause.circle")
                          } else {
                              Label("Activate", systemImage: "play.circle")
                          }
                      }
                        .tint(base.active ? .red : .green)
                  }
                  .swipeActions(edge: .trailing) {
                      Button(role: .destructive) {
                          baseMgr.delete(base)
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
                  EditButton()
              }
              ToolbarItem(placement: .principal) {
                  Button(action: toggleInactiveIngredientsFilter) {
                      Text(baseMgr.inactiveIngredientsExist() ? (inactiveIngredientsFilter ? "Hide Inactive" : "Show Inactive"): "").font(.caption)
                  }
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: BaseAdd())
              }
          }
    }

    func toggleInactiveIngredientsFilter() {
        inactiveIngredientsFilter = inactiveIngredientsFilter ? false : true
    }

    func moveAction(from source: IndexSet, to destination: Int) {
        baseMgr.move(from: source, to: destination)
    }

    func deleteAction(indexSet: IndexSet) {
        baseMgr.deleteSet(indexSet: indexSet)
    }
}

struct BaseList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BaseList()
              .environmentObject(BaseMgr())
        }
    }
}
