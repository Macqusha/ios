//
//  SettingsListCollectionController.swift
//  Tonkeeper
//
//  Created by Grigory on 2.10.23..
//

import UIKit

final class SettingsListCollectionController: NSObject {
  private weak var collectionView: UICollectionView?
  
  private let collectionLayoutConfigurator = SettingsListCollectionLayoutConfigurator()
  
  var sections = [[SettingsListCellContentView.Model]]() {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  var footerView: UIView? {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    super.init()
    setupCollectionView()
  }
}

private extension SettingsListCollectionController {
  func setupCollectionView() {
    guard let collectionView = collectionView else { return }
    collectionView.setCollectionViewLayout(collectionLayoutConfigurator.layout, animated: false)
    collectionView.register(
      SettingsListItemCollectionViewCell.self,
      forCellWithReuseIdentifier: SettingsListItemCollectionViewCell.reuseIdentifier
    )
    collectionView.register(
      CollectionViewReusableContainerView.self,
      forSupplementaryViewOfKind: CollectionViewReusableContainerView.reuseIdentifier,
      withReuseIdentifier: CollectionViewReusableContainerView.reuseIdentifier
    )
    collectionView.dataSource = self
  }
}

// MARK: UICollectionViewDataSource

extension SettingsListCollectionController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, 
                      numberOfItemsInSection section: Int) -> Int {
    sections[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, 
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SettingsListItemCollectionViewCell.reuseIdentifier,
      for: indexPath) as? SettingsListItemCollectionViewCell else { return UICollectionViewCell() }
    
    let item = sections[indexPath.section][indexPath.row]
    cell.configure(model: item)
    cell.isFirstCell = indexPath.item == 0
    cell.isLastCell = indexPath.item == sections[indexPath.section].count - 1
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, 
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == CollectionViewReusableContainerView.reuseIdentifier {
      return createFooterView(collectionView: collectionView, kind: kind, indexPath: indexPath)
    }
    return UICollectionReusableView(frame: .zero)
  }
}

private extension SettingsListCollectionController {
  func createFooterView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
    let container = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: CollectionViewReusableContainerView.reuseIdentifier,
      for: indexPath)
    if let container = container as? CollectionViewReusableContainerView {
      container.setContentView(footerView)
    }
    return container
  }
}