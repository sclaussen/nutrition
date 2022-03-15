import Foundation

class ProfileMgr: ObservableObject {
    @Published var profile: Profile

    init() {
        if let json = UserDefaults.standard.data(forKey: "profile"),
           let profile = try? JSONDecoder().decode(Profile.self, from: json) {
            self.profile = profile
            print("...deserialized [")
            print("]")
            return
        }

        print("...creating initial default profile")

        var components = DateComponents()
        components.year = 1967
        components.month = 9
        components.day = 27
        self.profile = Profile(dateOfBirth: Calendar.current.date(from: components)!, gender: Gender.male, height: 72, weight: 184, bodyFat: 20, activeEnergy: 200, proteinRatio: 0.85, calorieDeficit: 20, netcarbsGoalUnadjusted: 20, meat: "Chicken", meatAmount: 200)
    }

    func cancel() {
        if let json = UserDefaults.standard.data(forKey: "profile"),
           let profile = try? JSONDecoder().decode(Profile.self, from: json) {
            self.profile = profile
            print("...deserialized [")
            print("]")
        }
    }

    func save() {
        if let json = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(json, forKey: "profile")
            print("...serialized [")
            print("]")
        }
    }
}

struct Profile: Codable {
    var dateOfBirth: Date {
        didSet {
            print("dateOfBirth \(dateOfBirth)")
        }
    }
    var gender: Gender {
        didSet {
            print("gender \(gender)")
        }
    }
    var height: Int {
        didSet {
            print("height \(height)")
        }
    }
    var weight: Double {
        didSet {
            print("weight \(weight)")
        }
    }
    var bodyFat: Double {
        didSet {
            print("bodyFat \(bodyFat)")
        }
    }
    var activeEnergy: Int {
        didSet {
            print("activeEnergy \(activeEnergy)")
        }
    }
    var proteinRatio: Double {
        didSet {
            print("proteinRatio \(proteinRatio)")
        }
    }
    var calorieDeficit: Int {
        didSet {
            print("calorieDeficit \(calorieDeficit)")
        }
    }
    var netcarbsGoalUnadjusted: Double {
        didSet {
            print("netcarbsGoalUnadjusted \(netcarbsGoalUnadjusted)")
        }
    }
    var meat: String {
        didSet {
            print("meat \(meat)")
        }
    }
    var meatAmount: Double {
        didSet {
            print("meatAmount \(meatAmount)")
        }
    }

    var age: Double {
        let ageInMonths = Calendar.current.dateComponents([.month], from: self.dateOfBirth, to: Date()).month ?? 0
        return Double(ageInMonths) / 12.0
    }

    var weightKg: Double {
        (self.weight * 0.453592).round(1)
    }

    var heightCm: Double {
        Double(self.height) * 2.54
    }

    var bodyMassIndex: Double {
        (self.weight / Double(self.height * self.height)) * 703
    }

    var fatMass: Double {
        (self.weight * (self.bodyFat / 100)).round(1)
    }

    var leanBodyMass: Double {
        (self.weight - self.fatMass).round(1)
    }

    var caloriesBaseMetabolicRate: Double {
        if gender == Gender.male {
            return (self.weightKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 + 5)
        }

        return (self.weightKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 - 161)
    }

    var caloriesResting: Double {
        self.caloriesBaseMetabolicRate * 1.2
    }

    var caloriesGoalUnadjusted: Double {
        self.caloriesResting + Double(self.activeEnergy)
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
        (self.weight / 2) * 0.029574
    }
}
