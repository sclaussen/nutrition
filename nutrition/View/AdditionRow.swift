import SwiftUI

struct AdditionRow: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr

    @State var addition: Addition

    var body: some View {
        DoubleField(addition.name, $addition.amount, ingredientMgr.getIngredient(name: addition.name).consumptionUnit, view: true)
    }
}
