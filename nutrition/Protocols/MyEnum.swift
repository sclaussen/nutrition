import Foundation

protocol MyEnum: Codable, Hashable, CaseIterable where AllCases: RandomAccessCollection {
    var displayName: String { get }
}
