import Core
import Foundation

public struct LanguageUserDefault {
    public init(
        _ key: String,
        supportedLocalizations: [Localization]
    ) {
        self.supportedLocalizations = supportedLocalizations
        self._language = UserDefault(
            key,
            default: nil
        )
    }

    private let supportedLocalizations: [Localization]

    @UserDefault
    private var language: String?

    public var wrappedValue: Language {
        get {
            if let userDefaultsLanguageValue = language {
                let customLocalization = Localization(identifier: userDefaultsLanguageValue)

                return .custom(customLocalization)
            } else {
                let systemLocalization = Localization.system(for: supportedLocalizations)

                return .system(systemLocalization)
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

