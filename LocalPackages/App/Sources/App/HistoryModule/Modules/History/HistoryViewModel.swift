import UIKit
import TKUIKit
import KeeperCore
import TKCore

protocol HistoryModuleOutput: AnyObject {
  
}

protocol HistoryViewModel: AnyObject {
  var didUpdateListViewController: ((HistoryListViewController) -> Void)? { get set }
  var didUpdateEmptyViewController: ((UIViewController) -> Void)? { get set }
  var didUpdateIsEmpty: ((Bool) -> Void)? { get set }
  
  func viewDidLoad()
}

final class HistoryViewModelImplementation: HistoryViewModel, HistoryModuleOutput {
  
  // MARK: - HistoryModuleOutput
  
  // MARK: - HistoryViewModel
  
  var didUpdateListViewController: ((HistoryListViewController) -> Void)?
  var didUpdateEmptyViewController: ((UIViewController) -> Void)?
  var didUpdateIsEmpty: ((Bool) -> Void)?
  
  func viewDidLoad() {
    historyController.didUpdateWallet = { [weak self] in
      self?.setupChildren()
    }
    setupChildren()
  }
  
  // MARK: - Child
  
  private var listInput: HistoryListModuleInput?
  
  // MARK: - Dependencies
  
  private let historyController: HistoryController
  private let listModuleProvider: (Wallet) -> MVVMModule<HistoryListViewController, HistoryListModuleOutput, HistoryListModuleInput>
  private let emptyModuleProvider: (Wallet) -> MVVMModule<HistoryEmptyViewController, HistoryEmptyViewModel, Void>
  
  // MARK: - Init
  
  init(historyController: HistoryController,
       listModuleProvider: @escaping (Wallet) -> MVVMModule<HistoryListViewController, HistoryListModuleOutput, HistoryListModuleInput>,
       emptyModuleProvider: @escaping (Wallet) -> MVVMModule<HistoryEmptyViewController, HistoryEmptyViewModel, Void>) {
    self.historyController = historyController
    self.listModuleProvider = listModuleProvider
    self.emptyModuleProvider = emptyModuleProvider
  }
}

private extension HistoryViewModelImplementation {
  func setupChildren() {
    let listModule = listModuleProvider(historyController.wallet)
    listInput = listModule.input
    didUpdateListViewController?(listModule.view)
    
    listModule.output.noEvents = { [weak self] in
      self?.didUpdateIsEmpty?(true)
    }
    
    listModule.output.hasEvents = { [weak self] in
      self?.didUpdateIsEmpty?(false)
    }
    
    let emptyModule = emptyModuleProvider(historyController.wallet)
    didUpdateEmptyViewController?(emptyModule.view)
  }
}