extension Int: NVValueTypeProtocol {
    func string(_ max: Int = -1) -> String {
        return self.description
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
