import CoreUtils
import Foundation

public struct Localization:
    Equatable,
    CustomStringConvertible,
    ExpressibleByStringLiteral
{

    public init(identifier: String) {
        self.identifier = identifier
    }

    public let identifier: String

    public static var system: Localization {
        Localization(identifier: Locale.current.identifier)
    }

    private static var fallback: Localization {
        "en"
    }

    public var localizedName: String {
        if let localizedString = locale.localizedString(forLanguageCode: identifier) {
            return localizedString.capitalized
        } else {
            return identifier
        }
    }

    public var direction: LocalizationDirection {
        let characterDirection = Locale.characterDirection(forLanguage: identifier)

        switch characterDirection {
        case .leftToRight:
            return .ltr

        case .rightToLeft:
            return .rtl

        default:
            return .rtl
        }
    }

    public var locale: Locale {
        Locale(identifier: identifier)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        identifier
    }

    // MARK: - ExpressibleByStringLiteral

    public init(stringLiteral value: StringLiteralType) {
        self.identifier = value
    }
}

extension Array where Element == Localization {
    public var englishFirst: Self {
        guard contains("en") else {
            return safeUndefined(
                self,
                "No en localization provided"
            )
        }

        var result = self
        result.removeAll { $0 == "en" }
        result.insert("en", at: 0)

        return result
    }
}
