//
//  MagazineFooterView.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

private let kPixel: CGFloat = 1/UIScreen.main.scale

open class MagazineFooterView: MagazineLayoutCollectionReusableView {
  
  public let separatorView: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = .separator
    } else {
      // https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
      view.backgroundColor = UIColor(red: 60/255.0, green: 60/255.0, blue: 67/255.0, alpha: 0.29)
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    preservesSuperviewLayoutMargins = true
    addSubview(separatorView)
    
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 14 + kPixel),
      separatorView.heightAnchor.constraint(equalToConstant: kPixel),
      separatorView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
      layoutMarginsGuide.rightAnchor.constraint(equalTo: separatorView.rightAnchor),
      bottomAnchor.constraint(equalTo: separatorView.bottomAnchor),
    ])
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
