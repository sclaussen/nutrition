import SwiftUI

enum GaugeType {
    case goal
    case ceiling
    case floor
    case value
}

struct Gauge: View {
    var title: String
    var titleFontColor: Color
    var titleFontSize: Double
    var titleOffset: Double
    var actual: Double
    var actualFontSize: Double
    var actualPrecision: Int
    var actualOffset: Double
    var goal: Double
    var goalFontSize: Double
    var goalPrecision: Int
    var annotationFontColor: Color
    var unit: String
    var unitFontSize: Double
    var startHour: Double
    var endHour: Double
    var side: Double
    var progressLineWidth: Double
    var progressLineBackground: Color
    var progressLineNormal: Color
    var progressLineWarning: Color
    var progressLineError: Color
    var warningThreshold: Double
    var errorThreshold: Double
    var type: GaugeType
    var secondaryGoal: Double
    var secondaryGoalPrecision: Int

    init(title: String = "",
         titleFontColor: Color = Color.theme.blackWhite,
         titleFontSize: Double = 14,
         _ actual: Double,
         actualFontSize: Double = 19,
         actualPrecision: Int = 0,
         _ goal: Double = 0,
         goalFontSize: Double = 12,
         goalPrecision: Int = 0,
         annotationFontColor: Color = Color.theme.blueYellow,
         unit: String = "",
         unitFontSize: Double = 10,
         startHour: Double = 7.5,
         endHour: Double = 4.5,
         side: Double = 60.0,
         progressLineWidth: Double = 10.0,
         progressLineBackground: Color = Color.theme.progressLineBackground,
         progressLineNormal: Color = Color.theme.green,
         progressLineWarning: Color = Color.theme.yellow,
         progressLineError: Color = Color.theme.red,
         warningThreshold: Double = 5,
         errorThreshold: Double = 10,
         type: GaugeType = GaugeType.goal,
         // Optional reference value rendered as a smaller line below
         // the goal value (e.g. TDEE/maintenance calories below the
         // 80%-of-TDEE goal).  Set to 0 to omit.
         secondaryGoal: Double = 0,
         secondaryGoalPrecision: Int = 0,
         scale: Double = 1.0) {

        self.title = title
        self.titleFontColor = titleFontColor
        self.titleFontSize = titleFontSize * scale
        self.actual = actual
        self.actualFontSize = actualFontSize * scale
        self.actualPrecision = actualPrecision
        self.goalPrecision = goalPrecision
        self.goal = goal
        self.goalFontSize = goalFontSize * scale
        self.annotationFontColor = annotationFontColor
        self.unit = unit
        self.unitFontSize = unitFontSize * scale
        self.startHour = startHour
        self.endHour = endHour
        self.side = side * scale
        self.progressLineWidth = progressLineWidth * scale
        self.progressLineBackground = progressLineBackground
        self.progressLineNormal = progressLineNormal
        self.progressLineWarning = progressLineWarning
        self.progressLineError = progressLineError
        self.warningThreshold = warningThreshold
        self.errorThreshold = errorThreshold
        self.type = type
        self.secondaryGoal = secondaryGoal
        self.secondaryGoalPrecision = secondaryGoalPrecision

        if type == .value {
            self.titleOffset = 0 - (side / 2 + side * 0.05)
            self.actualOffset = 0
            self.startHour = 6
            self.endHour = 6
            self.progressLineWidth = self.progressLineWidth / 2.2
            self.progressLineNormal = Color.theme.blue
        } else {
            // Title-to-gauge distance: 0.50 of side pushes the title
            // well clear of the donut top, with visible whitespace
            // between them (was 0.35 — still felt cramped).
            self.titleOffset = 0 - (side / 2 + side * 0.50)
            // Big number sits dead-center on the donut; the unit
            // text ("cal", "grams") trails below via its own offset.
            self.actualOffset = 0
        }
    }

