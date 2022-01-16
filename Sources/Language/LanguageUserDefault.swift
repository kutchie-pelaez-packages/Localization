import CoreUtils
import Foundation

@propertyWrapper
public struct LanguageUserDefault {
    public init(_ key: String) {
        self._language = UserDefault(
            key,
            default: nil
        )
    }

    @UserDefault
    private var language: String?

    public var wrappedValue: Language {
        get {
            if let userDefaultsLanguageValue = language {
                return .custom(
                    Localization(identifier: userDefaultsLanguageValue)
                )
            } else {
                return .system
            }
        } set {
            switch newValue {
            case .system:
                language = nil

            case let .custom(localization):
                language = localization.identifier
            }
        }
    }
}

