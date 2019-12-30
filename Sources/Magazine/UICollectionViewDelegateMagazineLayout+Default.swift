//
//  UICollectionViewDelegateMagazineLayout+Default.swift
//
//  Created by Sereivoan Yong on 1/19/20.
//

import UIKit
import MagazineLayout

extension UICollectionViewDelegateMagazineLayout {
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
    return MagazineLayoutItemSizeMode(widthMode: .fullWidth(respectsHorizontalInsets: false), heightMode: .static(height: 44))
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
    return .hidden
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, visibilityModeForFooterInSectionAtIndex index: Int) -> MagazineLayoutFooterVisibilityMode {
    return .hidden
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
    return .hidden
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
    return 0
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
    return 0
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
    return .zero
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
    var insets = collectionView.layoutMargins
    insets.top = 0
    insets.bottom = 0
    return insets
  }
}
