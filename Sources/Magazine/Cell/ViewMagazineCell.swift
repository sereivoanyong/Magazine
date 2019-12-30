//
//  ViewMagazineCell.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

open class ViewMagazineCell<View>: MagazineCell where View: UIView {
  
  public let view: View = View()
  
  /// A flag to whether inset `view` from `contentView.layoutMarginsGuide` or just `contentView`. Changing this property will reset `viewConstraints`
  open var insetsViewFromLayoutMargins: Bool = false {
    didSet {
      insetsViewFromLayoutMarginsDidChange(from: oldValue)
    }
  }
  
  /// 0: top, 1: left, 2: bottom, 3: right
  open var viewConstraints: [NSLayoutConstraint]!
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    viewConstraints = [
      view.topAnchor.constraint(equalTo: contentView.topAnchor),
      view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ]
    NSLayoutConstraint.activate(viewConstraints)
  }
  
  private func insetsViewFromLayoutMarginsDidChange(from oldValue: Bool) {
    guard insetsViewFromLayoutMargins != oldValue else {
      return
    }
    NSLayoutConstraint.deactivate(viewConstraints)
    if insetsViewFromLayoutMargins {
      viewConstraints = [
        view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
        view.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        contentView.layoutMarginsGuide.rightAnchor.constraint(equalTo: view.rightAnchor),
      ]
    } else {
      viewConstraints = [
        view.topAnchor.constraint(equalTo: contentView.topAnchor),
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
      ]
    }
    NSLayoutConstraint.activate(viewConstraints)
  }
}
