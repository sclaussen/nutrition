import SwiftUI


// Returns the step size to use when the user taps `(-)` or `(+)` on
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


// Inline stepper for a meal-ingredient row:
//     (-)   <pill: amount unit>   (+)   ›
// The pill is the manual-entry affordance (caller decides what to
// do on tap — typically present a NumberEntrySheet).  The chevron
// is the navigation affordance to MealIngredientDetail.
//
// The stepper is stateless: it just calls back to the caller, who
// owns the meal-ingredient state and decides how to apply changes
// (manualAdjustment for regular ingredients, setMeatAndAmount for
// the meat).
struct AmountStepper: View {

    let amount: Double
    let unit: Unit
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    let onPillTap: () -> Void
    let onDetailTap: () -> Void


    var body: some View {
        HStack(spacing: 6) {
            Button(action: onDecrement) {
                Image(systemName: "minus.circle")
                  .font(.title2)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blueYellow)

            Button(action: onPillTap) {
                Text(amountLabel)
                  .font(.callout)
                  .frame(width: 90, alignment: .trailing)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blackWhite)

            Button(action: onIncrement) {
                Image(systemName: "plus.circle")
                  .font(.title2)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blueYellow)

            Button(action: onDetailTap) {
                Image(systemName: "chevron.right")
                  .font(.caption)
            }
              .buttonStyle(.borderless)
              .foregroundColor(Color.theme.blackWhiteSecondary)
              .padding(.leading, 14)
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
