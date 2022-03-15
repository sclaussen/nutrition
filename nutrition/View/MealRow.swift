import SwiftUI

struct MealRow: View {

    var mealIngredient: MealIngredient

    var body: some View {

        GeometryReader { geometry in
            HStack {
                Text(mealIngredient.name).font(.caption2).frame(width: geometry.size.width * 0.5, alignment: .leading)
                Text("\(mealIngredient.fat.fractionDigits(max: 0))").font(.caption2).frame(width: geometry.size.width * 0.05, alignment: .trailing)
                Text("\(mealIngredient.netcarbs.fractionDigits(max: 1))").font(.caption2).frame(width: geometry.size.width * 0.1, alignment: .trailing)
                Text("\(mealIngredient.protein.fractionDigits(max: 0))").font(.caption2).frame(width: geometry.size.width * 0.05, alignment: .trailing)
                Spacer()
                Text("\(mealIngredient.amount.fractionDigits(max: 0))").font(.caption2).frame(width: geometry.size.width * 0.15, alignment: .trailing)
                Text(mealIngredient.amount == 1 ? mealIngredient.consumptionUnit.singular : mealIngredient.consumptionUnit.plural).font(.caption2).frame(width: geometry.size.width * 0.15, alignment: .leading)
            }.frame(height: 8)
        }
    }
}

//    struct MealRow_Previews: PreviewProvider {
//        static var previews: some View {
//            MealRow()
//        }
//    }