    var body: some View {
        let dialPercentageUsed = ((12 - startHour) + endHour) / 12

        return ZStack {
            Text(title)
              .font(.system(size: titleFontSize))
              .foregroundColor(titleFontColor)
              .bold()
              .lineLimit(1)
              // .fixedSize lets the title use its natural one-line width
              // so longer labels ("NCarbs", "Protein") don't wrap when
              // the title font grows past what side-width can hold.
              // Centering is preserved via the parent ZStack alignment.
              .fixedSize(horizontal: true, vertical: false)
              .offset(y: titleOffset)

            Circle()
              .fill(progressLineNormal.opacity(0.05))
              .frame(width: side, height: side)

            Circle()
              .trim(from: 0.0, to: dialPercentageUsed)
              .stroke(progressLineBackground, style: StrokeStyle(lineWidth: progressLineWidth * 0.6, lineCap: .round))
              .rotationEffect(Angle(degrees: 135.0))
              .frame(width: side, height: side)

            Circle()
              .trim(from: 0.0, to: min(actual / goal, 1) * dialPercentageUsed)
              .stroke(getProgressColor(), style: StrokeStyle(lineWidth: progressLineWidth, lineCap: .round))
              .rotationEffect(Angle(degrees: 135.0))
              .frame(width: side, height: side)

            Group {
                Text(format(actual, actualPrecision))
                  .foregroundColor(annotationFontColor)
                  .font(.system(size: actualFontSize))
                  .bold()

                Text(unit)
                  .foregroundColor(annotationFontColor)
                  .font(.system(size: unitFontSize))
                  .offset(y: side * 0.2)
            }
              .offset(y: actualOffset)

            if goal > 0 {
                // Percentage rendered to the LEFT of the goal value
                // ("73% / 2,303").  pct is %-of-TDEE for the Calories
                // gauge (where secondaryGoal = TDEE), %-of-goal for the
                // other gauges.  For .ceiling gauges (NCarbs), the %
                // turns red once it crosses 100% — visual cue that you
                // went over your hard limit.
                //
                // VStack offset shifted DOWN by half the secondary line's
                // height (only when secondaryGoal is shown) so the "Goal"
                // label stays y-aligned with the other gauges in the row.
                let pct: Int = secondaryGoal > 0
                    ? Int((actual / secondaryGoal * 100).rounded())
                    : Int((actual / goal * 100).rounded())
                let pctColor: Color = (type == .ceiling && pct > 100)
                    ? progressLineError
                    : annotationFontColor
                let secondaryShift: Double = secondaryGoal > 0 ? goalFontSize * 0.85 / 2 : 0
                VStack(spacing: 0) {
                    Text("Goal")
                      .foregroundColor(annotationFontColor)
                      .font(.system(size: goalFontSize * 0.7))
                    HStack(spacing: 0) {
                        Text("\(pct)%")
                          .bold()
                          .foregroundColor(pctColor)
                        Text(" / \(format(goal, goalPrecision))")
                          .bold()
                          .foregroundColor(annotationFontColor)
                    }
                      .font(.system(size: goalFontSize))
                      .lineLimit(1)
                      .fixedSize(horizontal: true, vertical: false)
                    if secondaryGoal > 0 {
                        // "<actual - TDEE> / <TDEE>" — negative when you
                        // still have room under TDEE (e.g. "-2,091 /
                        // 2,879"), positive when you've gone over.  The
                        // sign comes for free from NumberFormatter, so
                        // values above TDEE render without a leading
                        // minus per the requested behavior.
                        let diff = (actual - secondaryGoal).rounded()
                        Text("\(format(diff, 0)) / \(format(secondaryGoal, secondaryGoalPrecision))")
                          .foregroundColor(annotationFontColor)
                          .font(.system(size: goalFontSize * 0.85))
                    }
                }
                  // +4pt nudge — pushes "Goal" (and the percent line
                  // beneath it) a few pixels lower so it doesn't crowd
                  // the bottom of the gauge ring.
                  .offset(y: side / 2 + side * 0.02 + 4 + secondaryShift)
            }
        }.frame(width: side * 1.25)
    }

    func format(_ f: Double, _ precision: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        formatter.roundingMode = .halfEven
        formatter.numberStyle = .decimal
        return formatter.string(for: f) ?? ""
    }

    func getProgressColor() -> Color {
        if type == .value {
            return progressLineNormal
        }

        if type == .ceiling {
            if actual > goal {
                return progressLineError
            }
            return progressLineNormal
        }

        if type == .floor {
            if actual < goal {
                return progressLineError
            }
            return progressLineNormal
        }

        if type == .goal {
            let difference = abs(((goal - actual) / goal) * 100)
            if difference > errorThreshold {
                return progressLineError
            }
            if difference > warningThreshold {
                return progressLineWarning
            }
            return progressLineNormal
        }

        return progressLineNormal
    }
}
