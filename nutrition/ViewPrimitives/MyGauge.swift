import Foundation
import SwiftUI

enum GaugeType {
    case Goal
    case Ceiling
    case Floor
    case FYI
}

struct MyGaugeDashboard: View {
    let bodyMass: String
    let bodyFatPercentage: String
    let activeCaloriesBurned: String
    let caloriesGoalUnadjusted: Float
    let caloriesGoal: Float
    let fatGoal: Float
    let fiberMinimum: Float
    let netCarbsMaximum: Float
    let proteinGoal: Float
    let calories: Float
    let fat: Float
    let fiber: Float
    let netCarbs: Float
    let protein: Float

    init(_ profile: Profile, _ macros: Macros) {
        bodyMass = String(profile.bodyMass.string(1)) + " lb"
        bodyFatPercentage = String(profile.bodyFatPercentage.string(1)) + "%"
        activeCaloriesBurned = String(profile.activeCaloriesBurned.string(0)) + " cal"
        caloriesGoalUnadjusted = macros.caloriesGoalUnadjusted
        caloriesGoal = macros.caloriesGoal
        fatGoal = macros.fatGoal
        fiberMinimum = macros.fiberMinimum
        netCarbsMaximum = macros.netCarbsMaximum
        proteinGoal = macros.proteinGoal
        calories = macros.calories
        fat = macros.fat
        fiber = macros.fiber
        netCarbs = macros.netCarbs
        protein = macros.protein
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("\(bodyMass)         \(bodyFatPercentage)         \(activeCaloriesBurned)")
              .font(.callout)
              .frame(alignment: .center)
              .foregroundColor(.primary)

            HStack {
                Spacer()
                MyGauge(title: "Fat", value: fat, goal: fatGoal)
                Spacer()
                MyGauge(title: "Fiber", value: fiber, goal: fiberMinimum, gaugeType: GaugeType.Floor)
                Spacer()
                MyGauge(title: "NCarbs", value: netCarbs, goal: netCarbsMaximum, precision: 1, gaugeType: GaugeType.Ceiling)
                Spacer()
                MyGauge(title: "Protein", value: protein, goal: proteinGoal)
                Spacer()
            }
              .padding(.top)

            CalorieProgressBar(title: "Calories", value: calories, goal: caloriesGoal, goalUnadjusted: caloriesGoalUnadjusted)
              .padding(.top)
        }
    }
}

// TODO: Update to make this generic
struct CalorieProgressBar: View {
    var title: String
    var value: Float
    var goal: Float
    var goalUnadjusted: Float

    // TODO: Figure out how to use GeometryReader to calculate the screenWidth
    let screenWidth = 390.0
    let titleFontSize = 16.0
    let calorieFontSize = 14.0
    let goalFontSize = 12.0

    var body: some View {
        let percentage = value / goal * 100
        var progressBarColor = Color.yellow
        if percentage > 90 && percentage < 110 {
            progressBarColor = Color.green
        } else if percentage >= 110 {
            progressBarColor = Color.red
        }

        let topLeftAnnotation = "Deficit"
        let topRightAnnotation = "Unadjusted"

        let bottomLeftAnnotation = String(Int(goal)) + "/" + ((value < goal) ? "-" : "+") + String(Int(abs(goal - value)))
        let bottomRightAnnotation = String(Int(goalUnadjusted)) + "/" + ((value < goalUnadjusted) ? "-" : "+") + String(Int(abs(goalUnadjusted - value)))
        let bottomCenterAnnotation = String(Int(value))

        return VStack(spacing: 1) {
            HStack {
                Text(topLeftAnnotation).font(.system(size: goalFontSize)).frame(width: screenWidth * 0.3, alignment: .leading).padding([.leading, .trailing], screenWidth * 0.03)
                Spacer()
                Text(title).font(.system(size: titleFontSize)).bold().frame(alignment: .center)
                Spacer()
                Text(topRightAnnotation).font(.system(size: goalFontSize)).frame(width: screenWidth * 0.3, alignment: .trailing).padding([.leading, .trailing], screenWidth * 0.03)
            }
            ZStack(alignment: .leading) {
                Rectangle()
                  .frame(width: screenWidth * 0.90, height: 12)
                  .foregroundColor(Color.primary.opacity(0.5))
                Rectangle()
                  .frame(width: min(Double((value / goal)) * screenWidth * 0.90, screenWidth * 0.90), height: 12, alignment: .leading)
                  .foregroundColor(progressBarColor.opacity(0.9))
            }.cornerRadius(50)

            HStack {
                Text(bottomLeftAnnotation)
                  .font(.system(size: goalFontSize))
                  .frame(alignment: .leading)
                  .padding([.leading, .trailing], screenWidth * 0.03)
                Spacer()
                Text(bottomCenterAnnotation)
                  .font(.system(size: calorieFontSize))
                  .bold().frame(alignment: .leading)
                  .padding([.leading, .trailing], screenWidth * 0.03)
                Spacer()
                Text(bottomRightAnnotation)
                  .font(.system(size: goalFontSize))
                  .frame(alignment: .trailing)
                  .padding([.leading, .trailing], screenWidth * 0.03)
            }
        }
    }
}

struct MyGauge: View {
    var title: String
    var value: Float
    var goal: Float
    var precision: Int = 0
    var gaugeType: GaugeType = GaugeType.Goal

    var width: CGFloat = 60.0
    var lineWidth: CGFloat = 15.0

    var titleFontSize: CGFloat = 16
    var valueFontSize: CGFloat = 20
    var goalFontSize: CGFloat = 12

    var titleOffset: Float = 7
    var goalOffset: Float = 18

    var body: some View {
        let progressPercentage = (value / goal) * 100
        var progressBar = progressPercentage / 100 * 0.75
        if progressPercentage > 100 {
            progressBar = 0.75
        }

        var progressBarColor = Color.yellow
        switch (gaugeType) {
        case GaugeType.FYI:
            progressBarColor = Color.green
            break
        case GaugeType.Ceiling:
            if value > goal {
                progressBarColor = Color.red
            } else {
                progressBarColor = Color.green
            }
            break
        case GaugeType.Floor:
            if value >= goal {
                progressBarColor = Color.green
            } else if abs(((goal - value) / goal) * 100) > 10 {
                progressBarColor = Color.red
            }
            break
        case GaugeType.Goal:
            if abs(((goal - value) / goal) * 100) < 5 {
                progressBarColor = Color.green
            } else if abs(((goal - value) / goal) * 100) > 10 {
                progressBarColor = Color.red
            }
            break
        }

        return VStack {

            Text(title)
              .font(.system(size: titleFontSize))
              .bold()
              .offset(y: CGFloat(titleOffset))

            ZStack {
                Circle()
                  .trim(from: 0.0, to: 0.75)
                  .stroke(Color.primary.opacity(0.3), style: StrokeStyle(lineWidth: lineWidth))
                  .rotationEffect(Angle(degrees: 135.0))
                  .frame(width: width, height: width)

                Circle()
                  .trim(from: 0.0, to: CGFloat(progressBar))
                  .stroke(progressBarColor.opacity(0.9), style: StrokeStyle(lineWidth: lineWidth))
                  .rotationEffect(Angle(degrees: 135.0))
                  .frame(width: width, height: width)

                Text("\(value.string(precision))")
                  .foregroundColor(Color("Blue"))
                  .font(.system(size: valueFontSize))
                  .bold()

                Text(String(Int(goal)))
                  .foregroundColor(Color("Blue"))
                  .font(.system(size: goalFontSize))
                  .offset(y: CGFloat(goalOffset))
            }
              .cornerRadius(50)
        }
    }
}
