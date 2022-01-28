import Combine
import Core
import Language
import os

private let logger = Logger("localization")

final class LocalizationManagerImpl: LocalizationManager {
    init(supportedLocalizationIdentifiers: [String]) {
        self.supportedLocalizations = supportedLocalizationIdentifiers.map(
            Localization.init(identifier:)
        )
        subscribeToEvents()
    }

    @LanguageUserDefault("language")
    private var storedLanguage
    private var cancellable = [AnyCancellable]()

    // MARK: -

    private func subscribeToEvents() {
        languageSubject
            .sink { [weak self] newLanguage in
                guard
                    let self = self,
                    newLanguage != self.languageSubject.value
                else {
                    return
                }

                logger.log("Setting language from \(self.languageSubject.value) to \(newLanguage)")

                self.storedLanguage = newLanguage
            }
            .store(in: &cancellable)
    }

    // MARK: - LocalizationManager

    lazy var languageSubject: MutableValueSubject<Language> = UniqueMutableValueSubject(storedLanguage)

    let supportedLocalizations: [Localization]
}
