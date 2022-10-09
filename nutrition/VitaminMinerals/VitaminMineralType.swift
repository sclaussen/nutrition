import Foundation


enum VitaminMineralType: ValueType {
    case calcium
    case copper
    case folate
    case folicAcid
    case iron
    case magnesium
    case manganese
    case niacin
    case pantothenicAcid
    case phosphorus
    case potassium
    case riboflavin
    case selenium
    case thiamin
    case vitaminA
    case vitaminB12
    case vitaminB6
    case vitaminC
    case vitaminD
    case vitaminE
    case vitaminK
    case zinc


    func formattedString(_ precision: Int) -> String {
        return String(describing: self).capitalized
    }


    func singular() -> Bool {
        return true
    }
}
