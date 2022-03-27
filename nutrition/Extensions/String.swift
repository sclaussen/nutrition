extension String: Fmt, Singular {
    func toStr(_ precision: Int = 0) -> String {
        return self
    }

    func singular() -> Bool {
        return true
    }
}
