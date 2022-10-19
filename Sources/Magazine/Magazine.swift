//
//  Magazine.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

@_exported import MagazineLayout

import UIKit

open class Magazine: NSObject {
  
  weak open var overridingDelegate: UICollectionViewDelegate?
  
  open var sections: [SectionController]
  
  open var horizontalSpacing: CGFloat = 0
  open var verticalSpacing: CGFloat = 0
  
  public init(_ sections: SectionController...) {
    self.sections = sections
  }
  
  open override func responds(to selector: Selector) -> Bool {
    if let delegate = overridingDelegate, delegate.responds(to: selector) {
      return true
    }
    return super.responds(to: selector)
  }
  
  open override func forwardingTarget(for selector: Selector!) -> Any? {
    if let delegate = overridingDelegate, delegate.responds(to: selector) {
      return delegate
    }
    return super.forwardingTarget(for: selector)
  }
}

extension Magazine: UICollectionViewDataSource {
  
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sections[section].items.count
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let controller = sections[indexPath.section].items[indexPath.item]
    switch controller.cellProvider {
    case .staticCell(let cell):
      return cell
    case .staticView(let view, let identifier):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StaticMagazineCell
      cell.view = view
      return cell
    case .reusable(let identifier, let handler):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MagazineCell
      handler(cell, indexPath)
      return cell
    }
  }
  
  open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let section = sections[indexPath.section]
    
    switch kind {
    case MagazineLayout.SupplementaryViewKind.sectionHeader:
      let controller = section.header!
      switch controller.viewProvider {
      case .reusable(let identifier, let handler):
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! MagazineLayoutCollectionReusableView
        handler(headerView, indexPath.section)
        return headerView
        
      case .static(let headerView):
        return headerView
        
      case .default(let identifier, let title, let rightView, let handler):
        if let headerView = controller.defaultHeaderView {
          return headerView
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! MagazineHeaderView
        headerView.title = title
        headerView.rightView = rightView
        handler?(headerView)
        sections[indexPath.section].header!.defaultHeaderView = headerView
        return headerView
      }
      
    case MagazineLayout.SupplementaryViewKind.sectionFooter:
      let controller = section.footer!
      switch controller.viewProvider {
      case .reusable(let identifier, let handler):
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! MagazineLayoutCollectionReusableView
        handler(headerView, indexPath.section)
        return headerView
      
      case .static(let footerView):
        return footerView
      
      case .default(let identifier, _, let isSeparatorHidden, let handler):
        if let footerView = controller.defaultFooterView {
          return footerView
        }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! MagazineFooterView
        // footerView.text = text
        footerView.separatorView.isHidden = isSeparatorHidden
        handler?(footerView)
        sections[indexPath.section].footer!.defaultFooterView = footerView
        return footerView
      }
      
    case MagazineLayout.SupplementaryViewKind.sectionBackground:
      let controller = section.background!
      switch controller.viewProvider {
      case .reusable(let identifier, let handler):
        let backgroundView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! MagazineLayoutCollectionReusableView
        handler(backgroundView, indexPath.section)
        return backgroundView
        
      case .static(let backgroundView):
        return backgroundView
        
      case .default(let identifier, let handler):
        if let backgroundView = controller.defaultBackgroundView {
          return backgroundView
        }
        let backgroundView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! MagazineLayoutCollectionReusableView
        handler(backgroundView)
        sections[indexPath.section].background!.defaultBackgroundView = backgroundView
        return backgroundView
      }
      
    default:
      fatalError()
    }
  }
}

extension Magazine: UICollectionViewDelegateMagazineLayout {
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
    return sections[indexPath.section].items[indexPath.item].sizeMode
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
    return sections[index].header?.visibilityMode ?? .hidden
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, visibilityModeForFooterInSectionAtIndex index: Int) -> MagazineLayoutFooterVisibilityMode {
    return sections[index].footer?.visibilityMode ?? .hidden
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
    return sections[index].background?.visibilityMode ?? .hidden
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
    return sections[index].horizontalSpacing ?? horizontalSpacing
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
    return sections[index].verticalSpacing ?? verticalSpacing
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
    return .zero
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
    switch sections[index].insetsProvider {
    case .none:
      return .zero
    case .static(let insets):
      return insets
    case .reference(let reference, let top, let bottom):
      let insets = reference.insets(from: collectionView)
      return UIEdgeInsets(top: top ?? insets.top, left: insets.left, bottom: bottom ?? insets.bottom, right: insets.right)
    case .custom(let provider):
      return provider(collectionView)
    }
  }
}
