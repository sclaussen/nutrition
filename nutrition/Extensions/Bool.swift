extension Bool: Fmt, Singular, PickerType {
    func toStr(_ precision: Int = 0) -> String {
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
