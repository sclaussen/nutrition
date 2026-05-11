import SwiftUI


// Returns the step size to use when the user taps `<` or `>` on
// a meal-ingredient row.  If the ingredient has a user-set
// `stepAmount > 0`, that wins.  Otherwise, fall back to a heuristic:
//   - piece/egg/can/whole/slice/cup  -> 1
//   - tablespoon                     -> 0.5
//   - gram, servingSize <= 35        -> 5
//   - gram, servingSize >  35        -> 25
//   - anything else                  -> 1 (sensible default)
func effectiveStep(for ingredient: Ingredient) -> Double {
    if ingredient.stepAmount > 0 {
        return ingredient.stepAmount
    }
    switch ingredient.consumptionUnit {
    case .piece, .egg, .can, .whole, .slice, .cup:
        return 1
    case .tablespoon:
        return 0.5
    case .gram:
        return ingredient.servingSize <= 35 ? 5 : 25
    default:
        return 1
    }
}


// Inline stepper for a meal-ingredient row.  Layout:
//     <    amount     >    🔒    ›
//   step  manual  step  lock  detail
//
// All buttons use compact chevron / lock icons sized to keep the
// row height close to the original ~25pt; the detail chevron at the
// far right is rendered smaller in secondary color to differentiate
// it from the increment chevron.
struct AmountStepper: View {

    let amount: Double
    let unit: Unit
    let isLocked: Bool
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    let onPillTap: () -> Void
    let onLockToggle: () -> Void
    let onDetailTap: () -> Void


    var body: some View {
        HStack(spacing: 4) {
            Button(action: onDecrement) {
                Image(systemName: "chevron.left")
                  .font(.body)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: 24)

            Button(action: onPillTap) {
                Text(amountLabel)
                  .font(.callout)
                  .lineLimit(1)
                  .frame(width: 95, alignment: .center)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blackWhite)

            Button(action: onIncrement) {
                Image(systemName: "chevron.right")
                  .font(.body)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blueYellow)
              .frame(width: 24)

            Button(action: onLockToggle) {
                Image(systemName: isLocked ? "lock.fill" : "lock.open")
                  .font(.body)
            }
              .buttonStyle(.borderless)
              .foregroundColor(isLocked ? Color.theme.red : Color.theme.blackWhiteSecondary)
              .frame(width: 24)

            Button(action: onDetailTap) {
                Image(systemName: "chevron.right")
                  .font(.caption2)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blackWhiteSecondary)
              .frame(width: 18)
        }
    }


    private var amountLabel: String {
        let formatted: String
        if amount == amount.rounded() {
            formatted = String(Int(amount))
        } else {
            formatted = String(format: "%.1f", amount)
        }
        return "\(formatted) \(unit.pluralForm)"
    }
}
