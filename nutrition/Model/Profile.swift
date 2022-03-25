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
        self.profile = Profile(dateOfBirth: Calendar.current.date(from: components)!, gender: Gender.male, height: 72, bodyMass: 184, bodyFatPercentage: 20, activeEnergyBurned: 200, proteinRatio: 0.85, calorieDeficit: 20, netcarbsGoalUnadjusted: 20, meat: "Chicken", meatAmount: 200)
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

    func setActiveEnergyBurned(activeEnergyBurned: Double) {
        self.profile = profile.setActiveEnergyBurned(activeEnergyBurned: activeEnergyBurned)
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
    var bodyMass: Double
    var bodyFatPercentage: Double
    var activeEnergyBurned: Double
    var proteinRatio: Double
    var calorieDeficit: Int
    var netcarbsGoalUnadjusted: Double
    var meat: String
    var meatAmount: Double

    func setBodyMass(bodyMass: Double) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMass: bodyMass, bodyFatPercentage: self.bodyFatPercentage, activeEnergyBurned: self.activeEnergyBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netcarbsGoalUnadjusted: self.netcarbsGoalUnadjusted, meat: self.meat, meatAmount: self.meatAmount)
    }

    func setBodyFatPercentage(bodyFatPercentage: Double) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMass: self.bodyMass, bodyFatPercentage: bodyFatPercentage, activeEnergyBurned: self.activeEnergyBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netcarbsGoalUnadjusted: self.netcarbsGoalUnadjusted, meat: self.meat, meatAmount: self.meatAmount)
    }

    func setActiveEnergyBurned(activeEnergyBurned: Double) -> Profile {
        return Profile(dateOfBirth: self.dateOfBirth, gender: self.gender, height: self.height, bodyMass: self.bodyMass, bodyFatPercentage: self.bodyFatPercentage, activeEnergyBurned: activeEnergyBurned, proteinRatio: self.proteinRatio, calorieDeficit: self.calorieDeficit, netcarbsGoalUnadjusted: self.netcarbsGoalUnadjusted, meat: self.meat, meatAmount: self.meatAmount)
    }

    var age: Double {
        let ageInMonths = Calendar.current.dateComponents([.month], from: self.dateOfBirth, to: Date()).month ?? 0
        return Double(ageInMonths) / 12.0
    }

    var bodyMassKg: Double {
        (self.bodyMass * 0.453592).round(1)
    }

    var heightCm: Double {
        Double(self.height) * 2.54
    }

    var bodyMassIndex: Double {
        (self.bodyMass / Double(self.height * self.height)) * 703
    }

    var fatMass: Double {
        (self.bodyMass * (self.bodyFatPercentage / 100)).round(1)
    }

    var leanBodyMass: Double {
        (self.bodyMass - self.fatMass).round(1)
    }

    var caloriesBaseMetabolicRate: Double {
        if gender == Gender.male {
            return (self.bodyMassKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 + 5)
        }

        return (self.bodyMassKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 - 161)
    }

    var caloriesResting: Double {
        self.caloriesBaseMetabolicRate * 1.2
    }

    var caloriesGoalUnadjusted: Double {
        self.caloriesResting + Double(self.activeEnergyBurned)
    }

    var fatGoalUnadjusted: Double {
        (self.caloriesGoalUnadjusted - ((self.proteinGoalUnadjusted + self.netcarbsGoalUnadjusted) * 4)) / 9
    }

    var fiberGoalUnadjusted: Double {
        (self.caloriesGoalUnadjusted / 1000) * 14
    }

    var proteinGoalUnadjusted: Double {
        self.leanBodyMass * self.proteinRatio
    }

    var fatGoalPercentageUnadjusted: Double {
        ((self.fatGoalUnadjusted * 9) / self.caloriesGoalUnadjusted) * 100
    }

    var netcarbsGoalPercentageUnadjusted: Double {
        ((self.netcarbsGoalUnadjusted * 4) / self.caloriesGoalUnadjusted) * 100
    }

    var proteinGoalPercentageUnadjusted: Double {
        ((self.proteinGoalUnadjusted * 4) / self.caloriesGoalUnadjusted) * 100
    }

    var caloriesGoal: Double {
        self.caloriesGoalUnadjusted - (self.caloriesGoalUnadjusted * (Double(self.calorieDeficit) / 100))
    }

    var fiberGoal: Double {
        (self.caloriesGoal / 1000) * 14
    }

    var netcarbsGoal: Double {
        self.netcarbsGoalUnadjusted
    }

    var proteinGoal: Double {
        self.leanBodyMass * self.proteinRatio
    }

    var fatGoal: Double {
        (self.caloriesGoal - ((self.proteinGoal + self.netcarbsGoal) * 4)) / 9
    }

    var fatGoalPercentage: Double {
        ((self.fatGoal * 9) / self.caloriesGoal) * 100
    }

    var netcarbsGoalPercentage: Double {
        ((self.netcarbsGoal * 4) / self.caloriesGoal) * 100
    }

    var proteinGoalPercentage: Double {
        ((self.proteinGoal * 4) / self.caloriesGoal) * 100
    }

    var waterLiters: Double {
        (self.bodyMass / 2) * 0.029574
    }
}
