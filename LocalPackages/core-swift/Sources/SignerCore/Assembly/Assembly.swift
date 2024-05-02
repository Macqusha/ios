import Foundation

public final class Assembly {
  private let coreAssembly: CoreAssembly
  public lazy var repositoriesAssembly = RepositoriesAssembly(coreAssembly: coreAssembly)
  private lazy var servicesAssembly = ServicesAssembly(
    repositoriesAssembly: repositoriesAssembly,
    coreAssembly: coreAssembly
  )
  private lazy var storesAssembly = StoresAssembly(
    servicesAssembly: servicesAssembly,
    coreAssembly: coreAssembly,
    repositoriesAssembly: repositoriesAssembly
  )
  public lazy var passwordAssembly = PasswordAssembly(
    repositoriesAssembly: repositoriesAssembly,
    storesAssembly: storesAssembly
  )
  
  public init() {
    self.coreAssembly = CoreAssembly()
  }
  
  public func rootController() -> RootController {
    RootController(walletKeysStore: storesAssembly.walletKeysStore)
  }
  
  public func keysAddController() -> KeysAddController {
    KeysAddController(
      walletKeysStore: storesAssembly.walletKeysStore,
      mnemonicRepositoty: repositoriesAssembly.mnemonicRepository()
    )
  }
  
  public func keysEditController() -> KeysEditController {
    KeysEditController(
      walletKeysStore: storesAssembly.walletKeysStore,
      mnemonicRepositoty: repositoriesAssembly.mnemonicRepository()
    )
  }
  
  public func walletKeysListController() -> WalletKeysListController {
    WalletKeysListController(walletKeysStore: storesAssembly.walletKeysStore)
  }
  
  public func walletKeyDetailsController(walletKey: WalletKey) -> WalletKeyDetailsController {
    WalletKeyDetailsController(walletKey: walletKey, walletKeysStore: storesAssembly.walletKeysStore)
  }
  
  public func recoveryPhraseController(walletKey: WalletKey) -> RecoveryPhraseController {
    RecoveryPhraseController(key: walletKey, mnemonicRepository: repositoriesAssembly.mnemonicRepository())
  }
}
