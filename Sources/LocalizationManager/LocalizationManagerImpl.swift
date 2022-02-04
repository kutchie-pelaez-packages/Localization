import Combine
import Core
import Foundation
import Language
import Yams
import os

private let logger = Logger("localization")

final class LocalizationManagerImpl: LocalizationManager {
    init(provider: LocalizationManagerProvider) {
        self.provider = provider
        subscribeToEvents()
    }

    private let provider: LocalizationManagerProvider

    private let configDecoder = YAMLDecoder()
    private var cancellable = [AnyCancellable]()

    private lazy var storedLanguage = LanguageUserDefault(
        "language",
        supportedLocalizations: supportedLocalizations
    )

    // MARK: -

    private lazy var config: LocalizationManagerConfig = {
        guard
            let configData = try? Data(contentsOf: provider.configURL),
            let config: LocalizationManagerConfig = try? configDecoder.decode(from: configData)
        else {
            appFatalError("Failed to access localization manager config")
        }

        return config
    }()

    private func subscribeToEvents() {
        languageSubject
            .sink { [weak self] newLanguage in
                guard
                    let oldLanguage = self?.storedLanguage.wrappedValue,
                    let self = self,
                    newLanguage != oldLanguage
                else {
                    return
                }

                logger.log("Setting language from \(oldLanguage) to \(newLanguage)")

                self.storedLanguage.wrappedValue = newLanguage
            }
            .store(in: &cancellable)
    }

    // MARK: - LocalizationManager

    private(set) lazy var languageSubject: MutableValueSubject<Language> = UniqueMutableValueSubject(storedLanguage.wrappedValue)

    private(set) lazy var supportedLocalizations: [Localization] = config.supportedLocalizations.map(Localization.init(identifier:))
}
