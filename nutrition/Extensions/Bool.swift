extension Bool: NVValueTypeProtocol {
    func string(_ max: Int = -1) -> String {
        return self.description
    }

    func singular() -> Bool {
        return true
    }

    var displayName: String {
        return String(self)
    }

    public static var allCases: [Bool] {
        return []
    }
}
