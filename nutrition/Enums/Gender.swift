import Foundation

enum Gender: MyEnum {
    case male
    case female

    var displayName: String {
        String(describing: self).capitalized
    }
}
