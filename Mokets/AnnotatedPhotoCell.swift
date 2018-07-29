//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Alamofire

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var bgView: RoundedCornersView!
    
    var itemImage : String = ""
    var request: Alamofire.Request?
    var item: ItemModel? {
        didSet {
            if let item = item {
                itemImage = item.itemImage
                captionLabel.text = item.itemName
                lblLikeCount.text = String(item.itemLikeCount)
                lblReviewCount.text = String(item.itemReviewCount)
                bgView.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
