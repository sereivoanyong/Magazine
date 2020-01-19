//
//  MagazineData.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

/*
public protocol MagazineSectionController {
  
  var horizontalSpacing: CGFloat { get }
  var verticalSpacing: CGFloat { get }
  var headerController: HeaderController? { get }
  var footerController: FooterController? { get }
  var backgroundController: BackgroundInfo? { get }
  var itemControllers: [MagazineItemController] { get }
  var insetsProvider: InsetsProvider? { get }
}
*/
  
public enum InsetReference {
  
  case fromContentInset
  case fromSafeArea
  case fromLayoutMargins
  
  @inlinable public func insets(from scrollView: UIScrollView) -> UIEdgeInsets {
    let insets: UIEdgeInsets
    switch self {
    case .fromContentInset:
      insets = scrollView.contentInset
    case .fromSafeArea:
      insets = scrollView.safeAreaInsets
    case .fromLayoutMargins:
      insets = scrollView.layoutMargins
    }
    return insets
  }
}

// MARK: Section

public struct SectionController {
  
  public enum InsetsProvider {
    
    case `static`(UIEdgeInsets)
    case reference(InsetReference, top: CGFloat?, bottom: CGFloat?)
    case custom((UICollectionView) -> UIEdgeInsets)
    
    public static func reference(_ insetReference: InsetReference) -> InsetsProvider {
      return reference(insetReference, top: nil, bottom: nil)
    }
  }
  
  public var horizontalSpacing: CGFloat = 0
  public var verticalSpacing: CGFloat = 0
  public var header: HeaderController?
  public var footer: FooterController?
  public var background: BackgroundController?
  public var items: [ItemController] = []
  public var insetsProvider: InsetsProvider?
  
  public init() { }
}

public enum SectionViewProvider {
  
  case `static`(MagazineLayoutCollectionReusableView)
  case dequeued(identifier: String, (MagazineLayoutCollectionReusableView, Int) -> Void)
  
  public static func dequeued<View>(_ viewClass: View.Type, handler: @escaping (View, Int) -> Void) -> SectionViewProvider where View: MagazineLayoutCollectionReusableView {
    return dequeued(identifier: String(describing: viewClass), { view, section in
      handler(view as! View, section)
    })
  }
}

// MARK: Header

public struct HeaderController {
  
  public var visibilityMode: MagazineLayoutHeaderVisibilityMode
  public var viewProvider: SectionViewProvider
  
  public init(visibilityMode: MagazineLayoutHeaderVisibilityMode = .visible(heightMode: .dynamic, pinToVisibleBounds: false), provider: SectionViewProvider) {
    self.visibilityMode = visibilityMode
    self.viewProvider = provider
  }
}

// MARK: Footer

public struct FooterController {
  
  public var visibilityMode: MagazineLayoutFooterVisibilityMode
  public var viewProvider: SectionViewProvider
  
  public init(visibilityMode: MagazineLayoutFooterVisibilityMode = .visible(heightMode: .dynamic, pinToVisibleBounds: false), provider: SectionViewProvider) {
    self.visibilityMode = visibilityMode
    self.viewProvider = provider
  }
}

// MARK: Background

public struct BackgroundController {
  
  public var visibilityMode: MagazineLayoutBackgroundVisibilityMode
  public var viewProvider: SectionViewProvider
  
  public init(visibilityMode: MagazineLayoutBackgroundVisibilityMode = .visible, provider: SectionViewProvider) {
    self.visibilityMode = visibilityMode
    self.viewProvider = provider
  }
}

// MARK: Item

public struct ItemController {
  
  public var sizeMode: MagazineLayoutItemSizeMode
  public var cellProvider: ItemCellProvider
  
  public init(sizeMode: MagazineLayoutItemSizeMode, provider: ItemCellProvider) {
    self.sizeMode = sizeMode
    self.cellProvider = provider
  }
  
  public init(widthMode: MagazineLayoutItemWidthMode = .fullWidth(respectsHorizontalInsets: false), heightMode: MagazineLayoutItemHeightMode = .dynamic, provider: ItemCellProvider) {
    self.init(sizeMode: MagazineLayoutItemSizeMode(widthMode: widthMode, heightMode: heightMode), provider: provider)
  }
}

public enum ItemCellProvider {
  
  case staticCell(MagazineCell)
  case staticView(UIView, identifier: String = String(describing: StaticMagazineCell.self))
  case reusable(identifier: String, (MagazineCell, IndexPath) -> Void)
  
  public static func reusable<Cell>(_ cellClass: Cell.Type, handler: @escaping (Cell, IndexPath) -> Void) -> ItemCellProvider where Cell: MagazineCell {
    return reusable(identifier: String(describing: cellClass), { cell, indexPath in
      handler(cell as! Cell, indexPath)
    })
  }
}
