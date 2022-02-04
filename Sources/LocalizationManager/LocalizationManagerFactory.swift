public struct LocalizationManagerFactory {
    public init() { }

    public func produce(provider: LocalizationManagerProvider) -> LocalizationManager {
        LocalizationManagerImpl(provider: provider)
    }
}
