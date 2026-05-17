import SwiftUI


// Returns the step size to use when the user taps `<` or `>` on
// a meal-ingredient row.  If the ingredient has a user-set
// `stepAmount > 0`, that wins.  Otherwise, fall back to a heuristic:
//   - meat (gram-unit)               -> 10  (chicken/beef/etc.)
//   - piece/egg/can/whole/slice/cup  -> 1
//   - tablespoon                     -> 0.5
//   - gram, servingSize <= 35        -> 5
//   - gram, servingSize >  35        -> 25
//   - anything else                  -> 1 (sensible default)
func effectiveStep(for ingredient: Ingredient, foodMgr: FoodMgr) -> Double {
    if ingredient.stepAmount > 0 {
        return ingredient.stepAmount
    }
    // Proteins step by 10g — the generic gram heuristic (25 for
    // servingSize > 35) is too coarse for tuning a chicken or
    // salmon portion. 10g hits the sweet spot.
    if foodMgr.isMeat(ingredient) && ingredient.consumptionUnit == .gram {
        return 10
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
//     <    amount     >
//   step  manual  step
//
// The detail-disclosure chevron lives on the parent row, not here,
// so it can sit flush against the right edge while the stepper
// itself is inset (per the "amount column shifted left ~10%" UX).
//
// The lock/unlock action lives on the row itself via long-press,
// not on this widget.
struct AmountStepper: View {

    let amount: Double
    let unit: Unit
    let isLocked: Bool
    // Row is auto-adjusted (Constants.Automatic). When true and not
    // locked, the stepper renders green to match the row's name color
    // — otherwise the AmountStepper's own .foregroundColor calls
    // override the row HStack's inherited green and only the name
    // shows the state.
    var isAuto: Bool = false
    // Explicit widths per tap zone. The parent row computes these
    // from row-width × percentage (10% / 20% / 10%) so the three
    // zones line up under the row's other columns and the entire
    // zone — not just the symbol — is hit-testable.
    let decrementWidth: CGFloat
    let pillWidth: CGFloat
    let incrementWidth: CGFloat
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    // Fired by a long-press (≥0.5s) on the decrement triangle. The
    // parent uses this to zero the amount AND lock the row in one
    // shot. A short tap fires onDecrement instead (one step down).
    //
    // History: this was briefly reimplemented as a repeating
    // decrement Timer that locked when the running amount crossed 0.
    // That Timer captured the meal-ingredient amount at hold-start,
    // so after the first tick it re-applied the same stale value
    // forever — the amount never reached 0 and the lock never fired.
    // Reverted to the original one-shot semantics (which is also
    // exactly what the user asked for: hold = zero + lock).
    let onDecrementToZero: () -> Void
    let onPillTap: () -> Void


    var body: some View {
        HStack(spacing: 0) {
            // Locked rows are truly read-only: the triangle Buttons
            // vanish and the pill becomes a non-tappable Text in the
            // same slot. Unlocking the row (tap the name) brings the
            // interactive controls back. The empty triangle slots are
            // preserved (Color.clear placeholders) so the row's
            // 50/10/20/10/10 layout doesn't shift under your eyes.
            if isLocked {
                Color.clear.frame(width: decrementWidth)
                Text(amountLabel)
                  .font(.callout)
                  .lineLimit(1)
                  .foregroundColor(pillColor)
                  .frame(width: pillWidth)
                Color.clear.frame(width: incrementWidth)
            } else {
                Button(action: onDecrement) {
                    Image(systemName: "arrowtriangle.backward.fill")
                      .font(.footnote)
                      .frame(maxWidth: .infinity, maxHeight: .infinity)
                      .contentShape(Rectangle())
                }
                  .buttonStyle(.borderless)
                  .foregroundColor(triangleColor)
                  .frame(width: decrementWidth)
                  // Tap (<0.5s)  -> onDecrement (one step down).
                  // Hold (≥0.5s) -> onDecrementToZero (parent zeroes
                  //                 the amount AND locks the row).
                  // highPriorityGesture so the long-press wins over
                  // the row-level tap-to-lock gesture and suppresses
                  // the Button's own tap when it's actually a hold.
                  .highPriorityGesture(
                      LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in onDecrementToZero() }
                  )

                Button(action: onPillTap) {
                    Text(amountLabel)
                      .font(.callout)
                      .lineLimit(1)
                      .frame(maxWidth: .infinity, maxHeight: .infinity)
                      .contentShape(Rectangle())
                }
                  .buttonStyle(.borderless)
                  .foregroundColor(pillColor)
                  .frame(width: pillWidth)

                Button(action: onIncrement) {
                    Image(systemName: "arrowtriangle.forward.fill")
                      .font(.footnote)
                      .frame(maxWidth: .infinity, maxHeight: .infinity)
                      .contentShape(Rectangle())
                }
                  .buttonStyle(.borderless)
                  .foregroundColor(triangleColor)
                  .frame(width: incrementWidth)
            }
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


    // Triangles read as grey/secondary by default; blue when this
    // row is locked, green when auto-adjusted. Lock wins over auto
    // (locked rows are no longer auto-adjusted, so this branch is
    // mostly defensive).
    private var triangleColor: Color {
        if isLocked { return Color.theme.blueYellow }
        if isAuto   { return Color.theme.manual }
        return Color.theme.blackWhiteSecondary
    }

    // Amount pill: blue when locked, green when auto-adjusted, else
    // the default body text color.
    private var pillColor: Color {
        if isLocked { return Color.theme.blueYellow }
        if isAuto   { return Color.theme.manual }
        return Color.theme.blackWhite
    }
}
