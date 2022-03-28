extension Int: NVValueTypeProtocol {
    func toStr(_ precision: Int = 0) -> String {
        return String(self)
    }

    func singular() -> Bool {
        return self == 1
    }

    var displayName: String {
        return String(self)
    }

    public static var allCases: [Int] {
        return []
    }
}
