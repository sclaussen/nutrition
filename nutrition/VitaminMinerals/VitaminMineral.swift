import Foundation

class VitaminMineralMgr: ObservableObject {


    @Published var vitaminMinerals: [VitaminMineral] = []
    var vitaminMineralsTmp: [VitaminMineral] = []


    init() {
    }


    func create(name: VitaminMineralType,
                age: Double,
                gender: Gender)
    {
        let vitaminMineral = VitaminMineral(name: name, age: age, gender: gender)
        vitaminMineralsTmp.append(vitaminMineral)
    }


    func getAll(age: Double, gender: Gender) -> [VitaminMineral] {
        vitaminMinerals = []
        create(name: VitaminMineralType.calcium, age: age, gender: gender)
        create(name: VitaminMineralType.copper, age: age, gender: gender)
        create(name: VitaminMineralType.folate, age: age, gender: gender)
        create(name: VitaminMineralType.folicAcid, age: age, gender: gender)
        create(name: VitaminMineralType.iron, age: age, gender: gender)
        create(name: VitaminMineralType.magnesium, age: age, gender: gender)
        create(name: VitaminMineralType.manganese, age: age, gender: gender)
        create(name: VitaminMineralType.niacin, age: age, gender: gender)
        create(name: VitaminMineralType.pantothenicAcid, age: age, gender: gender)
        create(name: VitaminMineralType.phosphorus, age: age, gender: gender)
        create(name: VitaminMineralType.potassium, age: age, gender: gender)
        create(name: VitaminMineralType.riboflavin, age: age, gender: gender)
        create(name: VitaminMineralType.selenium, age: age, gender: gender)
        create(name: VitaminMineralType.thiamin, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminA, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminB12, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminB6, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminC, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminD, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminE, age: age, gender: gender)
        create(name: VitaminMineralType.vitaminK, age: age, gender: gender)
        create(name: VitaminMineralType.zinc, age: age, gender: gender)
//        vitaminMinerals = vitaminMineralsTmp
        return vitaminMineralsTmp
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


    func min() -> Double {
        if name == VitaminMineralType.calcium {
            return calciumMin
        }
        if name == VitaminMineralType.copper {
            return copperMin
        }
        if name == VitaminMineralType.folate {
            return folateMin
        }
        if name == VitaminMineralType.folicAcid {
            return folicAcidMin
        }
        if name == VitaminMineralType.iron {
            return ironMin
        }
        if name == VitaminMineralType.magnesium {
            return magnesiumMin
        }
        if name == VitaminMineralType.manganese {
            return manganeseMin
        }
        if name == VitaminMineralType.niacin {
            return niacinMin
        }
        if name == VitaminMineralType.pantothenicAcid {
            return pantothenicAcidMin
        }
        if name == VitaminMineralType.phosphorus {
            return phosphorusMin
        }
        if name == VitaminMineralType.potassium {
            return potassiumMin
        }
        if name == VitaminMineralType.riboflavin {
            return riboflavinMin
        }
        if name == VitaminMineralType.selenium {
            return seleniumMin
        }
        if name == VitaminMineralType.thiamin {
            return thiaminMin
        }
        if name == VitaminMineralType.vitaminA {
            return vitaminAMin
        }
        if name == VitaminMineralType.vitaminB12 {
            return vitaminB12Min
        }
        if name == VitaminMineralType.vitaminB6 {
            return vitaminB6Min
        }
        if name == VitaminMineralType.vitaminC {
            return vitaminCMin
        }
        if name == VitaminMineralType.vitaminD {
            return vitaminDMin
        }
        if name == VitaminMineralType.vitaminE {
            return vitaminEMin
        }
        if name == VitaminMineralType.vitaminK {
            return vitaminKMin
        }
        if name == VitaminMineralType.zinc {
            return zincMin
        }
        return 0
    }


    func max() -> Double {
        if name == VitaminMineralType.calcium {
            return calciumMax
        }
        if name == VitaminMineralType.copper {
            return copperMax
        }
        if name == VitaminMineralType.folate {
            return folateMax
        }
        if name == VitaminMineralType.folicAcid {
            return folicAcidMax
        }
        if name == VitaminMineralType.iron {
            return ironMax
        }
        if name == VitaminMineralType.magnesium {
            return magnesiumMax
        }
        if name == VitaminMineralType.manganese {
            return manganeseMax
        }
        if name == VitaminMineralType.niacin {
            return niacinMax
        }
        if name == VitaminMineralType.pantothenicAcid {
            return pantothenicAcidMax
        }
        if name == VitaminMineralType.phosphorus {
            return phosphorusMax
        }
        if name == VitaminMineralType.potassium {
            return potassiumMax
        }
        if name == VitaminMineralType.riboflavin {
            return riboflavinMax
        }
        if name == VitaminMineralType.selenium {
            return seleniumMax
        }
        if name == VitaminMineralType.thiamin {
            return thiaminMax
        }
        if name == VitaminMineralType.vitaminA {
            return vitaminAMax
        }
        if name == VitaminMineralType.vitaminB12 {
            return vitaminB12Max
        }
        if name == VitaminMineralType.vitaminB6 {
            return vitaminB6Max
        }
        if name == VitaminMineralType.vitaminC {
            return vitaminCMax
        }
        if name == VitaminMineralType.vitaminD {
            return vitaminDMax
        }
        if name == VitaminMineralType.vitaminE {
            return vitaminEMax
        }
        if name == VitaminMineralType.vitaminK {
            return vitaminKMax
        }
        if name == VitaminMineralType.zinc {
            return zincMax
        }
        return 0
    }


    // Calcium (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Calcium-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      200      200
    // 001      260      260
    // 003      700      700
    // 008     1000     1000
    // 013     1300     1300
    // 018     1300     1300
    // 050     1000     1000
    // 070     1000     1200    M/F Difference
    // >70     1200     1200
    var calciumMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 200
            }
            if age <= 1 {
                return 260
            }
            if age <= 3 {
                return 700
            }
            if age <= 8 {
                return 1000
            }
            if age <= 13 {
                return 1300
            }
            if age <= 18 {
                return 1300
            }
            if age <= 50 {
                return 1000
            }
            if age <= 70 && gender == Gender.male {
                return 1000
            }
            if age <= 70 && gender == Gender.female {
                return 1200
            }
            return 1200
        }
    }


    // Calcium (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Calcium-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5     1000     1000
    // 001     1500     1500
    // 008     2500     2500
    // 018     3000     3000
    // 050     2500     2500
    // >51     2000     2000
    var calciumMax: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 1000
            }
            if age <= 1 {
                return 1500
            }
            if age <= 8 {
                return 2500
            }
            if age <= 18 {
                return 3000
            }
            if age <= 50 {
                return 2500
            }
            return 2000
        }
    }



    // Copper (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Copper-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5      200      200
    // 001      200      200
    // 003      340      340
    // 008      440      440
    // 013      700      700
    // 018      890      890
    // >19      900      900
    var copperMin: Double {
        set {
        }
        get {
            if age <= 1 {
                return 200
            }
            if age <= 3 {
                return 340
            }
            if age <= 8 {
                return 440
            }
            if age <= 13 {
                return 700
            }
            if age <= 18 {
                return 890
            }
            return 900
        }
    }


    // Copper (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Copper-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5      TBD      TBD
    // 001      TBD      TBD
    // 003     1000     1000
    // 008     3000     3000
    // 013     5000     5000
    // 018     8000     8000
    // >19    10000    10000
    var copperMax: Double {
        set {
        }
        get {
            if age <= 1 {
                return 0 // TBD
            }
            if age <= 3 {
                return 1000
            }
            if age <= 8 {
                return 3000
            }
            if age <= 13 {
                return 5000
            }
            if age <= 18 {
                return 8000
            }
            return 10000
        }
    }



    // Folate (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Folate-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5       65       65
    // 001       80       80
    // 003      150      150
    // 008      200      200
    // 013      300      300
    // 018      400      400
    // >19      400      400
    var folateMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 65
            }
            if age <= 1 {
                return 80
            }
            if age <= 3 {
                return 150
            }
            if age <= 8 {
                return 200
            }
            if age <= 13 {
                return 300
            }
            return 400
        }
    }


    // Folate (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Folate-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5      TBD      TBD
    // 001      TBD      TBD
    // 003      300      300
    // 008      400      400
    // 013      600      600
    // 018      800      800
    // >19     1000     1000
    var folateMax: Double {
        set {
        }
        get {
            if age <= 3 {
                return 300
            }
            if age <= 8 {
                return 400
            }
            if age <= 13 {
                return 600
            }
            if age <= 18 {
                return 800
            }
            return 1000
        }
    }



    // Folic Acid (Minimum)
    //
    //
    var folicAcidMin: Double {
        set {
        }
        get {
            return 0
        }
    }


    // Folic Acid (Maximum)
    //
    //
    var folicAcidMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Iron (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Iron-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5     0.27     0.27
    // 001       11       11
    // 003        7        7
    // 008       10       10
    // 013        8        8
    // 018       11       15    M/F Difference
    // 050        8       18    M/F Difference
    // >51        8        8
    var ironMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 0.27
            }
            if age <= 1 {
                return 11
            }
            if age <= 3 {
                return 7
            }
            if age <= 8 {
                return 10
            }
            if age <= 13 {
                return 8
            }
            if age <= 18 && gender == Gender.male {
                return 11
            }
            if age <= 18 && gender == Gender.female {
                return 15
            }
            if age <= 50 && gender == Gender.male {
                return 8
            }
            if age <= 50 && gender == Gender.female {
                return 18
            }
            return 8
        }
    }


    // Iron (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Iron-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5       40       40
    // 001       40       40
    // 003       40       40
    // 008       40       40
    // 013       40       40
    // 018       45       45
    // >19       45       45
    var ironMax: Double {
        set {
        }
        get {
            if age <= 13 {
                return 40
            }
            return 45
        }
    }



    // Magnesium (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Magnesium-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5       30       30
    // 001       75       75
    // 003       80       80
    // 008      130      130
    // 013      240      240
    // 018      410      360    M/F Difference
    // 030      400      310    M/F Difference
    // 050      420      320    M/F Difference
    // >51      420      320    M/F Difference
    var magnesiumMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 30
            }
            if age <= 1 {
                return 75
            }
            if age <= 3 {
                return 80
            }
            if age <= 8 {
                return 130
            }
            if age <= 13 {
                return 240
            }
            if age <= 18 && gender == Gender.male {
                return 410
            }
            if age <= 18 && gender == Gender.female {
                return 360
            }
            if age <= 30 && gender == Gender.male {
                return 400
            }
            if age <= 30 && gender == Gender.female {
                return 310
            }
            if age <= 50 && gender == Gender.male {
                return 420
            }
            if age <= 50 && gender == Gender.female {
                return 320
            }
            if gender == Gender.male {
                return 420
            }
            if gender == Gender.female {
                return 320
            }
            return 0 // Never reached
        }
    }


    // Magnesium (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Magnesium-HealthProfessional
    // mg
    //
    // Age        M        F
    // 001      TBD      TBD
    // 003       65       65
    // 008      110      110
    // 018      350      350
    // >19      350      350
    var magnesiumMax: Double {
        set {
        }
        get {
            if age <= 1 {
                return 0 // TBD
            }
            if age <= 3 {
                return 65
            }
            if age <= 8 {
                return 110
            }
            return 350
        }
    }



    // Manganese (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Manganese-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5    0.003    0.003
    // 001      0.6      0.6
    // 003      1.2      1.2
    // 008      1.5      1.5
    // 013      1.9      1.6    M/F Difference
    // 018      2.2      1.6    M/F Difference
    // 050      2.3      1.8    M/F Difference
    // >51      2.3      1.8    M/F Difference
    var manganeseMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 0.003
            }
            if age <= 1 {
                return 0.6
            }
            if age <= 3 {
                return 1.2
            }
            if age <= 8 {
                return 1.5
            }
            if age <= 13 && gender == Gender.male {
                return 1.9
            }
            if age <= 13 && gender == Gender.female {
                return 1.6
            }
            if age <= 18 && gender == Gender.male {
                return 2.2
            }
            if age <= 18 && gender == Gender.female {
                return 1.6
            }
            if gender == Gender.male {
                return 2.3
            }
            if gender == Gender.female {
                return 1.8
            }
            return 0 // Never reached
        }
    }


    // Manganese (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Manganese-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      TBD      TBD
    // 001      TBD      TBD
    // 003        2        2
    // 008        3        3
    // 013        6        6
    // 018        9        9
    // >19       11       11
    var manganeseMax: Double {
        set {
        }
        get {
            if age <= 1 {
                return 0 // TBD
            }
            if age <= 3 {
                return 2
            }
            if age <= 8 {
                return 3
            }
            if age <= 13 {
                return 6
            }
            if age <= 18 {
                return 9
            }
            return 11
        }
    }



    // Niacin (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Niacin-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5        2        2
    // 001        4        4
    // 003        6        6
    // 008        8        8
    // 013       12       12
    // 018       16       14    M/F Difference
    // >19       16       14    M/F Difference
    var niacinMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 2
            }
            if age <= 1 {
                return 4
            }
            if age <= 3 {
                return 6
            }
            if age <= 8 {
                return 8
            }
            if age <= 13 {
                return 12
            }
            if gender == Gender.male {
                return 16
            }
            if gender == Gender.female {
                return 14
            }
            return 0 // Never reached
        }
    }


    // Niacin (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Niacin-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      TBD      TBD
    // 001      TBD      TBD
    // 003       10       10
    // 008       15       15
    // 013       20       20
    // 018       30       30
    // >19       35       35
    var niacinMax: Double {
        set {
        }
        get {
            if age <= 1 {
                return 0 // TBD
            }
            if age <= 3 {
                return 10
            }
            if age <= 8 {
                return 15
            }
            if age <= 13 {
                return 20
            }
            if age <= 18 {
                return 30
            }
            return 35
        }
    }



    // Pantothenic Acid (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/PantothenicAcid-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      1.7      1.7
    // 001      1.8      1.8
    // 003        2        2
    // 008        3        3
    // 013        4        4
    // 018        5        5
    // >19        5        5
    var pantothenicAcidMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 1.7
            }
            if age <= 1 {
                return 1.8
            }
            if age <= 3 {
                return 2
            }
            if age <= 8 {
                return 3
            }
            if age <= 13 {
                return 4
            }
            return 5
        }
    }


    // Pantothenic Acid (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/PantothenicAcid-HealthProfessional
    // mg
    //
    // Maximum daily intake unlikely to cause adverse health effects.
    var pantothenicAcidMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Phosphorus (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Phosphorus-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      100      100
    // 001      275      275
    // 003      460      460
    // 008      500      500
    // 013     1250     1250
    // 018     1250     1250
    // >19      700      700
    var phosphorusMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 100
            }
            if age <= 1 {
                return 275
            }
            if age <= 3 {
                return 460
            }
            if age <= 8 {
                return 500
            }
            if age <= 18 {
                return 1250
            }
            return 700
        }
    }


    // Phosphorus (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Phosphorus-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      TBD      TBD
    // 001      TBD      TBD
    // 003     3000     3000
    // 008     3000     3000
    // 013     4000     4000
    // 018     4000     4000
    // 050     4000     4000
    // 070     4000     4000
    // >70     3000     3000
    var phosphorusMax: Double {
        set {
        }
        get {
            if age <= 8 {
                return 3000
            }
            if age <= 70 {
                return 4000
            }
            return 3000
        }
    }



    // Potassium (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Potassium-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      400      400
    // 001      860      860
    // 003     2000     2000
    // 008     2300     2300
    // 013     2500     2300    M/F Difference
    // 018     3000     2300    M/F Difference
    // 050     3400     2600    M/F Difference
    // >51     3400     2600    M/F Difference
    var potassiumMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 400
            }
            if age <= 1 {
                return 860
            }
            if age <= 3 {
                return 2000
            }
            if age <= 8 {
                return 2300
            }
            if age <= 13 && gender == Gender.male {
                return 2500
            }
            if age <= 13 && gender == Gender.female {
                return 2300
            }
            if age <= 18 && gender == Gender.male {
                return 3000
            }
            if age <= 18 && gender == Gender.female {
                return 2300
            }
            if gender == Gender.male {
                return 3400
            }
            if gender == Gender.female {
                return 2600
            }
            return 0 // Never reached
        }
    }


    // Potassium (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Potassium-HealthProfessional
    // mg
    //
    var potassiumMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Riboflavin (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Riboflavin-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      0.3      0.3
    // 001      0.4      0.4
    // 003      0.5      0.5
    // 008      0.6      0.6
    // 013      0.9      0.9
    // 018      1.3      1.0    M/F Difference
    // 050      1.3      1.1    M/F Difference
    // >51      1.3      1.1    M/F Difference
    var riboflavinMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 0.3
            }
            if age <= 1 {
                return 0.4
            }
            if age <= 3 {
                return 0.5
            }
            if age <= 8 {
                return 0.6
            }
            if age <= 13 {
                return 0.9
            }
            if age <= 18 && gender == Gender.male {
                return 1.3
            }
            if age <= 18 && gender == Gender.female {
                return 1.0
            }
            if age <= 18 && gender == Gender.male {
                return 1.3
            }
            if age <= 18 && gender == Gender.female {
                return 1.0
            }
            if gender == Gender.male {
                return 1.3
            }
            if gender == Gender.female {
                return 1.1
            }
            return 0 // Never reached
        }
    }


    // Riboflavin (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Riboflavin-HealthProfessional
    // mg
    //
    var riboflavinMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Selenium (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Selenium-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5       15       15
    // 001       20       20
    // 003       20       20
    // 008       30       30
    // 013       40       40
    // 018       55       55
    // 050       55       55
    // >51       55       55
    var seleniumMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 15
            }
            if age <= 3 {
                return 20
            }
            if age <= 8 {
                return 30
            }
            if age <= 13 {
                return 40
            }
            return 55
        }
    }


    // Selenium (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Selenium-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5       45       45
    // 001       60       60
    // 003       90       90
    // 008      150      150
    // 013      280      280
    // 018      400      400
    // >19      400      400
    var seleniumMax: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 45
            }
            if age <= 1 {
                return 60
            }
            if age <= 3 {
                return 90
            }
            if age <= 8 {
                return 150
            }
            if age <= 13 {
                return 280
            }
            return 400
        }
    }



    // Thiamin (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Thiamin-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      0.2      0.2
    // 001      0.3      0.3
    // 003      0.5      0.5
    // 008      0.6      0.6
    // 013      0.9      0.9
    // 018      1.2      1.0    M/F Difference
    // 050      1.2      1.1    M/F Difference
    // >51      1.2      1.1    M/F Difference
    var thiaminMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 0.2
            }
            if age <= 1 {
                return 0.3
            }
            if age <= 3 {
                return 0.5
            }
            if age <= 8 {
                return 0.6
            }
            if age <= 13 {
                return 0.9
            }
            if age <= 18 && gender == Gender.male {
                return 1.2
            }
            if age <= 18 && gender == Gender.female {
                return 1.0
            }
            if gender == Gender.male {
                return 1.2
            }
            if gender == Gender.female {
                return 1.1
            }
            return 0 // Never reached
        }
    }


    // Thiamin (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Thiamin-HealthProfessional
    // mg
    //
    var thiaminMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Vitamin A (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminA-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5      400      400
    // 001      500      500
    // 003      300      300
    // 008      400      400
    // 013      600      600
    // 018      900      700    M/F Difference
    // 050      900      700    M/F Difference
    // >51      900      700    M/F Difference
    var vitaminAMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 400
            }
            if age <= 1 {
                return 500
            }
            if age <= 3 {
                return 300
            }
            if age <= 8 {
                return 400
            }
            if age <= 13 {
                return 600
            }
            if gender == Gender.male {
                return 900
            }
            if gender == Gender.female {
                return 700
            }
            return 0 // Never reached
        }
    }


    // Vitamin A (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminA-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 001      600      600
    // 003      600      600
    // 008      900      900
    // 013     1700     1700
    // 018     2800     2800
    // >19     3000     3000
    var vitaminAMax: Double {
        set {
        }
        get {
            if age <= 1 {
                return 600
            }
            if age <= 3 {
                return 600
            }
            if age <= 8 {
                return 900
            }
            if age <= 13 {
                return 1700
            }
            if age <= 18 {
                return 2800
            }
            return 3000
        }
    }



    // Vitamin B12 (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminB12-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5      0.4      0.4
    // 001      0.5      0.5
    // 003      0.9      0.9
    // 008      1.2      1.2
    // 013      1.8      1.8
    // 018      2.4      2.4
    // >19      2.4      2.4
    var vitaminB12Min: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 0.4
            }
            if age <= 1 {
                return 0.5
            }
            if age <= 3 {
                return 0.9
            }
            if age <= 8 {
                return 1.2
            }
            if age <= 13 {
                return 1.8
            }
            return 2.4
        }
    }


    // Vitamin B12 (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminB12-HealthProfessional
    // mcg
    //
    var vitaminB12Max: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Vitamin B6 (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminB6-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      0.1      0.1
    // 001      0.3      0.3
    // 003      0.5      0.5
    // 008      0.6      0.6
    // 013      1.0      1.0
    // 018      1.3      1.2    M/F Difference
    // 050      1.3      1.3
    // >51      1.7      1.5    M/F Difference
    var vitaminB6Min: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 0.1
            }
            if age <= 1 {
                return 0.3
            }
            if age <= 3 {
                return 0.5
            }
            if age <= 8 {
                return 0.6
            }
            if age <= 13 {
                return 1.0
            }
            if age <= 18 && gender == Gender.male {
                return 1.3
            }
            if age <= 18 && gender == Gender.female {
                return 1.2
            }
            if age <= 50 {
                return 1.3
            }
            if gender == Gender.male {
                return 1.7
            }
            if gender == Gender.female {
                return 1.5
            }
            return 0 // Never reached
        }
    }


    // Vitamin B6 (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminB6-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5      TBD      TBD
    // 001      TBD      TBD
    // 003       30       30
    // 008       40       40
    // 013       60       60
    // 018       80       80
    // >19      100      100
    var vitaminB6Max: Double {
        set {
        }
        get {
            if age <= 1 {
                return 0 // TBD
            }
            if age <= 3 {
                return 30
            }
            if age <= 8 {
                return 40
            }
            if age <= 13 {
                return 60
            }
            if age <= 18 {
                return 80
            }
            return 100
        }
    }



    // Vitamin C (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminC-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5       40       40
    // 001       50       50
    // 003       15       15
    // 008       25       25
    // 013       45       45
    // 018       75       65    M/F Difference
    // >19       90       75    M/F Difference
    var vitaminCMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 40
            }
            if age <= 1 {
                return 50
            }
            if age <= 3 {
                return 15
            }
            if age <= 8 {
                return 25
            }
            if age <= 13 {
                return 45
            }
            if age <= 18 && gender == Gender.male {
                return 75
            }
            if age <= 18 && gender == Gender.female {
                return 65
            }
            if gender == Gender.male {
                return 90
            }
            if gender == Gender.female {
                return 75
            }
            return 0 // Never reached
        }
    }


    // Vitamin C (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminC-HealthProfessional
    // mg
    //
    // Age        M        F
    // 001      TBD      TBD
    // 003      400      400
    // 008      650      650
    // 013     1200     1200
    // 018     1800     1800
    // >19     2000     2000
    var vitaminCMax: Double {
        set {
        }
        get {
            if age <= 1 {
                return 0 // TBD
            }
            if age <= 3 {
                return 400
            }
            if age <= 8 {
                return 650
            }
            if age <= 13 {
                return 1200
            }
            if age <= 18 {
                return 1800
            }
            return 2000
        }
    }



    // Vitamin D (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional
    // IU
    //
    // Age        M        F
    // 001   10/400   10/400
    // 013   15/600   15/600
    // 018   15/600   15/600
    // 050   15/600   15/600
    // 070   15/600   15/600
    // >70   20/800   20/800
    var vitaminDMin: Double {
        set {
        }
        get {
                if age <= 1 {
                    return 400
                }
                if age <= 70 {
                    return 600
                }
                return 800
        }
    }


    // Vitamin D (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional
    // IU
    //
    var vitaminDMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Vitamin E (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminE-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5        4        4
    // 001        5        5
    // 003        6        6
    // 008        7        7
    // 013       11       11
    // >14       15       15
    var vitaminEMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 4
            }
            if age <= 1 {
                return 5
            }
            if age <= 3 {
                return 6
            }
            if age <= 8 {
                return 7
            }
            if age <= 13 {
                return 11
            }
            return 15
        }
    }


    // Vitamin E (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminE-HealthProfessional
    // mg
    //
    var vitaminEMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Vitamin K (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminK-HealthProfessional
    // mcg
    //
    // Age        M        F
    // 0.5      2.0      2.0
    // 001      2.5      2.5
    // 003       30       30
    // 008       55       55
    // 013       60       60
    // 018       75       75
    // >19      120       90    M/F Difference
    var vitaminKMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 2.0
            }
            if age <= 1 {
                return 2.5
            }
            if age <= 3 {
                return 30
            }
            if age <= 8 {
                return 55
            }
            if age <= 13 {
                return 60
            }
            if age <= 18 {
                return 75
            }
            if gender == Gender.male {
                return 120
            }
            if gender == Gender.female {
                return 90
            }
            return 0 // Never reached
        }
    }


    // Vitamin K (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/VitaminK-HealthProfessional
    // mcg
    //
    var vitaminKMax: Double {
        set {
        }
        get {
            return 0
        }
    }



    // Zinc (Minimum)
    //
    // https://ods.od.nih.gov/factsheets/Zinc-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5        2        2
    // 001        3        3
    // 003        3        3
    // 008        5        5
    // 013        8        8
    // 018       11        9    M/F Difference
    // >19       11        8    M/F Difference
    var zincMin: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 2
            }
            if age <= 3 {
                return 3
            }
            if age <= 8 {
                return 5
            }
            if age <= 13 {
                return 8
            }
            if age <= 18 && gender == Gender.male {
                return 11
            }
            if age <= 18 && gender == Gender.female {
                return 9
            }
            if gender == Gender.male {
                return 11
            }
            if gender == Gender.female {
                return 8
            }
            return 0 // Never reached
        }
    }


    // Zinc (Maximum)
    //
    // https://ods.od.nih.gov/factsheets/Zinc-HealthProfessional
    // mg
    //
    // Age        M        F
    // 0.5        4        4
    // 001        5        5
    // 003        7        7
    // 008       12       12
    // 013       23       23
    // 018       34       34
    // >19       40       40
    var zincMax: Double {
        set {
        }
        get {
            if age <= 0.5 {
                return 4
            }
            if age <= 1 {
                return 5
            }
            if age <= 3 {
                return 7
            }
            if age <= 8 {
                return 12
            }
            if age <= 13 {
                return 23
            }
            if age <= 18 {
                return 34
            }
            return 40
        }
    }
}
