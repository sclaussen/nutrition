import Foundation


class ProfileMgr: ObservableObject {


    // Full set of profiles. UI binds to `profile` (the active one); the
    // array here is the source of truth for persistence and lets the
    // Profile page switch between them.
    @Published var profiles: [Profile] = [] {
        didSet { saveProfiles() }
    }


    // The active profile. Existing call sites continue to read
    // `profileMgr.profile.X` and bind `$profileMgr.profile.X` —
    // unchanged. The didSet mirrors any edit back into `profiles[i]`
    // so the list stays in lock-step (and the change persists via
    // profiles' own didSet).
    @Published var profile: Profile {
        didSet {
            guard let i = profiles.firstIndex(where: { $0.id == profile.id }) else {
                profiles.append(profile)
                return
            }
            if profiles[i] != profile { profiles[i] = profile }
        }
    }


    init() {
        // 1. New schema: array of profiles + active id.
        if let arr = Self.loadProfiles(), !arr.isEmpty {
            self.profiles = arr
            let activeId = UserDefaults.standard.string(forKey: "activeProfileId")
            self.profile = arr.first(where: { $0.id == activeId }) ?? arr[0]
        }
        // 2. Migrate from the old single-profile schema (key "profile").
        // The custom Profile.init(from:) handles the missing id/name.
        else if let data = UserDefaults.standard.data(forKey: "profile"),
                var migrated = try? JSONDecoder().decode(Profile.self, from: data) {
            if migrated.id.isEmpty { migrated.id = UUID().uuidString }
            if migrated.name.isEmpty { migrated.name = "Shane" }
            self.profiles = [migrated]
            self.profile = migrated
            UserDefaults.standard.set(migrated.id, forKey: "activeProfileId")
        }
        // 3. Fresh install — seed Shane's default profile.
        else {
            print("...creating initial default profile")
            var components = DateComponents()
            components.year = 1967
            components.month = 9
            components.day = 27
            let seed = Profile(
                name: "Shane",
                dateOfBirth: Calendar.current.date(from: components)!,
                gender: .male, height: 72,
                bodyMassFromHealthKit: true, bodyMass: 222,
                bodyFatPercentageFromHealthKit: true, bodyFatPercentage: 20,
                activeCaloriesBurned: 600,
                proteinRatio: 1.2, calorieDeficit: 20, netCarbsMaximum: 20)
            self.profiles = [seed]
            self.profile = seed
            UserDefaults.standard.set(seed.id, forKey: "activeProfileId")
        }

        // One-time backfill: add Caden's profile to existing single-
        // profile installs (fresh installs would also receive him via
        // this path; the flag stops us re-adding after a rename/delete).
        let backfillKey = "didSeedSecondaryProfile.caden"
        if !UserDefaults.standard.bool(forKey: backfillKey) {
            if !profiles.contains(where: { $0.name == "Caden Claussen" }) {
                profiles.append(Self.cadenSeed())
            }
            UserDefaults.standard.set(true, forKey: backfillKey)
        }
    }


    private static func cadenSeed() -> Profile {
        var c = DateComponents()
        c.year = 2012; c.month = 6; c.day = 16
        // Caden Claussen — daily basketball + daily lifting, growing
        // athlete. Body fat estimated (12% ≈ "pretty low" athletic
        // teen); fine-tune in the Profile page. 0% caloric deficit
        // (no cutting on a growing kid). netCarbsMaximum (325g) is
        // used by the model as the carb-grams TARGET, not a ceiling
        // — picks ~50% carbs of the unadjusted caloric goal at his
        // body comp; fat absorbs the remainder (~88g / ~30%); protein
        // ~127g / ~20% via the 1.2 g/lb LBM ratio.
        return Profile(
            name: "Caden Claussen",
            dateOfBirth: Calendar.current.date(from: c)!,
            gender: .male, height: 70,
            bodyMassFromHealthKit: false, bodyMass: 120,
            bodyFatPercentageFromHealthKit: false, bodyFatPercentage: 12,
            activeCaloriesBurned: 700,
            proteinRatio: 1.2,
            calorieDeficit: 0,
            netCarbsMaximum: 325)
    }


    private static func loadProfiles() -> [Profile]? {
        guard let data = UserDefaults.standard.data(forKey: "profiles") else { return nil }
        return try? JSONDecoder().decode([Profile].self, from: data)
    }


    private func saveProfiles() {
        if let json = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(json, forKey: "profiles")
        }
    }


    // Revert in-flight edits — used by ProfileEdit's Cancel button.
    func cancel() {
        if let arr = Self.loadProfiles(), !arr.isEmpty {
            self.profiles = arr
            let activeId = UserDefaults.standard.string(forKey: "activeProfileId")
            self.profile = arr.first(where: { $0.id == activeId }) ?? arr[0]
        }
    }


    // Switch the active profile by id. Any in-flight edits to the
    // previous profile have already been mirrored into `profiles` via
    // profile.didSet, so swapping is just a pointer move + persisting
    // the new active id.
    func switchToProfile(_ id: String) {
        guard let next = profiles.first(where: { $0.id == id }) else { return }
        self.profile = next
        UserDefaults.standard.set(id, forKey: "activeProfileId")
    }


    // Add a fresh profile (cloned from the current as a template — the
    // user edits fields after switching). Switches active to the new
    // one so the page immediately reflects it.
    func addProfile() {
        var p = profile
        p.id = UUID().uuidString
        p.name = "Profile \(profiles.count + 1)"
        profiles.append(p)
        switchToProfile(p.id)
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


    // Force a persist now. profile.didSet has already mirrored the
    // active edit into `profiles` (which writes JSON via its didSet);
    // this also re-stamps the active id and is kept for callers that
    // rely on an explicit flush (e.g. ProfileEdit's Save).
    func serialize() {
        if let i = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[i] = profile
        }
        UserDefaults.standard.set(profile.id, forKey: "activeProfileId")
    }
}


struct Profile: Codable, Identifiable, Equatable {
    // id + name are new (multi-profile support). Both are filled in
    // on migration of older single-profile JSON via init(from:).
    var id: String
    var name: String
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


    // Memberwise init. The `proteins` subsystem was removed; Codable
    // is now auto-synthesized (encode side; the decoder below is
    // custom for backward compatibility). Old UserDefaults JSON may
    // still carry `proteins` / `meat` / `meatAmount` keys — the
    // decoder ignores unknown keys, so pre-refactor profiles continue
    // to load and the next save drops the stale keys from disk.
    init(id: String = UUID().uuidString, name: String = "Profile",
         dateOfBirth: Date, gender: Gender, height: Int,
         bodyMassFromHealthKit: Bool, bodyMass: Double,
         bodyFatPercentageFromHealthKit: Bool, bodyFatPercentage: Double,
         activeCaloriesBurned: Double, proteinRatio: Double,
         calorieDeficit: Int, netCarbsMaximum: Double) {
        self.id = id
        self.name = name
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
    }


    // Custom decoder — Swift's auto-synthesized decoder requires every
    // property to be present in the JSON, but id/name are new. Read
    // them with decodeIfPresent so pre-multi-profile JSON keeps
    // loading; ProfileMgr stamps the migration values in init().
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? c.decode(String.self, forKey: .id)) ?? UUID().uuidString
        self.name = (try? c.decode(String.self, forKey: .name)) ?? ""
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
