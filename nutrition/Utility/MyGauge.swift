import Foundation
import SwiftUI

enum GaugeType {
    case Goal
    case Ceiling
    case Floor
    case FYI
}

struct MyGaugeDashboard: View {
    let caloriesGoalUnadjusted: Double
    let caloriesGoal: Double
    let fatGoal: Double
    let fiberGoal: Double
    let netcarbsGoal: Double
    let proteinGoal: Double
    let calories: Double
    let fat: Double
    let fiber: Double
    let netcarbs: Double
    let protein: Double

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer()
                MyGauge(title: "Fat", value: fat, goal: fatGoal)
                Spacer()
                MyGauge(title: "Fiber", value: fiber, goal: fiberGoal, gaugeType: GaugeType.Floor)
                Spacer()
                MyGauge(title: "NCarbs", value: netcarbs, goal: netcarbsGoal, precision: 1, gaugeType: GaugeType.Ceiling)
                Spacer()
                MyGauge(title: "Protein", value: protein, goal: proteinGoal)
                Spacer()
            }
            MyProgressBar(title: "Calories", value: calories, goal: caloriesGoal, goalUnadjusted: caloriesGoalUnadjusted)
        }
    }
}

struct MyProgressBar: View {
    var title: String
    var value: Double
    var goal: Double
    var goalUnadjusted: Double

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

        let bottomLeftAnnotation = String(Int(goal)) + "/" + ((value < goal) ? "-" : "+") + String(Int(abs(goal - value))) + "/" + String(Int(abs(((goal - value) / goal) * 100))) + "%"
        let bottomRightAnnotation = String(Int(goalUnadjusted)) + "/" + ((value < goalUnadjusted) ? "-" : "+") + String(Int(abs(goalUnadjusted - value))) + "/" + String(Int(abs(((goalUnadjusted - value) / goalUnadjusted) * 100))) + "%"
        let bottomCenterAnnotation = String(Int(value))

        return
          VStack(spacing: 1) {
              HStack {
                  Text(topLeftAnnotation).font(.system(size: goalFontSize)).frame(width: screenWidth * 0.3, alignment: .leading).padding([.leading, .trailing], screenWidth * 0.03)
                  Spacer()
                  Text(title).font(.system(size: titleFontSize)).bold().frame(alignment: .center)
                  Spacer()
                  Text(topRightAnnotation).font(.system(size: goalFontSize)).frame(width: screenWidth * 0.3, alignment: .trailing).padding([.leading, .trailing], screenWidth * 0.03)
              }
              ZStack {
                  Rectangle()
                    .frame(width: screenWidth * 0.90, height: 12)
                    .foregroundColor(Color.yellow.opacity(0.5))
                  Rectangle()
                    .frame(width: min((value / goal) * screenWidth * 0.90, screenWidth * 0.90), height: 12, alignment: .leading)
                    .foregroundColor(progressBarColor.opacity(0.9))
              }.cornerRadius(50)
              HStack {
                  Text(bottomLeftAnnotation).font(.system(size: goalFontSize)).frame(alignment: .leading).padding([.leading, .trailing], screenWidth * 0.03)
                  Spacer()
                  Text(bottomCenterAnnotation).font(.system(size: calorieFontSize)).bold().frame(alignment: .leading).padding([.leading, .trailing], screenWidth * 0.03)
                  Spacer()
                  Text(bottomRightAnnotation).font(.system(size: goalFontSize)).frame(alignment: .trailing).padding([.leading, .trailing], screenWidth * 0.03)
              }
          }
    }
}

struct MyGauge: View {
    var title: String
    var value: Double
    var goal: Double
    var precision: Int = 0
    var gaugeType: GaugeType = GaugeType.Goal

    var width: CGFloat = 60.0
    var lineWidth: CGFloat = 13.0

    var titleFontSize: CGFloat = 16
    var valueFontSize: CGFloat = 20
    var goalFontSize: CGFloat = 12

    var titleOffset: Double = 7
    var goalOffset: Double = 18

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

            Text(title).font(.system(size: titleFontSize)).bold().offset(y: titleOffset)

            ZStack {
                Circle()
                  .rotation(Angle(degrees: 135.0))
                  .trim(from: 0.0, to: 0.75)
                  .stroke(Color.red.opacity(0.5), lineWidth: lineWidth)
                  .frame(width: width, height: width)

                Circle()
                  .rotation(Angle(degrees: 135.0))
                  .trim(from: 0.0, to: progressBar)
                  .stroke(progressBarColor.opacity(0.9), lineWidth: lineWidth)
                  .frame(width: width, height: width)

                Text("\(value.fractionDigits(max: precision))").font(.system(size: valueFontSize)).bold().foregroundColor(.blue)
                Text(String(Int(goal))).font(.system(size: goalFontSize)).offset(y: goalOffset)
            }.cornerRadius(50)
        }
    }
}
