import Combine
import CoreUtils
import Language
import os

final class LocalizationManagerImpl: LocalizationManager {
    init(supportedLocalizationIdentifiers: [String]) {
        self.supportedLocalizations = supportedLocalizationIdentifiers.map(Localization.init(identifier:))
    }

    private let eventPassthroughSubject = PassthroughSubject<LocalizationEvent, Never>()
    private var localizationDirectionReceivers = WeakArray<LocalizationDirectionReceiver>()

    @LanguageUserDefault("language")
    private var storedLanguage
    private lazy var cachedLanguage = storedLanguage

    // MARK: -

    private func sendCurrentLocalizationDirectionToReceivers() {
        localizationDirectionReceivers.forEach {
            $0.receive(language.localization.direction)
        }
    }

    // MARK: - LocalizationManager

    var language: Language {
        get {
            cachedLanguage
        } set {
            guard language != newValue else { return }

            storedLanguage = newValue
            cachedLanguage = newValue

            eventPassthroughSubject.send(
                .languageDidChange(newValue)
            )

            if language.direction != newValue.direction {
                sendCurrentLocalizationDirectionToReceivers()
            }
        }
    }

    let supportedLocalizations: [Localization]

    var eventPublisher: ValuePublisher<LocalizationEvent> {
        eventPassthroughSubject
            .eraseToAnyPublisher()
    }

    func register(localizationDirectionReceiver: LocalizationDirectionReceiver) {
        localizationDirectionReceiver.receive(language.direction)
        localizationDirectionReceivers.append(localizationDirectionReceiver)
    }
}
