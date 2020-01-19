//
//  StaticMagazineCell.swift
//
//  Created by Sereivoan Yong on 1/19/20.
//

import UIKit
import MagazineLayout

open class StaticMagazineCell: MagazineCell {
  
  /// 0: top, 1: left, 2: bottom, 3: right
  open var viewConstraints: [NSLayoutConstraint]!
  
  open var view: UIView! {
    didSet {
      precondition(!view.translatesAutoresizingMaskIntoConstraints && oldValue == nil)
      contentView.addSubview(view)
      
      viewConstraints = [
        view.topAnchor.constraint(equalTo: contentView.topAnchor),
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
      ]
      NSLayoutConstraint.activate(viewConstraints)
    }
  }
}
