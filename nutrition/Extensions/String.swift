extension String: NVValueTypeProtocol {
    func string(_ max: Int = -1) -> String {
        return self
    }

    func singular() -> Bool {
        return true
    }

    var displayName: String {
        return self
    }

    public static var allCases: [String] {
        return []
    }
}
