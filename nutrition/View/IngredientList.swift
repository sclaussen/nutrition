import SwiftUI


struct IngredientList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var baseMgr: BaseMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr

    @State var searchingFor = ""

    @State var inactiveIngredientsFilter: Bool = false

    var body: some View {
        List {
            ForEach(getIngredientList()) { ingredient in
                NavigationLink(destination: IngredientEdit(ingredient: ingredient),
                               label: {
                                   HStack {
                                       Image(ingredient.name)
                                         .resizable()
                                         .aspectRatio(contentMode: .fit)
//                                         .clipShape(Circle())
                                         .frame(maxWidth: 50)
//                                         .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 3))
                                       Text(ingredient.name).myNameLabel()
                                       Spacer()
                                       Text("\(ingredient.fat100.fractionDigits(max: 0))").font(.caption).frame(width: 30).background(Color.green.opacity(0.4)).opacity(0.8).foregroundColor(.black).cornerRadius(30)
                                       Text("\(ingredient.netcarbs100.fractionDigits(max: 0))").font(.caption).frame(width: 30).background(Color.green.opacity(0.4)).opacity(0.8).foregroundColor(.black).cornerRadius(30)
                                       Text("\(ingredient.protein100.fractionDigits(max: 0))").font(.caption).frame(width: 30).background(Color.green.opacity(0.4)).opacity(0.8).foregroundColor(.black).cornerRadius(30)
                                   }.frame(height: 50)
                               })
                  .foregroundColor(!ingredient.active ? .red : .black)
                  .swipeActions(edge: .leading) {
                      Button {
                          print("Ingredient active: " + String(ingredient.active))
                          let newIngredient = ingredientMgr.toggleActive(ingredient)
                          print("Ingredient active (post): " + String(newIngredient!.active))
                          if !newIngredient!.active {
                              baseMgr.deactivate(ingredient.name)
                              adjustmentMgr.deactivate(ingredient.name)
                          }
                      } label: {
                          if ingredient.active {
                              Label("Deactivate", systemImage: "pause.circle")
                          } else {
                              Label("Activate", systemImage: "play.circle")
                          }
                      }
                        .tint(ingredient.active ? .red : .green)
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
          .searchable(text: $searchingFor)
          .padding([.leading, .trailing], -20)
          .toolbar {
              ToolbarItem(placement: .navigation) {
                  EditButton()
              }
              ToolbarItem(placement: .principal) {
                  Button(action: toggleInactiveIngredientsFilter) {
                      Text(ingredientMgr.inactiveIngredientsExist() ? (inactiveIngredientsFilter ? "Hide Inactive" : "Show Inactive"): "").font(.caption)
                  }
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: IngredientAdd())
              }
          }
    }

    func getIngredientList() -> [Ingredient] {
        let ingredients = ingredientMgr.get(includeInactive: inactiveIngredientsFilter)
        if searchingFor.isEmpty {
            return ingredients
        }
        return ingredients.filter { $0.name.contains(searchingFor) }
    }

    func toggleInactiveIngredientsFilter() {
        inactiveIngredientsFilter = inactiveIngredientsFilter ? false : true
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
