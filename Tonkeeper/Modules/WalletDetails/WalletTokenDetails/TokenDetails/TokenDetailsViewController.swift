//
//  TokenDetailsTokenDetailsViewController.swift
//  Tonkeeper

//  Tonkeeper
//  Created by Grigory Serebryanyy on 13/07/2023.
//

import UIKit

class TokenDetailsViewController: GenericViewController<TokenDetailsView> {

  // MARK: - Module

  private let presenter: TokenDetailsPresenterInput
  
  // MARK: - Children
  
  private let listContentViewController: TokenDetailsListContentViewController
  
  // MARK: - Header
  
  private let headerViewController = TokenDetailsHeaderViewController()
  
  // MARK: - About view
  
  private let aboutView = TonDetailsAboutView()
  
  // MARK: - Dependencies
  
  private let imageLoader: ImageLoader

  // MARK: - Init

  init(presenter: TokenDetailsPresenterInput,
       listContentViewController: TokenDetailsListContentViewController,
       imageLoader: ImageLoader) {
    self.presenter = presenter
    self.listContentViewController = listContentViewController
    self.imageLoader = imageLoader
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
}

// MARK: - TokenDetailsViewInput

extension TokenDetailsViewController: TokenDetailsViewInput {
  func updateTitle(title: String) {
    self.title = title
  }
  
  func updateHeader(model: TokenDetailsHeaderView.Model) {
    headerViewController.update(model: model)
  }
  
  func showChart(_ chartViewController: UIViewController) {
    headerViewController.setChartViewController(chartViewController)
  }
  
  func stopRefresh() {
    customView.refreshControl.endRefreshing()
  }
}

// MARK: - Private

private extension TokenDetailsViewController {
  func setup() {
    view.backgroundColor = .Background.page
    
    headerViewController.imageLoader = imageLoader
    
    setupListContent()
    setupAbout()
  }
  
  func setupListContent() {
    addChild(listContentViewController)
    customView.embedListView(listContentViewController.view)
    listContentViewController.didMove(toParent: self)
    
    listContentViewController.setHeaderViewController(headerViewController)
    
    listContentViewController.didStartRefresh = { [weak self] in
      self?.presenter.didPullToRefresh()
    }
  }
  
  func setupAbout() {
    guard presenter.hasAbout else { return }
    headerViewController.setAboutView(aboutView)
    aboutView.delegate = self
  }
  
  @objc
  func didPullToRefresh() {
    presenter.didPullToRefresh()
  }
}

// MARK: TonDetailsAboutViewDelegate

extension TokenDetailsViewController: TonDetailsAboutViewDelegate {
  func didTapTonButton() {
    presenter.didTapTonButton()
  }
  
  func didTapTwitterButton() {
    presenter.didTapTwitterButton()
  }
  
  func didTapChatButton() {
    presenter.didTapChatButton()
  }
  
  func didTapCommunityButton() {
    presenter.didTapCommunityButton()
  }
  
  func didTapWhitepaperButton() {
    presenter.didTapWhitepaperButton()
  }
  
  func didTapTonViewerButton() {
    presenter.didTapTonViewerButton()
  }
  
  func didTapSourceCodeButton() {
    presenter.didTapSourceCodeButton()
  }
}
