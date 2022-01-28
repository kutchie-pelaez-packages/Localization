import Core
import Foundation

public struct Localization:
    Equatable,
    Hashable,
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

    public static var en: Localization {
        "en"
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
    public func localizationFirst(_ localization: Localization) -> Self {
        guard contains(localization) else {
            return safeUndefined(
                self,
                "No \(localization.identifier) localization provided"
            )
        }

        var result = self
        result.removeAll { $0 == localization }
        result.insert(localization, at: 0)

        return result
    }

    public var englishFirst: Self {
        localizationFirst(.en)
    }
}
