import Combine
import Core
import Foundation
import Language
import Logger
import Tweak
import Yams

final class LocalizationManagerImpl: LocalizationManager {
    init(
        provider: LocalizationManagerProvider,
        logger: Logger
    ) {
        self.provider = provider
        self.logger = logger
        subscribeToEvents()
    }

    private let provider: LocalizationManagerProvider
    private let logger: Logger

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
            crash("Failed to access localization manager config")
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

                self.logger.log("Changing language from \(oldLanguage) to \(newLanguage)...", domain: .localization)

                self.storedLanguage.wrappedValue = newLanguage
            }
            .store(in: &cancellable)
    }

    // MARK: - TweakReceiver

    func receive(_ tweak: Tweak) {
        guard
            tweak.id == .Localization.updateLanguage,
            let newValue = tweak.args[.newValue] as? Language
        else {
            return
        }

        languageSubject.value = newValue
    }

    // MARK: - LocalizationManager

    private(set) lazy var languageSubject: MutableValueSubject<Language> = UniqueMutableValueSubject(storedLanguage.wrappedValue)

    private(set) lazy var supportedLocalizations: [Localization] = config.supportedLocalizations.map(Localization.init(identifier:))
}

extension LogDomain {
    fileprivate static let localization: Self = "localization"
}
