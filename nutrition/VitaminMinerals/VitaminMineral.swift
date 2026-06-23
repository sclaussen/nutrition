import Foundation

class VitaminMineralMgr: ObservableObject {


    init() {
    }


    // Returns the list of vitamin/mineral entries for the given
    // age/gender.  Pure function — no @Published mutation, so it's
    // safe to call from a view body without triggering the
    // "Publishing changes from within view updates" SwiftUI loop.
    //
    // Each entry's `id` is derived from the nutrient type so that
    // re-renders return objects with stable identity — this is what
    // keeps NavigationLink in the list from auto-popping when its
    // destination view (e.g., the Contributors drill-down) mutates
    // any shared @Published state.
    func getAll(age: Double, gender: Gender) -> [VitaminMineral] {
        return vitaminMineralOrder.map { type in
            VitaminMineral(id: String(describing: type), name: type, age: age, gender: gender)
        }
    }
}


// A single age-bracket row of an RDA (min) or UL (max) table.
//
// The previous implementation hand-wrote, per nutrient, an
// if-ladder of the form
//
//     if age <= 0.5 { return 200 }
//     if age <= 1   { return 260 }
//     ...
//     if age <= 70 && gender == .male   { return 1000 }
//     if age <= 70 && gender == .female { return 1200 }
//     return 1200
//
// Every one of those ladders is captured here as an ordered list
// of `RDAThreshold` rows.  Lookup walks the rows in order and
// returns the first whose `age <= maxAge`, picking the `male` or
// `female` column for the caller's gender — exactly reproducing
// the original `<=` comparison and gender branching.  The final
// row of every list uses `maxAge: .infinity` so it acts as the
// original ladders' trailing `return`.
//
// Age-only ladders (no M/F difference) store the same value in
// both columns.  Nutrients whose original getter returned a flat
// 0 (no published threshold) use a single infinity row of 0.
struct RDAThreshold {
    let maxAge: Double
    let male: Double
    let female: Double

    init(_ maxAge: Double, _ value: Double) {
        self.maxAge = maxAge
        self.male = value
        self.female = value
    }

    init(_ maxAge: Double, male: Double, female: Double) {
        self.maxAge = maxAge
        self.male = male
        self.female = female
    }
}


struct VitaminMineral: Codable, Identifiable {
    var id: String
    var name: VitaminMineralType
    var age: Double
    var gender: Gender
    // var unit: Unit


