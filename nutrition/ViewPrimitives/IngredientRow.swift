import SwiftUI

struct IngredientRowHeader: View {

    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    var nameWidthPercentage: Float = 0.345
    var macroWidthPercentage: Float = 0.073
    var choiceGroupWidthPercentage: Float = 0.425
    var amountWidthPercentage: Float = 0.1
    var unitWidthPercentage: Float = 0.15

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 5) {
                Text("   Ingredient").font(.caption).bold().frame(width: CGFloat(nameWidthPercentage) * geometry.size.width, alignment: .leading).border(Color.black, width: 0)

                if showMacros {
                    Text("Cal").font(.caption).bold().frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Fat").font(.caption).bold().frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Fbr").font(.caption).bold().frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Ncb").font(.caption).bold().frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("Pro").font(.caption).bold().frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showGroup {
                    Text("Choice Group").font(.caption).bold().frame(width: CGFloat(choiceGroupWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showAmount {
                    Text("Amount").font(.caption).bold().frame(width: CGFloat((amountWidthPercentage + unitWidthPercentage)) * geometry.size.width, alignment: .center).border(Color.black, width: 0)
                }
            }
        }
    }
}

struct IngredientRow: View {

    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    var nameWidthPercentage: Float = 0.325
    var macroWidthPercentage: Float = 0.075
    var choiceGroupWidthPercentage: Float = 0.425
    var amountWidthPercentage: Float = 0.1
    var unitWidthPercentage: Float = 0.15

    var name: String
    var calories: Float = 0
    var fat: Float = 0
    var fiber: Float = 0
    var netcarbs: Float = 0
    var protein: Float = 0
    var group: String = ""
    var amount: Float = 0
    var consumptionUnit: Unit = Unit.gram

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 5) {
                Text(name).font(.caption).bold().frame(width: CGFloat(nameWidthPercentage) * geometry.size.width, alignment: .leading).border(Color.black, width: 0)

                if showMacros {
                    Text("\(calories.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(fat.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(fiber.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(netcarbs.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text("\(protein.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showGroup {
                    Text("\(group)").font(.caption).bold().frame(width: CGFloat(choiceGroupWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                }

                if showAmount {
                    Text("\(amount.string(1))").font(.caption2).frame(width: CGFloat(amountWidthPercentage) * geometry.size.width, alignment: .trailing).border(Color.black, width: 0)
                    Text(amount == 1 ? consumptionUnit.singularForm : consumptionUnit.pluralForm).font(.caption2).frame(width: CGFloat(unitWidthPercentage) * geometry.size.width, alignment: .leading).border(Color.black, width: 0)
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
