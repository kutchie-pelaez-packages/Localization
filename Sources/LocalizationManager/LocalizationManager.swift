import Core
import Language
import Tweak

public protocol LocalizationManager: TweakReceiver {
    var languageSubject: MutableValueSubject<Language> { get }
    var supportedLocalizations: [Localization] { get }
}

extension LocalizationManager {
    public var localizationDirectionPublisher: ValuePublisher<LocalizationDirection> {
        languageSubject
            .map(\.direction)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
