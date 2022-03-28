import Foundation

protocol PickerType: Codable, Hashable, CaseIterable where AllCases: RandomAccessCollection {
    var displayName: String { get }
}
