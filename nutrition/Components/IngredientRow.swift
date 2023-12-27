import SwiftUI

struct IngredientRowHeader: View {
    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    // TODO: Figure out why these percentages vary from the data rows
    var nameWidthPercentage: Double = 0.38
    var macroWidthPercentage: Double = 0.058
    var choiceGroupWidthPercentage: Double = 0.34
    var amountWidthPercentage: Double = 0.1
    var unitWidthPercentage: Double = 0.15

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text("Ingredient").font(.caption).foregroundColor(Color.theme.blueYellow).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)

                if showMacros {
                    Text("Cal").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("Fat").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("Fbr").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("Ncb").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("Pro").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                }

                if showGroup {
                    Text("Group").font(.caption).foregroundColor(Color.theme.blueYellow).frame(width: choiceGroupWidthPercentage * geo.size.width, alignment: .center).border(Color.theme.red, width: 0)
                }

                if showAmount {
                    Text("Amount").font(.caption).foregroundColor(Color.theme.blueYellow).frame(width: (amountWidthPercentage + unitWidthPercentage) * geo.size.width, alignment: .center).border(Color.theme.red, width: 0)
                }
            }
        }
    }
}

struct IngredientRow: View {
    var showMacros: Bool = false
    var showGroup: Bool = false
    var showAmount: Bool = true

    var nameWidthPercentage: Double = 0.395
    var macroWidthPercentage: Double = 0.062
    var choiceGroupWidthPercentage: Double = 0.36
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
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text(name).font(.callout).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)

                if showMacros {
                    Text("\(calories.formattedString(0))").font(.caption2).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("\(fat.formattedString(0))").font(.caption2).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("\(fiber.formattedString(0))").font(.caption2).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("\(netcarbs.formattedString(0))").font(.caption2).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text("\(protein.formattedString(0))").font(.caption2).frame(width: macroWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                }

                if showGroup {
                    Text("\(group)").font(.caption).frame(width: choiceGroupWidthPercentage * geo.size.width, alignment: .center).border(Color.theme.red, width: 0)
                }

                if showAmount {
                    Text("\(amount.formattedString(1))").font(.callout).frame(width: amountWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                    Text(amount == 1 ? consumptionUnit.singularForm : consumptionUnit.pluralForm).font(.caption).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)
                }
            }.frame(height: 9)
        }
    }
}

//    struct IngredientRow_Previews: PreviewProvider {
//        static var previews: some View {
//            IngredientRow()
//        }
//    }
