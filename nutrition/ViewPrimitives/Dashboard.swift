import Foundation
import SwiftUI

enum GaugeType {
    case Goal
    case Ceiling
    case Floor
    case FYI
}

struct Dashboard: View {
    let bodyMass: String
    let bodyFatPercentage: String
    let proteinRatio: String
    let calorieDeficit: String
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
        bodyMass = String(profile.bodyMass.string(1))
        bodyFatPercentage = String(profile.bodyFatPercentage.string(1)) + "%"
        proteinRatio = String(profile.proteinRatio.string(2))
        calorieDeficit = String(profile.calorieDeficit.string())
        activeCaloriesBurned = String(profile.activeCaloriesBurned.string(0)) + "cal"
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
        GeometryReader { geo in
            VStack(spacing: 0) {

                HStack {
                    VStack(spacing: 0) {
                        Text("Wt/Body Fat")
                          .font(.caption)
                          .bold()
                        Text("\(bodyMass)/\(bodyFatPercentage)")
                          .font(.caption)
                          .foregroundColor(.primary)
                    }.frame(width: geo.size.width / 5)
                    VStack(spacing: 0) {
                        Text("Active")
                          .font(.caption)
                          .bold()
                        Text("\(activeCaloriesBurned)")
                          .font(.caption)
                          .foregroundColor(.primary)
                    }.frame(width: geo.size.width / 5)
                    VStack(spacing: 0) {
                        Text("Ratio")
                          .font(.caption)
                          .bold()
                        Text("\(proteinRatio)")
                          .font(.caption)
                          .foregroundColor(.primary)
                    }.frame(width: geo.size.width / 5)
                    VStack(spacing: 0) {
                        Text("Deficit")
                          .font(.caption)
                          .bold()
                        Text("\(calorieDeficit)%")
                          .font(.caption)
                          .foregroundColor(.primary)
                    }.frame(width: geo.size.width / 5)
                }
                  .border(Color.red, width: 0)
                  .padding(.top, 5)

                HStack(spacing: 0) {
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
                  .border(Color.red, width: 0)
                  .padding(.top, 5)

                CalorieProgressBar(geo: geo, title: "Calories", value: calories, goal: caloriesGoal, goalUnadjusted: caloriesGoalUnadjusted)
                  .border(Color.red, width: 0)
                  .padding(.top, 5)
            }
              .border(Color.orange, width: 0)
        }
          .border(Color("Blue"), width: 1)
    }
}


// TODO: Update to make this generic
struct CalorieProgressBar: View {
    var geo: GeometryProxy
    var title: String
    var value: Float
    var goal: Float
    var goalUnadjusted: Float

    let titleFontSize = 14.0
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

        let gap = value - goalUnadjusted
        let valueString = String(Int(value))
        let goalUnadjustedString = String(Int(goalUnadjusted))
        let gapString = String(Int(gap))
        let gapPercentageString = String(Int(abs((gap / goalUnadjusted) * 100)))
        let bottomCenterAnnotation = "\(valueString) of \(goalUnadjustedString) (\(gapString) / \(gapPercentageString)%)"

        return
          VStack(spacing: 1) {

              Text(title)
                .font(.system(size: titleFontSize))
                .bold()
                .frame(alignment: .center)

              ZStack(alignment: .leading) {
                  Rectangle()
                    .frame(width: geo.size.width * 0.9, height: 12)
                    .foregroundColor(Color.primary.opacity(0.9))
                  Rectangle()
                    .frame(width: min(Double((value / goal)) * geo.size.width * 0.9, geo.size.width * 0.9), height: 12, alignment: .leading)
                    .foregroundColor(progressBarColor.opacity(1))
              }
                .cornerRadius(50)

              Text(bottomCenterAnnotation)
                .font(.system(size: calorieFontSize))
                .frame(alignment: .center)
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

    var titleFontSize: CGFloat = 14
    var valueFontSize: CGFloat = 20
    var goalFontSize: CGFloat = 12

    var titleOffset: Float = 11
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
