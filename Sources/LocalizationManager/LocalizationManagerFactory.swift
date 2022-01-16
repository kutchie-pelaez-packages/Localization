public struct LocalizationManagerFactory {
    public init() { }

    public func produce(supportedLocalizationIdentifiers: [String]) -> LocalizationManager {
        LocalizationManagerImpl(supportedLocalizationIdentifiers: supportedLocalizationIdentifiers)
    }
}
