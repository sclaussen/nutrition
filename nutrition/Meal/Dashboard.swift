import SwiftUI

struct Dashboard: View {
    let bodyMass: Double
    let bodyFatPercentage: Double
    let activeCaloriesBurned: Double
    let calorieDeficit: Int
    let proteinRatio: Double

    let caloriesGoalUnadjusted: Double
    let caloriesGoal: Double
    let calories: Double

    let fatGoal: Double
    let fiberMinimum: Double
    let netCarbsMaximum: Double
    let proteinGoal: Double

    let fat: Double
    let fiber: Double
    let netCarbs: Double
    let protein: Double

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Gauge(title: "Weight", titleFontColor: Color.theme.blackWhite, bodyMass, actualPrecision: 1, annotationFontColor: Color.theme.blueYellow, unit: "lbs", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Fat %", titleFontColor: Color.theme.blackWhite, bodyFatPercentage, actualPrecision: 1, annotationFontColor: Color.theme.blueYellow, unit: "%", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Activity", titleFontColor: Color.theme.blackWhite, activeCaloriesBurned, annotationFontColor: Color.theme.blueYellow, unit: "cal", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Deficit", titleFontColor: Color.theme.blackWhite, Double(calorieDeficit), annotationFontColor: Color.theme.blueYellow, unit: "%", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Ratio", titleFontColor: Color.theme.blackWhite, proteinRatio, actualPrecision: 2, annotationFontColor: Color.theme.blueYellow, unit: "g/lbm", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Spacer()
                }
                  .padding(.bottom, 30)

                HStack(spacing: 0) {
                    Spacer()
                    Gauge(title: "Fat", titleFontColor: Color.theme.blackWhite, fat, fatGoal, annotationFontColor: Color.theme.blueYellow, unit: "grams", progressLineBackground: Color("ProgressLineBackground"))
                    Spacer()
                    Gauge(title: "Fiber", titleFontColor: Color.theme.blackWhite, fiber, fiberMinimum, annotationFontColor: Color.theme.blueYellow, unit: "grams", progressLineBackground: Color("ProgressLineBackground"), type: .floor)
                    Spacer()
                    Gauge(title: "NCarbs", titleFontColor: Color.theme.blackWhite, netCarbs, actualPrecision: 1, netCarbsMaximum, annotationFontColor: Color.theme.blueYellow, unit: "grams", progressLineBackground: Color("ProgressLineBackground"), type: .ceiling)
                    Spacer()
                    Gauge(title: "Protein", titleFontColor: Color.theme.blackWhite, protein, proteinGoal, annotationFontColor: Color.theme.blueYellow, unit: "grams", progressLineBackground: Color("ProgressLineBackground"))
                    Spacer()
                }
                  .padding(.bottom, 6)

                let bottomCenterAnnotation = "\(Int(calories)) of \(Int(caloriesGoalUnadjusted)) (\(Int(calories - caloriesGoalUnadjusted)), \(Int((calories - caloriesGoalUnadjusted) / caloriesGoalUnadjusted * 100))%)"
                Bar(title: "Calories", titleFontColor: Color.theme.blackWhite, calories, caloriesGoal, bottomCenterAnnotation: bottomCenterAnnotation, annotationFontColor: Color.theme.blueYellow, progressLineBackground: Color("ProgressLineBackground"), geo: geo)
                Spacer()
            }
        }
    }
}
