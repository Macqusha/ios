//
//  ScrollContainerViewController.swift
//  Tonkeeper
//
//  Created by Grigory on 29.5.23..
//

import UIKit

protocol ScrollContainerHeaderContent: UIViewController {
  var height: CGFloat { get }
  func update(with headerScrollProgress: CGFloat)
}
 
protocol ScrollContainerBodyContent: UIViewController {
  var height: CGFloat { get }
  var didUpdateHeight: (() -> Void)? { get set }
  var didUpdateYContentOffset: ((CGFloat) -> Void)? { get set }
  func resetOffset()
  func updateYContentOffset(_ offset: CGFloat)
}

final class ScrollContainerViewController: UIViewController {
  
  var didScrollBodyToSafeArea: ((_ yOffset: CGFloat) -> Void)?
  
  private let headerContent: ScrollContainerHeaderContent
  private let bodyContent: ScrollContainerBodyContent
  
  private let scrollView = UIScrollView()
  private let panGestureScrollView = UIScrollView()
  
  init(headerContent: ScrollContainerHeaderContent,
       bodyContent: ScrollContainerBodyContent) {
    self.headerContent = headerContent
    self.bodyContent = bodyContent
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollView.frame = view.bounds
    panGestureScrollView.frame = view.bounds
    
    let headerFrame = CGRect(
      origin: .zero,
      size: .init(width: scrollView.bounds.width, height: headerContent.height)
    )
    
    let bodyFrame = CGRect(
      origin: .init(x: 0, y: headerFrame.maxY),
      size: scrollView.bounds.size
    )
    
    headerContent.view.frame = headerFrame
    bodyContent.view.frame = bodyFrame
    
    recalculateScrollViewContentSize()
    recalculatePanGestureScrollViewContentSize()
  }
}

private extension ScrollContainerViewController {
  func setup() {
    scrollView.scrollsToTop = false
    panGestureScrollView.delegate = self
    
    view.addSubview(panGestureScrollView)
    view.addSubview(scrollView)
    
    scrollView.addGestureRecognizer(panGestureScrollView.panGestureRecognizer)
    
    addChild(headerContent)
    scrollView.addSubview(headerContent.view)
    headerContent.didMove(toParent: self)
    
    addChild(bodyContent)
    scrollView.addSubview(bodyContent.view)
    bodyContent.didMove(toParent: self)
    
    bodyContent.didUpdateHeight = { [weak self] in
      self?.recalculatePanGestureScrollViewContentSize()
    }
    
    bodyContent.didUpdateYContentOffset = { [weak self, scrollView] yContentOffset in
      self?.panGestureScrollView.contentOffset.y = scrollView.contentOffset.y + yContentOffset
    }
  }
  
  func recalculateScrollViewContentSize() {
    let height = headerContent.height + bodyContent.height
    scrollView.contentSize = .init(width: scrollView.bounds.width, height: height)
  }
  
  func recalculatePanGestureScrollViewContentSize() {
    let height = bodyContent.height + headerContent.height
    panGestureScrollView.contentSize = .init(width: panGestureScrollView.bounds.width, height: height)
  }
}

extension ScrollContainerViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let bodyScrollTreshold = bodyContent.view.frame.minY - view.safeAreaInsets.top + additionalSafeAreaInsets.top
    let bodySafeAreaTreshold = bodyContent.view.frame.minY - view.safeAreaInsets.top
    
    if scrollView.contentOffset.y < bodyScrollTreshold {
      self.scrollView.contentOffset.y = scrollView.contentOffset.y
      bodyContent.resetOffset()
    } else {
      self.scrollView.contentOffset.y = bodyScrollTreshold
      bodyContent.updateYContentOffset(scrollView.contentOffset.y - self.scrollView.contentOffset.y)
    }
    
    if scrollView.contentOffset.y > bodySafeAreaTreshold {
      didScrollBodyToSafeArea?(scrollView.contentOffset.y - bodySafeAreaTreshold)
    } else {
      didScrollBodyToSafeArea?(0)
    }
    
    let headerScrollProgress = max(min((self.scrollView.contentOffset.y + view.safeAreaInsets.top) / bodyScrollTreshold, 1), 0)
    headerContent.update(with: headerScrollProgress)
  }
}
