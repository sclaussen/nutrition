import Foundation


enum Gender: ValueType {
    case male
    case female


    func formattedString(_ precision: Int) -> String {
        return String(describing: self).capitalized
    }


    func singular() -> Bool {
        return true
    }
}
