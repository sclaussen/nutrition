import SwiftUI


// Reserved trailing space to account for the NavigationLink chevron
// that List adds to each row.  The header isn't a NavigationLink so
// we reserve the same width manually to keep columns aligned.
private let chevronTrail: CGFloat = 18

private let minWidth: CGFloat    = 60
private let maxWidth: CGFloat    = 60
private let actualWidth: CGFloat = 60
private let unitWidth: CGFloat   = 50


struct VitaminMineralRowHeader: View {
    var body: some View {
        HStack(spacing: 5) {
            Text("Vitamin/Mineral")
              .font(.caption)
              .foregroundColor(Color.theme.blueYellow)
              .frame(maxWidth: .infinity, alignment: .leading)
            Text("Min")
              .font(.caption2)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: minWidth, alignment: .trailing)
            Text("Max")
              .font(.caption2)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: maxWidth, alignment: .trailing)
            Text("Actual")
              .font(.caption2)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: actualWidth, alignment: .trailing)
            Text("Unit")
              .font(.caption2)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: unitWidth, alignment: .leading)
            Spacer().frame(width: chevronTrail)
        }
    }
}


struct VitaminMineralRow: View {
    var name: VitaminMineralType
    var min: Double
    var max: Double
    var actual: Double = 0
    var unit: Unit = Unit.milligram


    var body: some View {
        HStack(spacing: 5) {
            Text(name.formattedString())
              .font(.callout)
              .foregroundColor(nameColor)
              .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(min.formattedString(0))")
              .font(.caption2)
              .frame(width: minWidth, alignment: .trailing)
            Text(max > 0 ? "\(max.formattedString(0))" : "—")
              .font(.caption2)
              .frame(width: maxWidth, alignment: .trailing)
            Text("\(actual.formattedString(0))")
              .font(.caption2)
              .frame(width: actualWidth, alignment: .trailing)
            Text(unit.pluralForm)
              .font(.caption)
              .frame(width: unitWidth, alignment: .leading)
        }
    }


    // Color rule: highlight the NAME in red if the actual is below
    // min or above a defined max.  The actual number stays in the
    // default color so the name is the clear "is this OK?" signal
    // at a glance.
    private var nameColor: Color {
        if actual < min {
            return Color.theme.red
        }
        if max > 0 && actual > max {
            return Color.theme.red
        }
        return Color.theme.blackWhite
    }
}
