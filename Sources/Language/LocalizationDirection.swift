public enum LocalizationDirection: String, CustomStringConvertible {
    case ltr
    case rtl

    // MARK: - CustomStringConvertible

    public var description: String {
        rawValue
    }
}
