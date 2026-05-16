import SwiftUI


// Reserved trailing space to account for the NavigationLink chevron
// that List adds to each row.  The header isn't a NavigationLink so
// we reserve the same width manually to keep columns aligned.
private let chevronTrail: CGFloat = 18

private let minWidth: CGFloat        = 60
private let maxWidth: CGFloat        = 60
// Actual + unit are rendered as a single right-justified string ("4.7 mgs"),
// so this column is sized to fit the widest expected combo (e.g. "10,000 mcgs").
private let actualUnitWidth: CGFloat = 110


struct VitaminMineralRowHeader: View {
    // Set false when rendered outside a List/NavigationLink context
    // (e.g. in a plain VStack) — there's no auto-chevron to reserve
    // space for, so the trailing spacer must collapse to keep the
    // headers aligned over the data columns.
    var reserveChevronSpace: Bool = true

    var body: some View {
        HStack(spacing: 5) {
            Text("Vitamin/Mineral")
              // .callout matches the data row's name font so the
              // first column reads at the same visual weight as the
              // entries below.
              .font(.callout)
              .foregroundColor(Color.theme.blueYellow)
              .frame(maxWidth: .infinity, alignment: .leading)
            Text("Min")
              .font(.callout)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: minWidth, alignment: .trailing)
            Text("Max")
              .font(.callout)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: maxWidth, alignment: .trailing)
            Text("Actual")
              .font(.callout)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: actualUnitWidth, alignment: .trailing)
            if reserveChevronSpace {
                Spacer().frame(width: chevronTrail)
            }
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
            Text("\(min.formattedString(precision))")
              .font(.callout)
              .frame(width: minWidth, alignment: .trailing)
            Text(max > 0 ? "\(max.formattedString(precision))" : "—")
              .font(.callout)
              .frame(width: maxWidth, alignment: .trailing)
            Text("\(actual.formattedString(precision)) \(unit.pluralForm)")
              .font(.callout)
              .frame(width: actualUnitWidth, alignment: .trailing)
        }
    }


    // Decimals to show.  Small-value nutrients (e.g. Pantothenic Acid
    // min 5, Riboflavin min 1.3) need 1 decimal so a near-miss shows as
    // "4.7 vs 5.0" instead of misleadingly rounding both to "5"; large-
    // value ones (e.g. Phosphorus min 700) read fine as integers.
    private var precision: Int {
        return min < 10 ? 1 : 0
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
