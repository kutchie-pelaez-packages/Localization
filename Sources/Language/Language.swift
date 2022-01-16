import Foundation

public enum Language:
    CustomStringConvertible,
    Equatable
{

    case system
    case custom(Localization)

    public var localization: Localization {
        switch self {
        case .system:
            return .system

        case let .custom(localization):
            return localization
        }
    }

    public var direction: LocalizationDirection {
        localization.direction
    }

    public var locale: Locale {
        localization.locale
    }

    public var isSystem: Bool {
        if case .system = self {
            return true
        }

        return false
    }

    public func isCustom(_ localization: Localization) -> Bool {
        if case let .custom(customLocalization) = self {
            return localization == customLocalization
        }

        return false
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        let prefix: String
        switch self {
        case .system:
            prefix = "system"

        case .custom:
            prefix = "custom"
        }

        return [
            prefix,
            localization.description
        ].joined(separator: ".")
    }
}
