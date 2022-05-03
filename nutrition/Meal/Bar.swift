import SwiftUI

struct Bar: View {
    var title: String
    var titleFontColor: Color
    var titleFontSize: Double
    var actual: Double
    var goal: Double
    var topLeftAnnotation: String
    var topRightAnnotation: String
    var bottomLeftAnnotation: String
    var bottomCenterAnnotation: String
    var bottomRightAnnotation: String
    var annotationFontColor: Color
    var annotationFontSize: Double
    var progressLineHeight: Double
    var progressLineBackground: Color
    var progressLineNormal: Color
    var progressLineWarning: Color
    var progressLineError: Color
    var warningThreshold: Double
    var errorThreshold: Double
    var geo: GeometryProxy

    init(title: String,
         titleFontColor: Color = Color.theme.blackWhite,
         titleFontSize: Double = 14,
         _ actual: Double,
         _ goal: Double,
         topLeftAnnotation: String = "",
         topRightAnnotation: String = "",
         bottomLeftAnnotation: String = "",
         bottomCenterAnnotation: String = "",
         bottomRightAnnotation: String = "",
         annotationFontColor: Color = Color.theme.blueYellow,
         annotationFontSize: Double = 12,
         progressLineHeight: Double = 10,
         progressLineBackground: Color = Color.theme.blackWhite.opacity(0.2),
         progressLineNormal: Color = Color.theme.green,
         progressLineWarning: Color = Color.theme.yellow,
         progressLineError: Color = Color.theme.red,
         warningThreshold: Double = 10,
         errorThreshold: Double = 20,
         geo: GeometryProxy) {

        self.title = title
        self.titleFontColor = titleFontColor
        self.titleFontSize = titleFontSize
        self.actual = actual
        self.goal = goal
        self.topLeftAnnotation = topLeftAnnotation
        self.bottomLeftAnnotation = bottomLeftAnnotation
        self.topRightAnnotation = topRightAnnotation
        self.bottomRightAnnotation = bottomRightAnnotation
        self.bottomCenterAnnotation = bottomCenterAnnotation
        self.annotationFontColor = annotationFontColor
        self.annotationFontSize = annotationFontSize
        self.progressLineHeight = progressLineHeight
        self.progressLineBackground = progressLineBackground
        self.progressLineNormal = progressLineNormal
        self.progressLineWarning = progressLineWarning
        self.progressLineError = progressLineError
        self.warningThreshold = warningThreshold
        self.errorThreshold = errorThreshold
        self.geo = geo
    }

    var body: some View {
        return VStack(spacing: 1) {

            HStack(alignment: .bottom) {
                Text(topLeftAnnotation)
                  .font(.system(size: annotationFontSize))
                  .foregroundColor(annotationFontColor)
                  .frame(maxWidth: geo.size.width * 0.2, alignment: .leading)
                Text(title)
                  .font(.system(size: titleFontSize))
                  .foregroundColor(titleFontColor)
                  .bold()
                  .frame(maxWidth: .infinity, alignment: .center)
                Text(topRightAnnotation)
                  .font(.system(size: annotationFontSize))
                  .foregroundColor(annotationFontColor)
                  .frame(maxWidth: geo.size.width * 0.2, alignment: .trailing)
            }
              .frame(width: geo.size.width * 0.83)

            ZStack(alignment: .leading) {
                Capsule()
                  .frame(width: geo.size.width * 0.85, height: progressLineHeight * 0.6)
                  .foregroundColor(progressLineBackground)

                Capsule()
                  .frame(width: min(actual / goal, 1) * geo.size.width * 0.85, height: progressLineHeight, alignment: .leading)
                  .foregroundColor(getProgressColor())
            }

            HStack(alignment: .top) {
                Text(bottomLeftAnnotation)
                  .font(.system(size: annotationFontSize))
                  .foregroundColor(annotationFontColor)
                  .frame(maxWidth: geo.size.width * 0.15, alignment: .leading)
                Text(bottomCenterAnnotation)
                  .font(.system(size: annotationFontSize))
                  .foregroundColor(annotationFontColor)
                  .frame(maxWidth: .infinity, alignment: .center)
                Text(bottomRightAnnotation)
                  .font(.system(size: annotationFontSize))
                  .foregroundColor(annotationFontColor)
                  .frame(maxWidth: geo.size.width * 0.15, alignment: .trailing)
            }
              .frame(width: geo.size.width * 0.83)
        }
    }

    func getProgressColor() -> Color {
        let difference = abs(((goal - actual) / goal) * 100)
        if difference > errorThreshold {
            return progressLineError
        }
        if difference > warningThreshold {
            return progressLineWarning
        }
        return progressLineNormal
    }
}
