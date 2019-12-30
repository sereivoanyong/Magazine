//
//  MagazineHeaderView.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

open class MagazineHeaderView: MagazineLayoutCollectionReusableView {
  
  private var fixedHeightConstraint: NSLayoutConstraint!
  private var titleBottomConstraint: NSLayoutConstraint!
  
  public static var titleFont: UIFont?
  
  public let titleLabel: UILabel = {
    let label = UILabel()
    label.font = MagazineHeaderView.titleFont ?? .systemFont(ofSize: 19, weight: .bold)
    label.textAlignment = .left
    if #available(iOS 13.0, *) {
      label.textColor = .label
    } else {
      label.textColor = .black
    }
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  /// `nil` will result in empty height
  open var title: String? {
    get { return titleLabel.text }
    set { titleLabel.text = newValue; setNeedsConstraintsUpdate() }
  }
  
  open var accessoryView: UIView? {
    didSet {
      accessoryViewDidChange(from: oldValue)
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    preservesSuperviewLayoutMargins = true
    addSubview(titleLabel)
    
    fixedHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
    titleBottomConstraint = bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
    NSLayoutConstraint.activate([
      fixedHeightConstraint,
      // Placeholder
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
      titleLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
      layoutMarginsGuide.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
    ])
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setNeedsConstraintsUpdate() {
    if titleLabel.text == nil {
      titleBottomConstraint.isActive = false
      fixedHeightConstraint.isActive = true
    } else {
      fixedHeightConstraint.isActive = false
      titleBottomConstraint.isActive = true
    }
  }
  
  private func accessoryViewDidChange(from oldValue: UIView?) {
    guard accessoryView !== oldValue else {
      return
    }
    guard let accessoryView = accessoryView else {
      oldValue?.removeFromSuperview()
      return
    }
    precondition(!accessoryView.translatesAutoresizingMaskIntoConstraints && title != nil)
    addSubview(accessoryView)
    
    NSLayoutConstraint.activate([
      accessoryView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      layoutMarginsGuide.rightAnchor.constraint(equalTo: accessoryView.rightAnchor),
    ])
  }
}
