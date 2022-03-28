import Foundation

enum Gender: NVValueTypeProtocol {
    case male
    case female

    var displayName: String {
        String(describing: self).capitalized
    }

    func toStr(_ precision: Int) -> String {
        return self.displayName
    }

    func singular() -> Bool {
        return true
    }
}
