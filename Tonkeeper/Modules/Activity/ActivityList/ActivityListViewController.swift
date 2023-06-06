//
//  ActivityListActivityListViewController.swift
//  Tonkeeper

//  Tonkeeper
//  Created by Grigory Serebryanyy on 06/06/2023.
//

import UIKit

class ActivityListViewController: GenericViewController<ActivityListView> {

  // MARK: - Module

  private let presenter: ActivityListPresenterInput

  // MARK: - Init

  init(presenter: ActivityListPresenterInput) {
    self.presenter = presenter
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

// MARK: - ActivityListViewInput

extension ActivityListViewController: ActivityListViewInput {}

// MARK: - Private

private extension ActivityListViewController {
  func setup() {}
}
