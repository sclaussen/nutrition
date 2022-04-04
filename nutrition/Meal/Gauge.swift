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

    init(title: String = "",
         titleFontColor: Color = Color.black,
         titleFontSize: Double = 14,
         _ actual: Double,
         actualFontSize: Double = 19,
         actualPrecision: Int = 0,
         _ goal: Double = 0,
         goalFontSize: Double = 12,
         goalPrecision: Int = 0,
         annotationFontColor: Color = Color.blue,
         unit: String = "",
         unitFontSize: Double = 10,
         startHour: Double = 7.5,
         endHour: Double = 4.5,
         side: Double = 60.0,
         progressLineWidth: Double = 10.0,
         progressLineBackground: Color = Color.black.opacity(0.2),
         progressLineNormal: Color = Color.green,
         progressLineWarning: Color = Color.yellow,
         progressLineError: Color = Color.red,
         warningThreshold: Double = 5,
         errorThreshold: Double = 10,
         type: GaugeType = GaugeType.goal,
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

        if type == .value {
            self.titleOffset = 0 - (side / 2 + side * 0.05)
            self.actualOffset = 0
            self.startHour = 6
            self.endHour = 6
            self.progressLineWidth = self.progressLineWidth / 2.2
            self.progressLineNormal = Color.blue
        } else {
            self.titleOffset = 0 - (side / 2 + side * 0.21)
            self.actualOffset = 0 - side * 0.1
        }
    }

    var body: some View {
        let dialPercentageUsed = ((12 - startHour) + endHour) / 12

        return ZStack {
            Text(title)
              .font(.system(size: titleFontSize))
              .foregroundColor(titleFontColor)
              .bold()
              .frame(width: side)
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
                Text(format(goal, goalPrecision))
                  .foregroundColor(annotationFontColor)
                  .font(.system(size: goalFontSize))
                  .offset(y: side / 2 - side * 0.1)
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
