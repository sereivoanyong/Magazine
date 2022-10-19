//
//  MagazineViewController.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

open class MagazineViewController: UIViewController {
  
  lazy open private(set) var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: MagazineLayout())
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceHorizontal = false
    collectionView.alwaysBounceVertical = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = true
    collectionView.keyboardDismissMode = .interactive
    collectionView.preservesSuperviewLayoutMargins = true
    registerCellClasses(in: collectionView)
    collectionView.isPrefetchingEnabled = false
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.delegate = self as? UICollectionViewDelegateMagazineLayout
    return collectionView
  }()
  
  open override func loadView() {
    super.loadView()
    
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
    collectionView.frame = view.bounds
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(collectionView)
  }
  
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  open func registerCellClasses(in collectionView: UICollectionView) {
    
  }
}
