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
  
  public var horizontalSpacing: CGFloat?
  public var verticalSpacing: CGFloat?
  public var header: HeaderController?
  public var footer: FooterController?
  public var background: BackgroundController?
  public var items: [ItemController] = []
  public var insetsProvider: InsetsProvider?
  
  public init() { }
}

// MARK: Header

public enum HeaderViewProvider {
  
  /// Ask `collectionView` to dequeue a view using given `identifier`.
  case reusable(identifier: String, handler: (MagazineLayoutCollectionReusableView, Int) -> Void)
  
  case `static`(MagazineLayoutCollectionReusableView)
  
  /// Ask `collectionView` to dequeue a view of `MagazineHeaderView` type once and store for later use. `title` and `rightView` are automatically set.
  /// `handler` is called exactly once.
  case `default`(identifier: String = "MagazineHeaderView", title: String?, rightView: UIView? = nil, handler: ((MagazineHeaderView) -> Void)?)
  
  public static func reusable<HeaderView>(_ headerViewClass: HeaderView.Type, identifier: String = String(describing: HeaderView.self), handler: @escaping (HeaderView, Int) -> Void)
    -> HeaderViewProvider where HeaderView: MagazineLayoutCollectionReusableView {
    return reusable(identifier: identifier) { headerView, section in
      handler(headerView as! HeaderView, section)
    }
  }
}

public struct HeaderController {
  
  public var visibilityMode: MagazineLayoutHeaderVisibilityMode
  public var viewProvider: HeaderViewProvider
  
  public init(visibilityMode: MagazineLayoutHeaderVisibilityMode, provider: HeaderViewProvider) {
    self.visibilityMode = visibilityMode
    self.viewProvider = provider
  }
  
  var defaultHeaderView: MagazineHeaderView?
  public static func `default`(identifier: String = "MagazineHeaderView", title: String?, rightView: UIView? = nil, handler: ((MagazineHeaderView) -> Void)? = nil) -> HeaderController {
    return HeaderController(visibilityMode: .visible(heightMode: .dynamic), provider: .default(identifier: identifier, title: title, rightView: rightView, handler: handler))
  }
}

// MARK: Footer

public enum FooterViewProvider {
  
  /// Ask `collectionView` to dequeue a view using given `identifier`.
  case reusable(identifier: String, handler: (MagazineLayoutCollectionReusableView, Int) -> Void)
  
  case `static`(MagazineLayoutCollectionReusableView)
  
  /// Ask `collectionView` to dequeue a view of `MagazineFooterView` type once and store for later use. `text`, `isSeparatorHidden` are automatically set.
  /// `handler` is called exactly once.
  case `default`(identifier: String = "MagazineFooterView", text: String? = nil, isSeparatorHidden: Bool = false, handler: ((MagazineFooterView) -> Void)?)
  
  public static func reusable<FooterView>(_ headerViewClass: FooterView.Type, identifier: String = String(describing: FooterView.self), handler: @escaping (FooterView, Int) -> Void)
    -> FooterViewProvider where FooterView: MagazineLayoutCollectionReusableView {
    return reusable(identifier: identifier) { headerView, section in
      handler(headerView as! FooterView, section)
    }
  }
}

public struct FooterController {
  
  public var visibilityMode: MagazineLayoutFooterVisibilityMode
  public var viewProvider: FooterViewProvider
  
  public init(visibilityMode: MagazineLayoutFooterVisibilityMode = .visible(heightMode: .dynamic, pinToVisibleBounds: false), provider: FooterViewProvider) {
    self.visibilityMode = visibilityMode
    self.viewProvider = provider
  }
  
  var defaultFooterView: MagazineFooterView?
  public static func `default`(identifier: String = "MagazineFooterView", text: String? = nil, isSeparatorHidden: Bool = false, handler: ((MagazineFooterView) -> Void)? = nil) -> FooterController {
    return FooterController(visibilityMode: .visible(heightMode: .dynamic), provider: .default(identifier: identifier, text: text, isSeparatorHidden: isSeparatorHidden, handler: handler))
  }
}

// MARK: Background

public enum BackgroundViewProvider {
  
  case reusable(identifier: String, handler: (MagazineLayoutCollectionReusableView, Int) -> Void)
  case `static`(MagazineLayoutCollectionReusableView)
  case `default`(identifier: String = "MagazineBackgroundView", handler: (MagazineLayoutCollectionReusableView) -> Void)
  
  public static func dequeued<View>(_ viewClass: View.Type, handler: @escaping (View, Int) -> Void) -> BackgroundViewProvider where View: MagazineLayoutCollectionReusableView {
    return reusable(identifier: String(describing: viewClass), handler: { view, section in
      handler(view as! View, section)
    })
  }
}

public struct BackgroundController {
  
  public var visibilityMode: MagazineLayoutBackgroundVisibilityMode
  public var viewProvider: BackgroundViewProvider
  
  public init(visibilityMode: MagazineLayoutBackgroundVisibilityMode = .visible, provider: BackgroundViewProvider) {
    self.visibilityMode = visibilityMode
    self.viewProvider = provider
  }
  
  var defaultBackgroundView: MagazineLayoutCollectionReusableView?
  public static func `default`(identifier: String = "MagazineBackgroundView", handler: @escaping (MagazineLayoutCollectionReusableView) -> Void) -> BackgroundController {
    return BackgroundController(visibilityMode: .visible, provider: .default(identifier: identifier, handler: handler))
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
