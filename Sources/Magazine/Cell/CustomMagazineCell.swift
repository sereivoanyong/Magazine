//
//  CustomMagazineCell.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

open class CustomMagazineCell<View>: MagazineCell where View: UIView {
  
  @objc private static var _contentViewClass: UIView.Type {
    return View.self
  }
  
  lazy open private(set) var view: View = contentView as? View ?? {
    let view = View()
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: contentView.topAnchor),
      view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])
    return view
  }()
}
