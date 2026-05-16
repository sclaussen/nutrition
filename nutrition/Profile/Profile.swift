import Foundation


// A single protein entry in the user's profile. The profile holds an
// ordered list of these (`Profile.proteins`); the meal generator
// reapplies them as `meat == true` MealIngredients on each
// generateMeal(). Identifiable so the editor sheet can ForEach over
// them; UUID id persists across edits so SwiftUI keeps row identity
// stable while typing.
struct Protein: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var amount: Double

    enum CodingKeys: String, CodingKey {
        case id, name, amount
    }
}


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
        self.profile = Profile(dateOfBirth: Calendar.current.date(from: components)!, gender: Gender.male, height: 72, bodyMassFromHealthKit: true, bodyMass: 222, bodyFatPercentageFromHealthKit: true, bodyFatPercentage: 20, activeCaloriesBurned: 600, proteinRatio: 1.2, calorieDeficit: 20, netCarbsMaximum: 20, proteins: [Protein(name: "Chicken", amount: 200)])
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


    // Replace the entire proteins list. Used by:
    //   - ProteinsEditor (Save button) — commits the draft list
    //   - MealList.applyAmount on meat rows — updates one protein's
    //     amount in-place (via setProteinAmount below) which writes
    //     through this path.
    func setProteins(_ proteins: [Protein]) {
        self.profile = profile.setProteins(proteins)
        serialize()
    }


    // Convenience: update a single protein's amount by name without
    // disturbing the rest of the list. Used when the user steps or
    // types a new amount on a meat row in the meal list.
    func setProteinAmount(name: String, amount: Double) {
        var updated = profile.proteins
        if let idx = updated.firstIndex(where: { $0.name == name }) {
            updated[idx].amount = amount
        } else {
            updated.append(Protein(name: name, amount: amount))
        }
        setProteins(updated)
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
    // List of proteins for the meal. Invariant: never empty (the
    // editor refuses to remove the last row; the user zeros out the
    // grams instead). Order is the order the proteins appear in the
    // meal list.
    var proteins: [Protein]


    // Memberwise init equivalent — explicit so we control the legacy
    // migration path in init(from:) below.
    init(dateOfBirth: Date, gender: Gender, height: Int,
         bodyMassFromHealthKit: Bool, bodyMass: Double,
         bodyFatPercentageFromHealthKit: Bool, bodyFatPercentage: Double,
         activeCaloriesBurned: Double, proteinRatio: Double,
         calorieDeficit: Int, netCarbsMaximum: Double,
         proteins: [Protein]) {
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.height = height
        self.bodyMassFromHealthKit = bodyMassFromHealthKit
        self.bodyMass = bodyMass
        self.bodyFatPercentageFromHealthKit = bodyFatPercentageFromHealthKit
        self.bodyFatPercentage = bodyFatPercentage
        self.activeCaloriesBurned = activeCaloriesBurned
        self.proteinRatio = proteinRatio
        self.calorieDeficit = calorieDeficit
        self.netCarbsMaximum = netCarbsMaximum
        self.proteins = proteins
    }


    // Coding keys list both the new `proteins` field AND the legacy
    // `meat` / `meatAmount` keys so old UserDefaults JSON (encoded
    // before this refactor) can still decode. Encoding only writes
    // the new key — after the first save, the legacy keys disappear.
    enum CodingKeys: String, CodingKey {
        case dateOfBirth, gender, height
        case bodyMassFromHealthKit, bodyMass
        case bodyFatPercentageFromHealthKit, bodyFatPercentage
        case activeCaloriesBurned, proteinRatio, calorieDeficit
        case netCarbsMaximum
        case proteins
        case meat, meatAmount  // legacy — read-only migration source
    }


    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.dateOfBirth = try c.decode(Date.self, forKey: .dateOfBirth)
        self.gender = try c.decode(Gender.self, forKey: .gender)
        self.height = try c.decode(Int.self, forKey: .height)
        self.bodyMassFromHealthKit = try c.decode(Bool.self, forKey: .bodyMassFromHealthKit)
        self.bodyMass = try c.decode(Double.self, forKey: .bodyMass)
        self.bodyFatPercentageFromHealthKit = try c.decode(Bool.self, forKey: .bodyFatPercentageFromHealthKit)
        self.bodyFatPercentage = try c.decode(Double.self, forKey: .bodyFatPercentage)
        self.activeCaloriesBurned = try c.decode(Double.self, forKey: .activeCaloriesBurned)
        self.proteinRatio = try c.decode(Double.self, forKey: .proteinRatio)
        self.calorieDeficit = try c.decode(Int.self, forKey: .calorieDeficit)
        self.netCarbsMaximum = try c.decode(Double.self, forKey: .netCarbsMaximum)

        // Prefer new field; fall back to legacy single-meat shape.
        if let proteins = try c.decodeIfPresent([Protein].self, forKey: .proteins),
           !proteins.isEmpty {
            self.proteins = proteins
        } else if let meat = try c.decodeIfPresent(String.self, forKey: .meat),
                  let meatAmount = try c.decodeIfPresent(Double.self, forKey: .meatAmount),
                  meat != "None" {
            self.proteins = [Protein(name: meat, amount: meatAmount)]
        } else {
            // Existed-but-meatless or brand-new install with no data.
            self.proteins = [Protein(name: "Chicken", amount: 200)]
        }
    }


    // Custom encoder — necessary because CodingKeys includes legacy
    // .meat / .meatAmount (read-only migration sources) which aren't
    // stored as properties, so Swift can't auto-synthesize encode(to:).
    // Only the real fields are written; legacy keys are dropped from
    // the on-disk format on the next save.
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(dateOfBirth, forKey: .dateOfBirth)
        try c.encode(gender, forKey: .gender)
        try c.encode(height, forKey: .height)
        try c.encode(bodyMassFromHealthKit, forKey: .bodyMassFromHealthKit)
        try c.encode(bodyMass, forKey: .bodyMass)
        try c.encode(bodyFatPercentageFromHealthKit, forKey: .bodyFatPercentageFromHealthKit)
        try c.encode(bodyFatPercentage, forKey: .bodyFatPercentage)
        try c.encode(activeCaloriesBurned, forKey: .activeCaloriesBurned)
        try c.encode(proteinRatio, forKey: .proteinRatio)
        try c.encode(calorieDeficit, forKey: .calorieDeficit)
        try c.encode(netCarbsMaximum, forKey: .netCarbsMaximum)
        try c.encode(proteins, forKey: .proteins)
    }


    func setBodyMass(bodyMass: Double) -> Profile {
        var p = self
        p.bodyMass = bodyMass
        return p
    }


    func setBodyFatPercentage(bodyFatPercentage: Double) -> Profile {
        var p = self
        p.bodyFatPercentage = bodyFatPercentage
        return p
    }


    func setProteins(_ proteins: [Protein]) -> Profile {
        var p = self
        p.proteins = proteins
        return p
    }


    // TODO: Update once the health kit active calories algorithm is demystified
    // func setActiveCaloriesBurned(activeCaloriesBurned: Double) -> Profile {
    //     var p = self
    //     p.activeCaloriesBurned = activeCaloriesBurned
    //     return p
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
