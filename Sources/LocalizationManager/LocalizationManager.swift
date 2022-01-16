import CoreUtils
import Language

public protocol LocalizationManager {
    var language: Language { get nonmutating set }
    var supportedLocalizations: [Localization] { get }
    var eventPublisher: ValuePublisher<LocalizationEvent> { get }
    func register(localizationDirectionReceiver: LocalizationDirectionReceiver)
}
