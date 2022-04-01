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
                    Gauge(title: "Weight", titleFontColor: Color("Black"), bodyMass, actualPrecision: 1, annotationFontColor: Color("Blue"), unit: "lbs", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Fat %", titleFontColor: Color("Black"), bodyFatPercentage, actualPrecision: 1, annotationFontColor: Color("Blue"), unit: "%", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Activity", titleFontColor: Color("Black"), activeCaloriesBurned, annotationFontColor: Color("Blue"), unit: "cal", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Deficit", titleFontColor: Color("Black"), Double(calorieDeficit), annotationFontColor: Color("Blue"), unit: "%", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Gauge(title: "Ratio", titleFontColor: Color("Black"), proteinRatio, actualPrecision: 2, annotationFontColor: Color("Blue"), unit: "g/lbm", progressLineBackground: Color("ProgressLineBackground"), type: .value, scale: 0.8)
                    Spacer()
                }
                  .padding(.bottom, 30)

                HStack(spacing: 0) {
                    Spacer()
                    Gauge(title: "Fat", titleFontColor: Color("Black"), fat, fatGoal, annotationFontColor: Color("Blue"), unit: "grams", progressLineBackground: Color("ProgressLineBackground"))
                    Spacer()
                    Gauge(title: "Fiber", titleFontColor: Color("Black"), fiber, fiberMinimum, annotationFontColor: Color("Blue"), unit: "grams", progressLineBackground: Color("ProgressLineBackground"), type: .floor)
                    Spacer()
                    Gauge(title: "NCarbs", titleFontColor: Color("Black"), netCarbs, actualPrecision: 1, netCarbsMaximum, annotationFontColor: Color("Blue"), unit: "grams", progressLineBackground: Color("ProgressLineBackground"), type: .ceiling)
                    Spacer()
                    Gauge(title: "Protein", titleFontColor: Color("Black"), protein, proteinGoal, annotationFontColor: Color("Blue"), unit: "grams", progressLineBackground: Color("ProgressLineBackground"))
                    Spacer()
                }
                  .padding(.bottom, 6)

                let bottomCenterAnnotation = "\(Int(calories)) of \(Int(caloriesGoalUnadjusted)) (\(Int(calories - caloriesGoalUnadjusted)), \(Int((calories - caloriesGoalUnadjusted) / caloriesGoalUnadjusted * 100))%)"
                Bar(title: "Calories", titleFontColor: Color("Black"), calories, caloriesGoal, bottomCenterAnnotation: bottomCenterAnnotation, annotationFontColor: Color("Blue"), progressLineBackground: Color("ProgressLineBackground"), geo: geo)
                Spacer()
            }
        }
    }
}
