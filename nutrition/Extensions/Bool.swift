extension Bool: Fmt, Singular {
    func toStr(_ precision: Int = 0) -> String {
        return self.description
    }

    func singular() -> Bool {
        return true
    }
}