    init(id: String = UUID().uuidString, name: VitaminMineralType, age: Double, gender: Gender) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
    }


    // Walk an RDA/UL table and return the threshold for this
    // entry's age/gender.  First row whose `age <= maxAge` wins,
    // mirroring the original per-nutrient if-ladders precisely.
    private func lookup(_ table: [RDAThreshold]) -> Double {
        for row in table where age <= row.maxAge {
            return gender == Gender.male ? row.male : row.female
        }
        return 0
    }


    func min() -> Double {
        guard let table = VitaminMineral.minTable[name] else { return 0 }
        return lookup(table)
    }


    // The unit that min(), max(), and the per-nutrient totals
    // returned by computeVitaminMineralActuals are expressed in.
    // NIH publishes copper, folate/folic acid, selenium, vitamin A,
    // B12, and K in micrograms; vitamin D in International Units;
    // everything else in milligrams.  computeVitaminMineralActuals
    // converts ingredient field values into this unit so the row
    // comparison (min ≤ actual ≤ max) is unit-consistent.
    func unit() -> Unit {
        switch name {
        case .copper, .folate, .folicAcid, .selenium,
             .vitaminA, .vitaminB12, .vitaminK:
            return .microgram
        case .vitaminD:
            return .internationalUnit
        default:
            return .milligram
        }
    }


    func max() -> Double {
        guard let table = VitaminMineral.maxTable[name] else { return 0 }
        return lookup(table)
    }


    // MARK: - RDA (minimum) tables
    //
    // Source RDA tables, per nutrient, from
    // https://ods.od.nih.gov/factsheets/<Nutrient>-HealthProfessional
    // Units: copper/folate/selenium/vitaminA/vitaminB12/vitaminK in
    // mcg, vitaminD in IU, everything else in mg.  Each row is
    // (maxAge, male, female); the final row's maxAge is .infinity.
    private static let minTable: [VitaminMineralType: [RDAThreshold]] = [

        // Calcium (mg) — M/F differ only at the 70 bracket.
        .calcium: [
            RDAThreshold(0.5, 200),
            RDAThreshold(1, 260),
            RDAThreshold(3, 700),
            RDAThreshold(8, 1000),
            RDAThreshold(13, 1300),
            RDAThreshold(18, 1300),
            RDAThreshold(50, 1000),
            RDAThreshold(70, male: 1000, female: 1200),
            RDAThreshold(.infinity, 1200),
        ],

        // Copper (mcg) — original ladder starts at age <= 1
        // (0.5 and 1 share 200), no M/F difference.
        .copper: [
            RDAThreshold(1, 200),
            RDAThreshold(3, 340),
            RDAThreshold(8, 440),
            RDAThreshold(13, 700),
            RDAThreshold(18, 890),
            RDAThreshold(.infinity, 900),
        ],

        // Folate (mcg) — ages 13 and >13 collapse to 400 in the
        // original (single trailing return).
        .folate: [
            RDAThreshold(0.5, 65),
            RDAThreshold(1, 80),
            RDAThreshold(3, 150),
            RDAThreshold(8, 200),
            RDAThreshold(13, 300),
            RDAThreshold(.infinity, 400),
        ],

        // Folic Acid — original getter returned 0 flat.
        .folicAcid: [
            RDAThreshold(.infinity, 0),
        ],

        // Iron (mg) — M/F differ at the 18 and 50 brackets.
        .iron: [
            RDAThreshold(0.5, 0.27),
            RDAThreshold(1, 11),
            RDAThreshold(3, 7),
            RDAThreshold(8, 10),
            RDAThreshold(13, 8),
            RDAThreshold(18, male: 11, female: 15),
            RDAThreshold(50, male: 8, female: 18),
            RDAThreshold(.infinity, 8),
        ],

        // Magnesium (mg) — M/F differ from 18 up; original used a
        // trailing gender split (no age guard) for >50, captured
        // here as the infinity row.
        .magnesium: [
            RDAThreshold(0.5, 30),
            RDAThreshold(1, 75),
            RDAThreshold(3, 80),
            RDAThreshold(8, 130),
            RDAThreshold(13, 240),
            RDAThreshold(18, male: 410, female: 360),
            RDAThreshold(30, male: 400, female: 310),
            RDAThreshold(50, male: 420, female: 320),
            RDAThreshold(.infinity, male: 420, female: 320),
        ],

        // Manganese (mg) — M/F differ from 13 up; >18 is a trailing
        // gender split in the original.
        .manganese: [
            RDAThreshold(0.5, 0.003),
            RDAThreshold(1, 0.6),
            RDAThreshold(3, 1.2),
            RDAThreshold(8, 1.5),
            RDAThreshold(13, male: 1.9, female: 1.6),
            RDAThreshold(18, male: 2.2, female: 1.6),
            RDAThreshold(.infinity, male: 2.3, female: 1.8),
        ],

        // Niacin (mg) — M/F differ from 18 up; >13 is a trailing
        // gender split in the original (16 / 14).
        .niacin: [
            RDAThreshold(0.5, 2),
            RDAThreshold(1, 4),
            RDAThreshold(3, 6),
            RDAThreshold(8, 8),
            RDAThreshold(13, 12),
            RDAThreshold(.infinity, male: 16, female: 14),
        ],

        // Pantothenic Acid (mg) — no M/F difference.
        .pantothenicAcid: [
            RDAThreshold(0.5, 1.7),
            RDAThreshold(1, 1.8),
            RDAThreshold(3, 2),
            RDAThreshold(8, 3),
            RDAThreshold(13, 4),
            RDAThreshold(.infinity, 5),
        ],

        // Phosphorus (mg) — original collapsed 13 and 18 (both 1250)
        // into a single age <= 18 bracket.
        .phosphorus: [
            RDAThreshold(0.5, 100),
            RDAThreshold(1, 275),
            RDAThreshold(3, 460),
            RDAThreshold(8, 500),
            RDAThreshold(18, 1250),
            RDAThreshold(.infinity, 700),
        ],

        // Potassium (mg) — M/F differ from 13 up; >18 is a trailing
        // gender split (3400 / 2600).
        .potassium: [
            RDAThreshold(0.5, 400),
            RDAThreshold(1, 860),
            RDAThreshold(3, 2000),
            RDAThreshold(8, 2300),
            RDAThreshold(13, male: 2500, female: 2300),
            RDAThreshold(18, male: 3000, female: 2300),
            RDAThreshold(.infinity, male: 3400, female: 2600),
        ],

        // Riboflavin (mg) — M/F differ from 18 up.  The original had
        // a duplicate (dead) age <= 18 block; only the first applies,
        // and >18 is a trailing gender split (1.3 / 1.1).
        .riboflavin: [
            RDAThreshold(0.5, 0.3),
            RDAThreshold(1, 0.4),
            RDAThreshold(3, 0.5),
            RDAThreshold(8, 0.6),
            RDAThreshold(13, 0.9),
            RDAThreshold(18, male: 1.3, female: 1.0),
            RDAThreshold(.infinity, male: 1.3, female: 1.1),
        ],

        // Selenium (mcg) — original ladder skips the age <= 1 row
        // (0.5 → 15, then 3 → 20), no M/F difference.
        .selenium: [
            RDAThreshold(0.5, 15),
            RDAThreshold(3, 20),
            RDAThreshold(8, 30),
            RDAThreshold(13, 40),
            RDAThreshold(.infinity, 55),
        ],

        // Thiamin (mg) — M/F differ from 18 up; >18 is a trailing
        // gender split (1.2 / 1.1).
        .thiamin: [
            RDAThreshold(0.5, 0.2),
            RDAThreshold(1, 0.3),
            RDAThreshold(3, 0.5),
            RDAThreshold(8, 0.6),
            RDAThreshold(13, 0.9),
            RDAThreshold(18, male: 1.2, female: 1.0),
            RDAThreshold(.infinity, male: 1.2, female: 1.1),
        ],

        // Vitamin A (mcg) — M/F differ from 13 up; >13 is a trailing
        // gender split (900 / 700).
        .vitaminA: [
            RDAThreshold(0.5, 400),
            RDAThreshold(1, 500),
            RDAThreshold(3, 300),
            RDAThreshold(8, 400),
            RDAThreshold(13, 600),
            RDAThreshold(.infinity, male: 900, female: 700),
        ],

        // Vitamin B12 (mcg) — no M/F difference.
        .vitaminB12: [
            RDAThreshold(0.5, 0.4),
            RDAThreshold(1, 0.5),
            RDAThreshold(3, 0.9),
            RDAThreshold(8, 1.2),
            RDAThreshold(13, 1.8),
            RDAThreshold(.infinity, 2.4),
        ],

        // Vitamin B6 (mg) — irregular: M/F differ at 18, then an
        // age-only 1.3 bracket at 50 (no gender split), then a
        // trailing gender split (1.7 / 1.5) for >50.
        .vitaminB6: [
            RDAThreshold(0.5, 0.1),
            RDAThreshold(1, 0.3),
            RDAThreshold(3, 0.5),
            RDAThreshold(8, 0.6),
            RDAThreshold(13, 1.0),
            RDAThreshold(18, male: 1.3, female: 1.2),
            RDAThreshold(50, 1.3),
            RDAThreshold(.infinity, male: 1.7, female: 1.5),
        ],

        // Vitamin C (mg) — M/F differ from 18 up; >18 is a trailing
        // gender split (90 / 75).
        .vitaminC: [
            RDAThreshold(0.5, 40),
            RDAThreshold(1, 50),
            RDAThreshold(3, 15),
            RDAThreshold(8, 25),
            RDAThreshold(13, 45),
            RDAThreshold(18, male: 75, female: 65),
            RDAThreshold(.infinity, male: 90, female: 75),
        ],

        // Vitamin D (IU) — age-only, cutoffs at 1 and 70.
        .vitaminD: [
            RDAThreshold(1, 400),
            RDAThreshold(70, 600),
            RDAThreshold(.infinity, 800),
        ],

        // Vitamin E (mg) — ages 13 and >13 collapse to 15 in the
        // original (single trailing return), no M/F difference.
        .vitaminE: [
            RDAThreshold(0.5, 4),
            RDAThreshold(1, 5),
            RDAThreshold(3, 6),
            RDAThreshold(8, 7),
            RDAThreshold(13, 11),
            RDAThreshold(.infinity, 15),
        ],

        // Vitamin K (mcg) — M/F differ only at the >18 trailing
        // gender split (120 / 90).
        .vitaminK: [
            RDAThreshold(0.5, 2.0),
            RDAThreshold(1, 2.5),
            RDAThreshold(3, 30),
            RDAThreshold(8, 55),
            RDAThreshold(13, 60),
            RDAThreshold(18, 75),
            RDAThreshold(.infinity, male: 120, female: 90),
        ],

        // Zinc (mg) — original ladder skips the age <= 1 row
        // (0.5 → 2, then 3 → 3); M/F differ from 18 up; >18 is a
        // trailing gender split (11 / 8).
        .zinc: [
            RDAThreshold(0.5, 2),
            RDAThreshold(3, 3),
            RDAThreshold(8, 5),
            RDAThreshold(13, 8),
            RDAThreshold(18, male: 11, female: 9),
            RDAThreshold(.infinity, male: 11, female: 8),
        ],
    ]


    // MARK: - UL (maximum) tables
    //
    // Tolerable Upper Intake Levels, same source/units as above.
    // Nutrients with no published UL returned 0 flat in the original
    // and are represented by a single infinity row of 0.  Brackets
    // the original marked "TBD" returned 0 and are preserved as 0
    // rows so the age cutoffs stay identical.
    private static let maxTable: [VitaminMineralType: [RDAThreshold]] = [

        // Calcium (mg).
        .calcium: [
            RDAThreshold(0.5, 1000),
            RDAThreshold(1, 1500),
            RDAThreshold(8, 2500),
            RDAThreshold(18, 3000),
            RDAThreshold(50, 2500),
            RDAThreshold(.infinity, 2000),
        ],

        // Copper (mcg) — age <= 1 is TBD (0) in the original.
        .copper: [
            RDAThreshold(1, 0),
            RDAThreshold(3, 1000),
            RDAThreshold(8, 3000),
            RDAThreshold(13, 5000),
            RDAThreshold(18, 8000),
            RDAThreshold(.infinity, 10000),
        ],

        // Folate (mcg) — original starts at age <= 3 (younger ages
        // fall through to the trailing return, which is 1000).
        .folate: [
            RDAThreshold(3, 300),
            RDAThreshold(8, 400),
            RDAThreshold(13, 600),
            RDAThreshold(18, 800),
            RDAThreshold(.infinity, 1000),
        ],

        // Folic Acid — original getter returned 0 flat.
        .folicAcid: [
            RDAThreshold(.infinity, 0),
        ],

        // Iron (mg).
        .iron: [
            RDAThreshold(13, 40),
            RDAThreshold(.infinity, 45),
        ],

        // Magnesium (mg) — age <= 1 is TBD (0) in the original.
        .magnesium: [
            RDAThreshold(1, 0),
            RDAThreshold(3, 65),
            RDAThreshold(8, 110),
            RDAThreshold(.infinity, 350),
        ],

        // Manganese (mg) — age <= 1 is TBD (0) in the original.
        .manganese: [
            RDAThreshold(1, 0),
            RDAThreshold(3, 2),
            RDAThreshold(8, 3),
            RDAThreshold(13, 6),
            RDAThreshold(18, 9),
            RDAThreshold(.infinity, 11),
        ],

        // Niacin (mg) — age <= 1 is TBD (0) in the original.
        .niacin: [
            RDAThreshold(1, 0),
            RDAThreshold(3, 10),
            RDAThreshold(8, 15),
            RDAThreshold(13, 20),
            RDAThreshold(18, 30),
            RDAThreshold(.infinity, 35),
        ],

        // Pantothenic Acid — original getter returned 0 flat.
        .pantothenicAcid: [
            RDAThreshold(.infinity, 0),
        ],

        // Phosphorus (mg) — original collapsed the 3..70 brackets
        // (all 4000 above age 8) into age <= 70.
        .phosphorus: [
            RDAThreshold(8, 3000),
            RDAThreshold(70, 4000),
            RDAThreshold(.infinity, 3000),
        ],

        // Potassium — original getter returned 0 flat.
        .potassium: [
            RDAThreshold(.infinity, 0),
        ],

        // Riboflavin — original getter returned 0 flat.
        .riboflavin: [
            RDAThreshold(.infinity, 0),
        ],

        // Selenium (mcg).
        .selenium: [
            RDAThreshold(0.5, 45),
            RDAThreshold(1, 60),
            RDAThreshold(3, 90),
            RDAThreshold(8, 150),
            RDAThreshold(13, 280),
            RDAThreshold(.infinity, 400),
        ],

        // Thiamin — original getter returned 0 flat.
        .thiamin: [
            RDAThreshold(.infinity, 0),
        ],

        // Vitamin A (mcg) — original starts at age <= 1.
        .vitaminA: [
            RDAThreshold(1, 600),
            RDAThreshold(3, 600),
            RDAThreshold(8, 900),
            RDAThreshold(13, 1700),
            RDAThreshold(18, 2800),
            RDAThreshold(.infinity, 3000),
        ],

        // Vitamin B12 — original getter returned 0 flat.
        .vitaminB12: [
            RDAThreshold(.infinity, 0),
        ],

        // Vitamin B6 (mg) — age <= 1 is TBD (0) in the original.
        .vitaminB6: [
            RDAThreshold(1, 0),
            RDAThreshold(3, 30),
            RDAThreshold(8, 40),
            RDAThreshold(13, 60),
            RDAThreshold(18, 80),
            RDAThreshold(.infinity, 100),
        ],

        // Vitamin C (mg) — age <= 1 is TBD (0) in the original.
        .vitaminC: [
            RDAThreshold(1, 0),
            RDAThreshold(3, 400),
            RDAThreshold(8, 650),
            RDAThreshold(13, 1200),
            RDAThreshold(18, 1800),
            RDAThreshold(.infinity, 2000),
        ],

        // Vitamin D — original getter returned 0 flat.
        .vitaminD: [
            RDAThreshold(.infinity, 0),
        ],

        // Vitamin E — original getter returned 0 flat.
        .vitaminE: [
            RDAThreshold(.infinity, 0),
        ],

        // Vitamin K — original getter returned 0 flat.
        .vitaminK: [
            RDAThreshold(.infinity, 0),
        ],

        // Zinc (mg).
        .zinc: [
            RDAThreshold(0.5, 4),
            RDAThreshold(1, 5),
            RDAThreshold(3, 7),
            RDAThreshold(8, 12),
            RDAThreshold(13, 23),
            RDAThreshold(18, 34),
            RDAThreshold(.infinity, 40),
        ],
    ]
}
