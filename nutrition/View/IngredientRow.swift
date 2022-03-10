import SwiftUI

struct IngredientRow: View {

    @State var ingredient: Ingredient

    var body: some View {
        HStack {
            if ingredient.active {
                Image(systemName: "checkmark.circle")
                  .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.circle")
                  .foregroundColor(.red)
            }
            Text(ingredient.name)
        }
    }
}

//struct IngredientRow_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientRow(ingredient: Ingredient(name: "Chicken", servingSize: 200, calories: 180, fat: 2, fiber: 1, netcarbs: 0.5, protein: 10, consumptionUnit: Unit.Gram.rawValue, consumptionGrams: 100))
//    }
//}
