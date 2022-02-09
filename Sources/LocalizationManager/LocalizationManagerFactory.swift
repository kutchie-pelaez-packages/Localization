import Logger

public struct LocalizationManagerFactory {
    public init() { }

    public func produce(
        provider: LocalizationManagerProvider,
        logger: Logger
    ) -> LocalizationManager {
        LocalizationManagerImpl(
            provider: provider,
            logger: logger
        )
    }
}
