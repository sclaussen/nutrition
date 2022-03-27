extension Int: Fmt, Singular {
    func toStr(_ precision: Int = 0) -> String {
        return String(self)
    }

    func singular() -> Bool {
        return self == 1
    }
}
