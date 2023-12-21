import SwiftUI


struct VitaminMineralRowHeader: View {
    var nameWidthPercentage: Double = 0.30
    var minWidthPercentage: Double = 0.20
    var maxWidthPercentage: Double = 0.20
    var unitWidthPercentage: Double = 0.15


    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text("Vitamin/Mineral").font(.caption).foregroundColor(Color.theme.blueYellow).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)
                Text("Minimum").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: minWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                Text("Unit").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: unitWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                Text("Maximum").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: maxWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                Text("Unit").font(.caption2).foregroundColor(Color.theme.blueYellow).frame(width: unitWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
            }
        }
    }
}


struct VitaminMineralRow: View {
    var nameWidthPercentage: Double = 0.30
    var minWidthPercentage: Double = 0.20
    var maxWidthPercentage: Double = 0.20
    var unitWidthPercentage: Double = 0.15

    var name: VitaminMineralType
    var min: Double
    var max: Double
    var unit: Unit = Unit.milligram


    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 5) {
                Text(name.formattedString()).font(.callout).frame(width: nameWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)
                Text("\(min.formattedString(0))").font(.caption2).frame(width: minWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                Text(unit.pluralForm).font(.caption).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)
                Text("\(max.formattedString(0))").font(.caption2).frame(width: maxWidthPercentage * geo.size.width, alignment: .trailing).border(Color.theme.red, width: 0)
                Text(unit.pluralForm).font(.caption).frame(width: unitWidthPercentage * geo.size.width, alignment: .leading).border(Color.theme.red, width: 0)
            }.frame(height: 9)
        }
    }
}
