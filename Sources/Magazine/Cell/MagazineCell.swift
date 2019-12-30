//
//  MagazineCell.swift
//
//  Created by Sereivoan Yong on 1/18/20.
//

import UIKit
import MagazineLayout

open class MagazineCell: MagazineLayoutCollectionViewCell {
  
  open var automaticallySetsLayerShadowPath: Bool = true
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.leftAnchor.constraint(equalTo: leftAnchor),
      bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      rightAnchor.constraint(equalTo: contentView.rightAnchor),
    ])
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    
    if automaticallySetsLayerShadowPath && layer.shadowOpacity > 0 {
      layer.shadowPath = CGPath(roundedRect: bounds, cornerWidth: layer.cornerRadius, cornerHeight: layer.cornerRadius, transform: nil)
    }
  }
}
