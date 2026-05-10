import SwiftUI


struct VitaminMineralRowHeader: View {
    var nameWidthPercentage: Double = 0.26
    var minWidthPercentage: Double = 0.16
    var maxWidthPercentage: Double = 0.16
    var actualWidthPercentage: Double = 0.16
    var unitWidthPercentage: Double = 0.13


    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text("Vitamin/Mineral").font(.caption).foregroundColor(Color.theme.blueYellow).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading)
                Text("Min").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: minWidthPercentage * geo.size.width, alignment: .trailing)
                Text("Max").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: maxWidthPercentage * geo.size.width, alignment: .trailing)
                Text("Actual").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: actualWidthPercentage * geo.size.width, alignment: .trailing)
                Text("Unit").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading)
            }
        }
    }
}


struct VitaminMineralRow: View {
    var nameWidthPercentage: Double = 0.26
    var minWidthPercentage: Double = 0.16
    var maxWidthPercentage: Double = 0.16
    var actualWidthPercentage: Double = 0.16
    var unitWidthPercentage: Double = 0.13

    var name: VitaminMineralType
    var min: Double
    var max: Double
    var actual: Double = 0
    var unit: Unit = Unit.milligram


    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text(name.formattedString()).font(.callout).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading)
                Text("\(min.formattedString(0))").font(.caption2).frame(width: minWidthPercentage * geo.size.width, alignment: .trailing)
                Text(max > 0 ? "\(max.formattedString(0))" : "—").font(.caption2).frame(width: maxWidthPercentage * geo.size.width, alignment: .trailing)
                Text("\(actual.formattedString(0))").font(.caption2).foregroundColor(actualColor).frame(width: actualWidthPercentage * geo.size.width, alignment: .trailing)
                Text(unit.pluralForm).font(.caption).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading)
            }.frame(height: 9)
        }
    }


    // Color rule: red if below min OR above defined max, green if
    // within range.  When max is undefined (max == 0), only the
    // below-min check applies.
    private var actualColor: Color {
        if actual < min {
            return Color.theme.red
        }
        if max > 0 && actual > max {
            return Color.theme.red
        }
        return Color.theme.green
    }
}
