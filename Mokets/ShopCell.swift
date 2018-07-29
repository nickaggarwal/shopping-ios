//
//  TutorialCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 27/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Alamofire

class ShopCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet fileprivate weak var imageCoverView: UIView!
  @IBOutlet fileprivate weak var cityNameLabel: UILabel!
  @IBOutlet fileprivate weak var CatAndSubCatLabel: UILabel!
  @IBOutlet fileprivate weak var locationLabel: UILabel!
    
    var request: Alamofire.Request?
  
    var shopmodel: ShopModel? {
        didSet {
            if let _ = shopmodel {
                cityNameLabel.text = shopmodel!.name
                CatAndSubCatLabel.text = shopmodel!.catAndSubCat
                locationLabel.text = shopmodel!.address
            }
        }
    }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    
    
    let featuredHeight = PallaxLayoutConstans.Cell.featuredHeight
    let standardHeight = PallaxLayoutConstans.Cell.standardHeight
    
    let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
    
    let minAlpha: CGFloat = 0.3
    let maxAlpha: CGFloat = 0.75
    
    imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
    
    let scale = max(delta, 0.5)
    cityNameLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    
    CatAndSubCatLabel.alpha = delta
    locationLabel.alpha = delta
  }
  
}
