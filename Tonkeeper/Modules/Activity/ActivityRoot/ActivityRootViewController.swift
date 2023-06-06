//
//  ActivityRootActivityRootViewController.swift
//  Tonkeeper

//  Tonkeeper
//  Created by Grigory Serebryanyy on 06/06/2023.
//

import UIKit

class ActivityRootViewController: GenericViewController<ActivityRootView> {

  // MARK: - Module

  private let presenter: ActivityRootPresenterInput
  
  // MARK: - Children
  
  private let emptyViewController: ActivityEmptyViewController
  private let listViewController: ActivityListViewController

  // MARK: - Init

  init(presenter: ActivityRootPresenterInput,
       emptyViewController: ActivityEmptyViewController,
       listViewController: ActivityListViewController) {
    self.presenter = presenter
    self.emptyViewController = emptyViewController
    self.listViewController = listViewController
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    presenter.viewDidLoad()
  }
}

// MARK: - ActivityRootViewInput

extension ActivityRootViewController: ActivityRootViewInput {
  func showEmptyState() {
    customView.showEmptyState()
  }
}

// MARK: - Private

private extension ActivityRootViewController {
  func setup() {
    setupEmptyViewController()
    setupListViewController()
  }
  
  func setupEmptyViewController() {
    addChild(emptyViewController)
    customView.addEmptyContentView(view: emptyViewController.view)
    emptyViewController.didMove(toParent: self)
  }
  
  func setupListViewController() {
    addChild(listViewController)
    customView.addListContentView(view: listViewController.view)
    listViewController.didMove(toParent: self)
  }
}
