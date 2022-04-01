import Foundation

class ProfileMgr: ObservableObject {
    @Published var profile: Profile

    init() {
        if let json = UserDefaults.standard.data(forKey: "profile"),
           let profile = try? JSONDecoder().decode(Profile.self, from: json) {
            self.profile = profile
            return
        }

        print("...creating initial default profile")

        var components = DateComponents()
        components.year = 1967
        components.month = 9
        components.day = 27
        self.profile = Profile(dateOfBirth: Calendar.current.date(from: components)!, gender: Gender.male, height: 72, bodyMassFromHealthKit: true, bodyMass: 184, bodyFatPercentageFromHealthKit: true, bodyFatPercentage: 20, activeCaloriesBurned: 600, proteinRatio: 0.85, calorieDeficit: 20, netCarbsMaximum: 20, meat: "Chicken", meatAmount: 200)
    }

    func cancel() {
        if let json = UserDefaults.standard.data(forKey: "profile"),
           let profile = try? JSONDecoder().decode(Profile.self, from: json) {
            self.profile = profile
        }
    }

    func setBodyMass(bodyMass: Double) {
        self.profile = profile.setBodyMass(bodyMass: bodyMass)
        serialize()
    }

    func setBodyFatPercentage(bodyFatPercentage: Double) {
        self.profile = profile.setBodyFatPercentage(bodyFatPercentage: bodyFatPercentage)
        serialize()
    }

    // TODO: Update once the health kit active calories algorithm is demystified
    // func setActiveCaloriesBurned(activeCaloriesBurned: Double) {
    //     self.profile = profile.setActiveCaloriesBurned(activeCaloriesBurned: activeCaloriesBurned)
    //     serialize()
    // }

    func serialize() {
        if let json = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(json, forKey: "profile")
        }
    }
}

struct Profile: Codable {
    var dateOfBirth: Date
    var gender: Gender
    var height: Int
    var bodyMassFromHealthKit: Bool
    var bodyMass: Double
    var bodyFatPercentageFromHealthKit: Bool
    var bodyFatPercentage: Double
    var activeCaloriesBurned: Double
    var proteinRatio: Double
    var calorieDeficit: Int
    var netCarbsMaximum: Double
    var meat: String
    var meatAmount: Double

    func setBodyMass(bodyMass: Double) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMassFromHealthKit: self.bodyMassFromHealthKit, bodyMass: bodyMass, bodyFatPercentageFromHealthKit: self.bodyFatPercentageFromHealthKit, bodyFatPercentage: self.bodyFatPercentage, activeCaloriesBurned: self.activeCaloriesBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netCarbsMaximum: self.netCarbsMaximum, meat: self.meat, meatAmount: self.meatAmount)
    }

    func setBodyFatPercentage(bodyFatPercentage: Double) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMassFromHealthKit: self.bodyMassFromHealthKit, bodyMass: self.bodyMass, bodyFatPercentageFromHealthKit: self.bodyFatPercentageFromHealthKit, bodyFatPercentage: bodyFatPercentage, activeCaloriesBurned: self.activeCaloriesBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netCarbsMaximum: self.netCarbsMaximum, meat: self.meat, meatAmount: self.meatAmount)
    }

    // TODO: Update once the health kit active calories algorithm is demystified
    // func setActiveCaloriesBurned(activeCaloriesBurned: Double) -> Profile {
    //     return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMassFromHealthKit: self.bodyMassFromHealthKit, bodyMass: self.bodyMass, bodyFatPercentageFromHealthKit: self.bodyFatPercentageFromHealthKit, bodyFatPercentage: self.bodyFatPercentage, activeCaloriesBurned: activeCaloriesBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netCarbsMaximum: self.netCarbsMaximum, meat: self.meat, meatAmount: self.meatAmount)
    // }

    var age: Double {
        set {
        }
        get {
            return Double(Calendar.current.dateComponents([.month], from: self.dateOfBirth, to: Date()).month ?? 0) / 12.0
        }
    }

    var bodyMassKg: Double {
        set {
        }
        get {
            (self.bodyMass * 0.453592).round(1)
        }
    }

    var heightCm: Double {
        set {
        }
        get {
            Double(self.height) * 2.54
        }
    }

    var bodyMassIndex: Double {
        set {
        }
        get {
            (self.bodyMass / Double(self.height * self.height)) * 703
        }
    }

    var fatMass: Double {
        set {
        }
        get {
            (self.bodyMass * (self.bodyFatPercentage / 100)).round(1)
        }
    }

    var leanBodyMass: Double {
        set {
        }
        get {
            (self.bodyMass - self.fatMass).round(1)
        }
    }

    var caloriesBaseMetabolicRate: Double {
        set {
        }
        get {
            return gender == Gender.male ? (self.bodyMassKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 + 5) : (self.bodyMassKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 - 161)
        }
    }

    var caloriesResting: Double {
        set {
        }
        get {
            self.caloriesBaseMetabolicRate * 1.2
        }
    }

    var caloriesGoalUnadjusted: Double {
        set {
        }
        get {
            self.caloriesResting + Double(self.activeCaloriesBurned)
        }
    }

    var fatGoalUnadjusted: Double {
        set {
        }
        get {
            (self.caloriesGoalUnadjusted - ((self.proteinGoalUnadjusted + self.netCarbsMaximum) * 4)) / 9
        }
    }

    var fiberMinimumUnadjusted: Double {
        set {
        }
        get {
            (self.caloriesGoalUnadjusted / 1000) * 14
        }
    }

    var proteinGoalUnadjusted: Double {
        set {
        }
        get {
            self.leanBodyMass * self.proteinRatio
        }
    }

    var fatGoalPercentageUnadjusted: Double {
        set {
        }
        get {
            ((self.fatGoalUnadjusted * 9) / self.caloriesGoalUnadjusted) * 100
        }
    }

    var netCarbsMaximumPercentageUnadjusted: Double {
        set {
        }
        get {
            ((self.netCarbsMaximum * 4) / self.caloriesGoalUnadjusted) * 100
        }
    }

    var proteinGoalPercentageUnadjusted: Double {
        set {
        }
        get {
            ((self.proteinGoalUnadjusted * 4) / self.caloriesGoalUnadjusted) * 100
        }
    }

    var caloriesGoal: Double {
        set {
        }
        get {
            self.caloriesGoalUnadjusted - (self.caloriesGoalUnadjusted * (Double(self.calorieDeficit) / 100))
        }
    }

    var fiberMinimum: Double {
        set {
        }
        get {
            (self.caloriesGoal / 1000) * 14
        }
    }

    var proteinGoal: Double {
        set {
        }
        get {
            self.leanBodyMass * self.proteinRatio
        }
    }

    var fatGoal: Double {
        set {
        }
        get {
            (self.caloriesGoal - ((self.proteinGoal + self.netCarbsMaximum) * 4)) / 9
        }
    }

    var fatGoalPercentage: Double {
        set {
        }
        get {
            ((self.fatGoal * 9) / self.caloriesGoal) * 100
        }
    }

    var netCarbsMaximumPercentage: Double {
        set {
        }
        get {
            ((self.netCarbsMaximum * 4) / self.caloriesGoal) * 100
        }
    }

    var proteinGoalPercentage: Double {
        set {
        }
        get {
            ((self.proteinGoal * 4) / self.caloriesGoal) * 100
        }
    }

    var waterLiters: Double {
        set {
        }
        get {
            (self.bodyMass / 2) * 0.029574
        }
    }
}
