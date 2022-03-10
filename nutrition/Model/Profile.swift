import Foundation

class ProfileMgr: ObservableObject {

    @Published var profile: Profile? {
        didSet {
            serialize()
        }
    }

    init() {
        if let json = UserDefaults.standard.data(forKey: "profile") {
            if let profile = try? JSONDecoder().decode(Profile.self, from: json) {
                self.profile = profile

                // Minor hack to force profile.compute() to execute
                self.profile!.weight = self.profile!.weight
                return
            }
        }

        var components = DateComponents()
        components.year = 1967
        components.month = 9
        components.day = 27
        let profile: Profile = Profile(name: "", dateOfBirth: Calendar.current.date(from: components)!, gender: 0, height: 72, weight: 184, bodyFat: 20.0, activeEnergy: 200, proteinRatio: 0.85, calorieDeficit: 20, netcarbsGoalUnadjusted: 20)
        if let json = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(json, forKey: "profile")
            self.profile = profile
            print("Deserializing profie: " + String(self.profile!.id))
            print("Weight: " + String(self.profile!.weight))
        }
    }

    func serialize() {
        if let json = try? JSONEncoder().encode(self.profile) {
            print("Serializing profile: ")
            UserDefaults.standard.set(json, forKey: "profile")
        }
    }

    func update(_ profile: Profile) {
        print("Updating profie: ")
        self.profile = profile.update(profile: profile)
    }
}

class Profile: Codable, ObservableObject {
    var id: String
    var name: String
    var dateOfBirth: Date
    var gender: Int
    var height: Int
    var weight: Double
    var bodyFat: Double
    var activeEnergy: Int
    var proteinRatio: Double
    var calorieDeficit: Int
    var netcarbsGoalUnadjusted: Double

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
        if self.gender == 0 {
            return (self.weightKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 + 5)
        } else {
            return (self.weightKg * 9.99) + (self.heightCm * 6.25) - (self.age * 4.92 - 161)
        }
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

    init(id: String = UUID().uuidString, name: String, dateOfBirth: Date, gender: Int, height: Int, weight: Double, bodyFat: Double, activeEnergy: Int, proteinRatio: Double, calorieDeficit: Int, netcarbsGoalUnadjusted: Double) {
        print("Creating profile: ")

        self.id = id
        self.name = name

        self.dateOfBirth = dateOfBirth
        self.gender = gender

        self.height = height
        self.weight = weight
        self.bodyFat = bodyFat
        self.activeEnergy = activeEnergy

        self.proteinRatio = proteinRatio
        self.calorieDeficit = calorieDeficit
        
        self.netcarbsGoalUnadjusted = netcarbsGoalUnadjusted
    }

    func update(profile: Profile) -> Profile {
        return Profile(id: profile.id, name: profile.name, dateOfBirth: profile.dateOfBirth, gender: profile.gender, height: profile.height, weight: profile.weight, bodyFat: profile.bodyFat, activeEnergy: profile.activeEnergy, proteinRatio: profile.proteinRatio, calorieDeficit: profile.calorieDeficit, netcarbsGoalUnadjusted: profile.netcarbsGoalUnadjusted)
    }
}
