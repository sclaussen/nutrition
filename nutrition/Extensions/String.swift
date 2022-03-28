extension String: NVValueTypeProtocol {
    func toStr(_ precision: Int = 0) -> String {
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
