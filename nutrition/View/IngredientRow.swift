import SwiftUI

struct IngredientRowHeader: View {

    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    var nameWidthPercentage: Double = 0.345
    var macroWidthPercentage: Double = 0.073
    var choiceGroupWidthPercentage: Double = 0.425
    var amountWidthPercentage: Double = 0.1
    var unitWidthPercentage: Double = 0.15

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 5) {
                Text("   Ingredient").font(.caption).bold().frame(width: nameWidthPercentage * geometry.size.width, alignment: .leading).border(Color.black, width: 0)

                if showMacros {
                    Text("Cal").font(.caption).bold().frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Fat").font(.caption).bold().frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Fbr").font(.caption).bold().frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Ncb").font(.caption).bold().frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Pro").font(.caption).bold().frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showGroup {
                    Text("Choice Group").font(.caption).bold().frame(width: choiceGroupWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showAmount {
                    Text("Amount").font(.caption).bold().frame(width: (amountWidthPercentage + unitWidthPercentage) * geometry.size.width, alignment: .center).border(Color.black, width: 0)
                }
            }
        }
    }
}

struct IngredientRow: View {

    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    var nameWidthPercentage: Double = 0.325
    var macroWidthPercentage: Double = 0.075
    var choiceGroupWidthPercentage: Double = 0.425
    var amountWidthPercentage: Double = 0.1
    var unitWidthPercentage: Double = 0.15

    var name: String
    var calories: Double = 0
    var fat: Double = 0
    var fiber: Double = 0
    var netcarbs: Double = 0
    var protein: Double = 0
    var group: String = ""
    var amount: Double = 0
    var consumptionUnit: Unit = Unit.gram

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 5) {
                Text(name).font(.caption).bold().frame(width: nameWidthPercentage * geometry.size.width, alignment: .leading).border(Color.black, width: 0)

                if showMacros {
                    Text("\(calories.fractionDigits(max: 0))").font(.caption2).frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(fat.fractionDigits(max: 0))").font(.caption2).frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(fiber.fractionDigits(max: 0))").font(.caption2).frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(netcarbs.fractionDigits(max: 0))").font(.caption2).frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(protein.fractionDigits(max: 0))").font(.caption2).frame(width: macroWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showGroup {
                    Text("\(group)").font(.caption).bold().frame(width: choiceGroupWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showAmount {
                    Text("\(amount.fractionDigits(max: 1))").font(.caption2).frame(width: amountWidthPercentage * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text(amount == 1 ? consumptionUnit.singular : consumptionUnit.plural).font(.caption2).frame(width: unitWidthPercentage * geometry.size.width, alignment: .leading).border(Color.black, width: 0)
                }
            }.frame(height: 8)
        }
    }
}

//    struct IngredientRow_Previews: PreviewProvider {
//        static var previews: some View {
//            IngredientRow()
//        }
//    }
