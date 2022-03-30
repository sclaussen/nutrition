import SwiftUI

struct IngredientRowHeader: View {

    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    // TODO: Figure out why these percentages vary from the data rows
    var nameWidthPercentage: Float = 0.38
    var macroWidthPercentage: Float = 0.058
    var choiceGroupWidthPercentage: Float = 0.4
    var amountWidthPercentage: Float = 0.1
    var unitWidthPercentage: Float = 0.15

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text("Ingredient").font(.caption).foregroundColor(Color("Blue")).frame(width: CGFloat(nameWidthPercentage) * geo.size.width, alignment: .leading).border(Color("Red"), width: 0)

                if showMacros {
                    Text("Cal").font(.caption2).foregroundColor(Color("Blue")).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("Fat").font(.caption2).foregroundColor(Color("Blue")).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("Fbr").font(.caption2).foregroundColor(Color("Blue")).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("Ncb").font(.caption2).foregroundColor(Color("Blue")).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("Pro").font(.caption2).foregroundColor(Color("Blue")).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                }

                if showGroup {
                    Text("Group").font(.caption).foregroundColor(Color("Blue")).frame(width: CGFloat(choiceGroupWidthPercentage) * geo.size.width, alignment: .center).border(Color("Red"), width: 0)
                }

                if showAmount {
                    Text("Amount").font(.caption).foregroundColor(Color("Blue")).frame(width: CGFloat((amountWidthPercentage + unitWidthPercentage)) * geo.size.width, alignment: .center).border(Color("Red"), width: 0)
                }
            }
        }
    }
}

struct IngredientRow: View {

    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    var nameWidthPercentage: Float = 0.395
    var macroWidthPercentage: Float = 0.062
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
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text(name).font(.caption).frame(width: CGFloat(nameWidthPercentage) * geo.size.width, alignment: .leading).border(Color("Red"), width: 0)

                if showMacros {
                    Text("\(calories.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("\(fat.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("\(fiber.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("\(netcarbs.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text("\(protein.string(0))").font(.caption2).frame(width: CGFloat(macroWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                }

                if showGroup {
                    Text("\(group)").font(.caption).frame(width: CGFloat(choiceGroupWidthPercentage) * geo.size.width, alignment: .center).border(Color("Red"), width: 0)
                }

                if showAmount {
                    Text("\(amount.string(1))").font(.caption).frame(width: CGFloat(amountWidthPercentage) * geo.size.width, alignment: .trailing).border(Color("Red"), width: 0)
                    Text(amount == 1 ? consumptionUnit.singularForm : consumptionUnit.pluralForm).font(.caption2).frame(width: CGFloat(unitWidthPercentage) * geo.size.width, alignment: .leading).border(Color("Red"), width: 0)
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
