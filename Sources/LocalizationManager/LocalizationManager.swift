import Core
import Language

public protocol LocalizationManager {
    var languageSubject: MutableValueSubject<Language> { get }
    var supportedLocalizations: [Localization] { get }
}

extension LocalizationManager {
    var localizationDirectionPublisher: ValuePublisher<LocalizationDirection> {
        languageSubject
            .map(\.direction)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
