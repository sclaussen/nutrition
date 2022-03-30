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
        self.profile = Profile(dateOfBirth: Calendar.current.date(from: components)!, gender: Gender.male, height: 72, bodyMass: 184, bodyFatPercentage: 20, activeCaloriesBurned: 200, proteinRatio: 0.85, calorieDeficit: 20, netCarbsMaximum: 20, meat: "Chicken", meatAmount: 200)
    }

    func cancel() {
        if let json = UserDefaults.standard.data(forKey: "profile"),
           let profile = try? JSONDecoder().decode(Profile.self, from: json) {
            self.profile = profile
        }
    }

    func setBodyMass(bodyMass: Float) {
        self.profile = profile.setBodyMass(bodyMass: bodyMass)
        serialize()
    }

    func setBodyFatPercentage(bodyFatPercentage: Float) {
        self.profile = profile.setBodyFatPercentage(bodyFatPercentage: bodyFatPercentage)
        serialize()
    }

    func setActiveEnergyBurned(activeCaloriesBurned: Float) {
        self.profile = profile.setActiveEnergyBurned(activeCaloriesBurned: activeCaloriesBurned)
        serialize()
    }

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
    var bodyMass: Float
    var bodyFatPercentage: Float
    var activeCaloriesBurned: Float
    var proteinRatio: Float
    var calorieDeficit: Int
    var netCarbsMaximum: Float
    var meat: String
    var meatAmount: Float

    func setBodyMass(bodyMass: Float) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMass: bodyMass, bodyFatPercentage: self.bodyFatPercentage, activeCaloriesBurned: self.activeCaloriesBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netCarbsMaximum: self.netCarbsMaximum, meat: self.meat, meatAmount: self.meatAmount)
    }

    func setBodyFatPercentage(bodyFatPercentage: Float) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMass: self.bodyMass, bodyFatPercentage: bodyFatPercentage, activeCaloriesBurned: self.activeCaloriesBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netCarbsMaximum: self.netCarbsMaximum, meat: self.meat, meatAmount: self.meatAmount)
    }

    func setActiveEnergyBurned(activeCaloriesBurned: Float) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMass: self.bodyMass, bodyFatPercentage: self.bodyFatPercentage, activeCaloriesBurned: activeCaloriesBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netCarbsMaximum: self.netCarbsMaximum, meat: self.meat, meatAmount: self.meatAmount)
    }

    var age: Float {
        set {
        }
        get {
            return Float(Calendar.current.dateComponents([.month], from: self.dateOfBirth, to: Date()).month ?? 0) / 12.0
        }
    }

    var bodyMassKg: Float {
        set {
        }
        get {
            (self.bodyMass * 0.453592).round(1)
        }
    }

    var heightCm: Float {
        set {
        }
        get {
            Float(self.height) * 2.54
        }
    }

    var bodyMassIndex: Float {
        set {
        }
        get {
            (self.bodyMass / Float(self.height * self.height)) * 703
        }
    }

    var fatMass: Float {
        set {
        }
        get {
            (self.bodyMass * (self.bodyFatPercentage / 100)).round(1)
        }
    }

    var leanBodyMass: Float {
        set {
        }
        get {
            (self.bodyMass - self.fatMass).round(1)
        }
    }

    var caloriesBaseMetabolicRate: Float {
        set {
        }
        get {
            return gender == Gender.male ? (self.bodyMassKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 + 5) : (self.bodyMassKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 - 161)
        }
    }

    var caloriesResting: Float {
        set {
        }
        get {
            self.caloriesBaseMetabolicRate * 1.2
        }
    }

    var caloriesGoalUnadjusted: Float {
        set {
        }
        get {
            self.caloriesResting + Float(self.activeCaloriesBurned)
        }
    }

    var fatGoalUnadjusted: Float {
        set {
        }
        get {
            (self.caloriesGoalUnadjusted - ((self.proteinGoalUnadjusted + self.netCarbsMaximum) * 4)) / 9
        }
    }

    var fiberMinimumUnadjusted: Float {
        set {
        }
        get {
            (self.caloriesGoalUnadjusted / 1000) * 14
        }
    }

    var proteinGoalUnadjusted: Float {
        set {
        }
        get {
            self.leanBodyMass * self.proteinRatio
        }
    }

    var fatGoalPercentageUnadjusted: Float {
        set {
        }
        get {
            ((self.fatGoalUnadjusted * 9) / self.caloriesGoalUnadjusted) * 100
        }
    }

    var netCarbsMaximumPercentageUnadjusted: Float {
        set {
        }
        get {
            ((self.netCarbsMaximum * 4) / self.caloriesGoalUnadjusted) * 100
        }
    }

    var proteinGoalPercentageUnadjusted: Float {
        set {
        }
        get {
            ((self.proteinGoalUnadjusted * 4) / self.caloriesGoalUnadjusted) * 100
        }
    }

    var caloriesGoal: Float {
        set {
        }
        get {
            self.caloriesGoalUnadjusted - (self.caloriesGoalUnadjusted * (Float(self.calorieDeficit) / 100))
        }
    }

    var fiberMinimum: Float {
        set {
        }
        get {
            (self.caloriesGoal / 1000) * 14
        }
    }

    var proteinGoal: Float {
        set {
        }
        get {
            self.leanBodyMass * self.proteinRatio
        }
    }

    var fatGoal: Float {
        set {
        }
        get {
            (self.caloriesGoal - ((self.proteinGoal + self.netCarbsMaximum) * 4)) / 9
        }
    }

    var fatGoalPercentage: Float {
        set {
        }
        get {
            ((self.fatGoal * 9) / self.caloriesGoal) * 100
        }
    }

    var netCarbsMaximumPercentage: Float {
        set {
        }
        get {
            ((self.netCarbsMaximum * 4) / self.caloriesGoal) * 100
        }
    }

    var proteinGoalPercentage: Float {
        set {
        }
        get {
            ((self.proteinGoal * 4) / self.caloriesGoal) * 100
        }
    }

    var waterLiters: Float {
        set {
        }
        get {
            (self.bodyMass / 2) * 0.029574
        }
    }
}
